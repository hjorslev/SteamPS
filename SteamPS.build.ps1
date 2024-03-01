[CmdletBinding()]
param(
    [ValidateSet('Debug', 'Release')]
    [string] $Configuration = 'Debug'
)

$global:SteamPSModulePath = [IO.Path]::Combine($PSScriptRoot, 'SteamPS')
$manifestItem = Get-Item ([IO.Path]::Combine($SteamPSModulePath, '*.psd1'))
$ModuleName = $manifestItem.BaseName
$psm1 = Join-Path $SteamPSModulePath -ChildPath ($ModuleName + '.psm1')

$testModuleManifestSplat = @{
    Path          = $manifestItem.FullName
    ErrorAction   = 'Ignore'
    WarningAction = 'Ignore'
}

$Manifest = Test-ModuleManifest @testModuleManifestSplat
$Version = $Manifest.Version

$BuildPath = [IO.Path]::Combine($PSScriptRoot, 'output')
$CSharpPath = [IO.Path]::Combine($PSScriptRoot, 'src', $ModuleName)
$isBinaryModule = Test-Path $CSharpPath
$ReleasePath = [IO.Path]::Combine($BuildPath, $ModuleName, $Version)
$UseNativeArguments = $PSVersionTable.PSVersion -gt '7.0'

task Clean {
    if (Test-Path $ReleasePath) {
        Remove-Item $ReleasePath -Recurse -Force
    }

    New-Item -ItemType Directory $ReleasePath | Out-Null
}

task BuildDocs {
    $helpParams = @{
        Path       = [IO.Path]::Combine($PSScriptRoot, 'docs', 'en-US')
        OutputPath = [IO.Path]::Combine($ReleasePath, 'en-US')
    }
    New-ExternalHelp @helpParams | Out-Null
}

task BuildPowerShell {
    $buildModuleSplat = @{
        SourcePath      = $SteamPSModulePath
        OutputDirectory = $ReleasePath
        Encoding        = 'UTF8Bom'
        IgnoreAlias     = $true
    }

    if (Test-Path $psm1) {
        $buildModuleSplat['Suffix'] = Get-Content $psm1 -Raw
    }

    Build-Module @buildModuleSplat
}

task BuildManaged {
    if (-not $isBinaryModule) {
        Write-Host 'No C# source path found. Skipping BuildManaged...'
        return
    }

    $arguments = @(
        'publish'
        '--configuration', $Configuration
        '--verbosity', 'q'
        '-nologo'
        "-p:Version=$Version"
    )

    Push-Location -LiteralPath $CSharpPath
    try {
        foreach ($framework in $TargetFrameworks) {
            Write-Host "Compiling for $framework"
            dotnet @arguments --framework $framework

            if ($LASTEXITCODE) {
                throw "Failed to compiled code for $framework"
            }
        }
    }
    finally {
        Pop-Location
    }
}

task CopyToRelease {
    foreach ($framework in $TargetFrameworks) {
        $buildFolder = [IO.Path]::Combine($CSharpPath, 'bin', $Configuration, $framework, 'publish')
        $binFolder = [IO.Path]::Combine($ReleasePath, 'bin', $framework, $_.Name)
        if (-not (Test-Path -LiteralPath $binFolder)) {
            New-Item -Path $binFolder -ItemType Directory | Out-Null
        }
        Copy-Item ([IO.Path]::Combine($buildFolder, '*')) -Destination $binFolder -Recurse
    }
}

task Package {
    $nupkgPath = [IO.Path]::Combine($BuildPath, "$ModuleName.$Version*.nupkg")
    if (Test-Path $nupkgPath) {
        Remove-Item $nupkgPath -Force
    }

    $repoParams = @{
        Name               = 'LocalRepo'
        SourceLocation     = $BuildPath
        PublishLocation    = $BuildPath
        InstallationPolicy = 'Trusted'
    }

    if (Get-PSRepository -Name $repoParams.Name -ErrorAction SilentlyContinue) {
        Unregister-PSRepository -Name $repoParams.Name
    }

    Register-PSRepository @repoParams

    try {
        Publish-Module -Path $ReleasePath -Repository $repoParams.Name
    }
    finally {
        Unregister-PSRepository -Name $repoParams.Name
    }
}

task Analyze {
    $analyzerPath = [IO.Path]::Combine($PSScriptRoot, 'PSScriptAnalyzerSettings.psd1')
    if (-not (Test-Path $analyzerPath)) {
        Write-Host 'No analyzer rules found, skipping...'
        return
    }

    $pssaSplat = @{
        Path        = $ReleasePath
        Settings    = [IO.Path]::Combine($PSScriptRoot, 'PSScriptAnalyzerSettings.psd1')
        Recurse     = $true
        ErrorAction = 'SilentlyContinue'
    }
    $results = Invoke-ScriptAnalyzer @pssaSplat

    if ($null -ne $results) {
        $results | Out-String
        throw 'Failed PsScriptAnalyzer tests, build failed'
    }
}

task DoUnitTest {
    $testsPath = [IO.Path]::Combine($PSScriptRoot, 'Tests', 'units')
    if (-not (Test-Path -LiteralPath $testsPath)) {
        Write-Host 'No unit tests found, skipping...'
        return
    }

    $resultsPath = [IO.Path]::Combine($BuildPath, 'TestResults')
    if (-not (Test-Path -LiteralPath $resultsPath)) {
        New-Item $resultsPath -ItemType Directory -ErrorAction Stop | Out-Null
    }

    $tempResultsPath = [IO.Path]::Combine($resultsPath, 'TempUnit')
    if (Test-Path -LiteralPath $tempResultsPath) {
        Remove-Item -LiteralPath $tempResultsPath -Force -Recurse
    }
    New-Item -Path $tempResultsPath -ItemType Directory | Out-Null

    try {
        $runSettingsPrefix = 'DataCollectionRunSettings.DataCollectors.DataCollector.Configuration'
        $arguments = @(
            'test'
            $testsPath
            '--results-directory', $tempResultsPath
            if ($Configuration -eq 'Debug') {
                '--collect:"XPlat Code Coverage"'
                '--'
                "$runSettingsPrefix.Format=json"
                if ($UseNativeArguments) {
                    "$runSettingsPrefix.IncludeDirectory=`"$CSharpPath`""
                }
                else {
                    "$runSettingsPrefix.IncludeDirectory=\`"$CSharpPath\`""
                }
            }
        )

        Write-Host 'Running unit tests'
        dotnet @arguments

        if ($LASTEXITCODE) {
            throw 'Unit tests failed'
        }

        if ($Configuration -eq 'Debug') {
            Move-Item -Path $tempResultsPath/*/*.json -Destination $resultsPath/UnitCoverage.json -Force
        }
    }
    finally {
        Remove-Item -LiteralPath $tempResultsPath -Force -Recurse
    }
}

task DoTest {
    $testsPath = [IO.Path]::Combine($PSScriptRoot, 'Tests')
    if (-not (Test-Path $testsPath)) {
        Write-Host 'No Pester tests found, skipping...'
        return
    }

    $resultsPath = [IO.Path]::Combine($BuildPath, 'TestResults')
    if (-not (Test-Path $resultsPath)) {
        New-Item $resultsPath -ItemType Directory -ErrorAction Stop | Out-Null
    }

    Get-ChildItem -LiteralPath $resultsPath |
        Remove-Item -ErrorAction Stop -Force

    $pesterScript = [IO.Path]::Combine($PSScriptRoot, 'tools', 'PesterTest.ps1')

    $testArgs = @{
        TestPath    = $testsPath
        ResultPath  = $resultsPath
        SourceRoot  = $SteamPSModulePath
        ReleasePath = $ReleasePath
    }

    & $pesterScript @testArgs
}

task Build -Jobs Clean, BuildManaged, BuildPowerShell, CopyToRelease, BuildDocs, Package
task Test -Jobs BuildManaged, Analyze, DoUnitTest, DoTest
task . Build
