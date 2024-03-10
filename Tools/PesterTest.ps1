[CmdletBinding()]
param (
    # The path where the Pester Tests are
    [Parameter(Mandatory)]
    [String] $TestPath,

    # The path where we export the Pester Results (Pester.xml, Coverage.xml, Coverage.json)
    [Parameter(Mandatory)]
    [String] $ResultPath,

    # The path to the Source Code
    [Parameter(Mandatory)]
    [string] $SourceRoot,

    # The path to the built Module
    [Parameter(Mandatory)]
    [string] $ReleasePath
)

$ErrorActionPreference = 'Stop'

$requirements = Import-PowerShellDataFile ([IO.Path]::Combine($PSScriptRoot, 'requiredModules.psd1'))
foreach ($req in $requirements.GetEnumerator() | Sort-Object { $_.Value['Priority'] }) {
    $importModuleSplat = @{
        Name                = ([IO.Path]::Combine($PSScriptRoot, 'Modules', $req.Key))
        Force               = $true
        DisableNameChecking = $true
    }

    Write-Host "Importing: $($importModuleSplat['Name'])"
    Import-Module @importModuleSplat
}

[PSCustomObject] $PSVersionTable |
    Select-Object -Property *, @{
        Name       = 'Architecture'
        Expression = {
            switch ([IntPtr]::Size) {
                4 {
                    'x86'
                }
                8 {
                    'x64'
                }
                default {
                    'Unknown'
                }
            }
        }
    } |
    Format-List |
    Out-Host

$configuration = [PesterConfiguration]::Default
$configuration.Output.Verbosity = 'Detailed'
$configuration.Run.PassThru = $true
$configuration.CodeCoverage.Enabled = $true
$configuration.CodeCoverage.Path = $ReleasePath
$configuration.CodeCoverage.OutputPath = [IO.Path]::Combine($ResultPath, 'Coverage.xml')
$configuration.Run.Throw = $true
$configuration.Run.Path = $TestPath
$configuration.TestResult.Enabled = $true
$configuration.TestResult.OutputPath = [IO.Path]::Combine($ResultPath, 'Pester.xml')
$configuration.TestResult.OutputFormat = 'NUnitXml'

$pesterResult = Invoke-Pester -Configuration $configuration -WarningAction Ignore

Push-Location $SourceRoot

$out = [ordered]@{
    coverage = [ordered]@{}
    messages = [ordered]@{}
}

$coverageReults = @(
    $pesterResult.CodeCoverage.CommandsMissed
    $pesterResult.CodeCoverage.CommandsExecuted
) | Convert-LineNumber -Passthru

$groups = $coverageReults | Group-Object SourceFile | ForEach-Object {
    $out['coverage'][$_.Name] = [System.Collections.Generic.List[Object]]::new((, $null))
    $out['messages'][$_.Name] = [ordered]@{}
    $_
}

foreach ($group in $groups) {
    $map = $group.Group | Group-Object SourceLineNumber -AsHashTable -AsString
    $totalLines = [System.Linq.Enumerable]::Count(
        [System.IO.File]::ReadLines((Get-Item $group.Name).FullName))

    foreach ($line in 1..$totalLines) {
        $line = $line.ToString()
        if ($map.ContainsKey($line)) {
            $out['coverage'][$group.Name].Add($map[$line].HitCount)
            $out['messages'][$group.Name][$line] = $map[$line].Command
            continue
        }

        $out['coverage'][$group.Name].Add($null)
    }
}

$out | ConvertTo-Json -Depth 99 |
    Set-Content ([IO.Path]::Combine($ResultPath, 'Coverage.json'))

Pop-Location
