[CmdletBinding()]
Param ()

# Line break for readability in AppVeyor console
Write-Host -Object ''

Set-BuildEnvironment
Write-Host -Object "Build System Details:"
Get-Item env:BH*
Write-Output -InputObject "`n"

# Invoke Pester to run all of the unit tests, then save the results into XML in order to populate the AppVeyor tests section
# If any of the tests fail, consider the pipeline failed
$PesterResults = Invoke-Pester -Path ".\Tests" -OutputFormat NUnitXml -OutputFile ".\Tests\TestsResults.xml" -PassThru
Add-TestResultToAppveyor -TestFile "$($env:BHProjectPath)\Tests\TestsResults.xml"
if ($PesterResults.FailedCount -gt 0) {
    throw "$($PesterResults.FailedCount) tests failed."
}

Remove-Item -Path "$($env:BHProjectPath)\Tests\TestsResults.xml" -Force

# Make sure we're using the Master branch and that it's not a pull request
# Environmental Variables Guide: https://www.appveyor.com/docs/environment-variables/
if ($env:BHBranchName -ne 'master') {
    Write-Warning -Message "Skipping version increment and publish for branch $($env:BHBranchName)"
} elseif ($env:APPVEYOR_PULL_REQUEST_NUMBER -gt 0) {
    Write-Warning -Message "Skipping version increment and publish for pull request #$env:APPVEYOR_PULL_REQUEST_NUMBER"
} else {
    # We're going to add 1 to the revision value since a new commit has been merged to Master
    # This means that the major / minor / build values will be consistent across GitHub and the Gallery
    try {
        # Get current module version from Manifest.
        $Manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
        [version]$Version = $Manifest.ModuleVersion
        Write-Output -InputObject "Old Version: $Version"

        # Update module version in Manifest.
        switch -Wildcard ($env:BHCommitMessage) {
            '*!ver:MAJOR*' {
                $NewVersion = Step-Version -Version $Version -By Major
                Step-ModuleVersion -Path $env:BHPSModuleManifest -By Major
            }
            '*!ver:MINOR*' {
                $NewVersion = Step-Version -Version $Version -By Minor
                Step-ModuleVersion -Path $env:BHPSModuleManifest -By Minor
            }
            # Default is just changed build
            Default {
                $NewVersion = Step-Version -Version $Version
                Step-ModuleVersion -Path $env:BHPSModuleManifest -By Patch
            }
        }

        Write-Output -InputObject "New Version: $NewVersion"
        $AppVeyor = ConvertFrom-Yaml $(Get-Content "$($env:BHProjectPath)\appveyor.yml" | Out-String)
        $UpdateAppVeyor = $AppVeyor.GetEnumerator() | Where-Object { $_.Name -eq 'version' }
        $UpdateAppVeyor | ForEach-Object { $AppVeyor[$_.Key] = "$($NewVersion).{build}" }
        ConvertTo-Yaml -Data $AppVeyor -OutFile "$($env:BHProjectPath)\appveyor.yml" -Force

        # Update FunctionsToExport in Manifest.
        $FunctionList = ((Get-ChildItem -Path ".\$($env:BHProjectName)\Public").BaseName)
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName FunctionsToExport -Value $FunctionList

        # Update copyright notice.
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName Copyright -Value "(c) 2019-$( (Get-Date).Year ) $(Get-Metadata -Path $env:BHPSModuleManifest -PropertyName Author). All rights reserved."
    } catch {
        throw $_
    }

    # Create new markdown and XML help files
    Write-Host -Object "Building new function documentation" -ForegroundColor Yellow
    if ((Test-Path -Path "$($env:BHProjectPath)\docs") -eq $false) {
        New-Item -Path $env:BHProjectPath -Name 'docs' -ItemType Directory
    }
    Import-Module -Name "$env:BHProjectPath\$($env:BHProjectName)" -Force
    New-MarkdownHelp -Module $($env:BHProjectName) -OutputFolder '.\docs\' -Force
    New-ExternalHelp -Path '.\docs\' -OutputPath ".\en-US\" -Force
    Copy-Item -Path '.\README.md' -Destination 'docs\index.md'
    Copy-Item -Path '.\CHANGELOG.md' -Destination 'docs\CHANGELOG.md'
    Copy-Item -Path '.\CONTRIBUTING.md' -Destination 'docs\CONTRIBUTING.md'

    # Publish the new version to the PowerShell Gallery
    try {
        # Build a splat containing the required details and make sure to Stop for errors which will trigger the catch
        $PM = @{
            Path        = ".\$($env:BHProjectName)"
            NuGetApiKey = $env:NuGetApiKey
            ErrorAction = 'Stop'
        }

        Publish-Module @PM
        Write-Host -Object "$($env:BHProjectName) PowerShell Module version $($NewVersion) published to the PowerShell Gallery." -ForegroundColor Cyan
    } catch {
        # Sad panda; it broke
        Write-Warning -Message "Publishing update $($NewVersion) to the PowerShell Gallery failed."
        throw $_
    }

    # Get latest changelog and publish it to GitHub Releases.
    $ChangeLog = Get-Content -Path '.\CHANGELOG.md'
    # Expect that the latest changelog info is located at line 8.
    $ChangeLog = $ChangeLog.Where( { $_ -eq $ChangeLog[7] }, 'SkipUntil')
    # Grab all text until next heading that starts with ## [.
    $ChangeLog = $ChangeLog.Where( { $_ -eq ($ChangeLog | Select-String -Pattern "## \[" | Select-Object -Skip 1 -First 1) }, 'Until')

    # Publish GitHub Release
    $GHReleaseSplat = @{
        AccessToken     = $env:GitHubKey
        RepositoryOwner = $(Get-Metadata -Path $env:BHPSModuleManifest -PropertyName CompanyName)
        TagName         = "v$($NewVersion)"
        Name            = "v$($NewVersion) Release of $($env:BHProjectName)"
        ReleaseText     = $ChangeLog | Out-String
    }
    Publish-GithubRelease @GHReleaseSplat

    # Publish the new version back to Master on GitHub
    try {
        # Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
        # Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
        $env:Path += ";$env:ProgramFiles\Git\cmd"
        Import-Module posh-git -ErrorAction Stop
        git checkout master
        git add --all
        git status
        git commit -s -m "Update version to $($NewVersion)"
        git push origin master
        Write-Host -Object "$($env:BHProjectName) PowerShell Module version $($NewVersion) published to GitHub." -ForegroundColor Cyan
    } catch {
        # Sad panda; it broke
        Write-Warning "Publishing update $($NewVersion) to GitHub failed."
        throw $_
    }
}