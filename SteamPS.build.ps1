Set-BuildEnvironment -ErrorAction SilentlyContinue

# Synopsis: Initializing
Add-BuildTask Init {
    # Line break for readability in AppVeyor console
    Write-Host -Object ''
    Write-Host -Object 'Build System Details:'
    Write-Output -InputObject $PSVersionTable
    Write-Host -Object "`n"
    Get-Item env:BH*
    Write-Host -Object "`n"
}

# Synopsis: Pester Tests
Add-BuildTask Test {
    # Invoke Pester to run all of the unit tests, then save the results into XML in order to populate the AppVeyor tests section
    # If any of the tests fail, consider the pipeline failed
    $PesterResults = Invoke-Pester -Path "$($env:BHProjectPath)\Tests" -OutputFormat NUnitXml -OutputFile "$($env:BHProjectPath)\Tests\TestsResults.xml" -PassThru
    if ($PesterResults.FailedCount -gt 0) {
        throw "$($PesterResults.FailedCount) tests failed."
    } else {
        Add-TestResultToAppveyor -TestFile "$($env:BHProjectPath)\Tests\TestsResults.xml"
    }

    Remove-Item -Path "$($env:BHProjectPath)\Tests\TestsResults.xml" -Force
}

# Synopsis: Build manifest
Add-BuildTask BuildManifest {
    # We're going to add 1 to the revision value since a new commit has been merged to Master
    # This means that the major / minor / build values will be consistent across GitHub and the Gallery
    try {
        # Get current module version from Manifest.
        $Manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
        [version]$Version = $Manifest.ModuleVersion
        Write-Output -InputObject "Old Version: $($Version)"

        # Update module version in Manifest.
        switch -Wildcard ($env:BHCommitMessage) {
            '*!ver:MAJOR*' {
                New-Variable -Name NewVersion -Value $(Step-Version -Version $Version -By Major) -Scope Global
                Step-ModuleVersion -Path $env:BHPSModuleManifest -By Major
            }
            '*!ver:MINOR*' {
                New-Variable -Name NewVersion -Value $(Step-Version -Version $Version -By Minor) -Scope Global
                Step-ModuleVersion -Path $env:BHPSModuleManifest -By Minor
            }
            # Default is just changed build
            Default {
                New-Variable -Name NewVersion -Value $(Step-Version -Version $Version) -Scope Global
                Step-ModuleVersion -Path $env:BHPSModuleManifest -By Patch
            }
        }

        Write-Output -InputObject "New Version: $($NewVersion)"
        # Update yaml file with new version information.
        $AppVeyor = ConvertFrom-Yaml -Yaml $(Get-Content "$($env:BHProjectPath)\appveyor.yml" | Out-String)
        $UpdateAppVeyor = $AppVeyor.GetEnumerator() | Where-Object { $_.Name -eq 'version' }
        $UpdateAppVeyor | ForEach-Object { $AppVeyor[$_.Key] = "$($NewVersion).{build}" }
        ConvertTo-Yaml -Data $AppVeyor -OutFile "$($env:BHProjectPath)\appveyor.yml" -Force

        # Update FunctionsToExport in Manifest.
        Set-ModuleFunction
        Get-ModuleFunction

        # Update copyright notice.
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName Copyright -Value "(c) 2019-$( (Get-Date).Year ) $(Get-Metadata -Path $env:BHPSModuleManifest -PropertyName Author). All rights reserved."
    } catch {
        throw $_
    }
}

# Synopsis: Build docs
Add-BuildTask BuildDocs {
    if ($env:BHBuildSystem -ne 'Unknown' -and $env:BHBranchName -eq 'master' ) {
        # Create new markdown and XML help files.
        Write-Host -Object 'Building new function documentation' -ForegroundColor Yellow
        if ((Test-Path -Path "$($env:BHProjectPath)\docs") -eq $false) {
            New-Item -Path $env:BHProjectPath -Name 'docs' -ItemType Directory
        }

        Import-Module $env:BHPSModuleManifest -Force -Global
        New-MarkdownHelp -Module $($env:BHProjectName) -OutputFolder '.\docs\' -Force
        New-ExternalHelp -Path '.\docs\' -OutputPath ".\en-US\" -Force
        Copy-Item -Path '.\README.md' -Destination 'docs\index.md'
        Copy-Item -Path '.\CHANGELOG.md' -Destination 'docs\CHANGELOG.md'
        Copy-Item -Path '.\CONTRIBUTING.md' -Destination 'docs\CONTRIBUTING.md'
    } else {
        Write-Host -Object "Skipping building docs because `n" +
        Write-Host -Object "`t* You are on $($env:BHBranchName) and not master branch. `n"
    }
}

# Synopsis: Deploy to PSGallery
Add-BuildTask DeployPSGallery {
    # Publish the new version to the PowerShell Gallery
    try {
        Invoke-PSDeploy
        Write-Host -Object "$($env:BHProjectName) PowerShell Module version $($NewVersion) published to the PowerShell Gallery." -ForegroundColor Cyan
    } catch {
        # Sad panda; it broke
        Write-Warning -Message "Publishing update $($NewVersion) to the PowerShell Gallery failed."
        throw $_
    }
}

# Synopsis: Deploy to Github Releases
Add-BuildTask DeployGHRelease {
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
}

# Synopsis: Push changes to GitHub
Add-BuildTask PushChangesGitHub {
    # Publish the new version back to Master on GitHub
    try {
        $ErrorActionPreference = 'Continue'
        # Set up a path to the git.exe cmd, import posh-git to give us control over git, and then push changes to GitHub
        # Note that "update version" is included in the appveyor.yml file's "skip a build" regex to avoid a loop
        $env:Path += "; $env:ProgramFiles\Git\cmd"
        Import-Module -Name 'posh-git'

        git checkout master
        git add --all
        git status
        git commit -s -m "Update version to $($NewVersion)"
        git push origin master

        $ErrorActionPreference = 'Stop'
        Write-Host -Object "$($env:BHProjectName) PowerShell Module version $($NewVersion) published to GitHub." -ForegroundColor Cyan
    } catch {
        # Sad panda; it broke
        Write-Warning "Publishing update $($NewVersion) to GitHub failed."
        throw $_
    }
}

if ($env:BHBuildSystem -ne 'Unknown' -and $env:BHBranchName -eq 'master' -and $env:BHCommitMessage -like "*!deploy*") {
    # Synopsis: Entire build pipeline
    Add-BuildTask . Init, Test, BuildManifest, BuildDocs, DeployPSGallery, DeployGHRelease, PushChangesGitHub
} else {
    Add-BuildTask . Init, Test
    Write-Host -Object "Skipping deployment: To deploy, ensure that...`n"
    Write-Host -Object "`t* You are in a known build system (Current: $env:BHBuildSystem)`n"
    Write-Host -Object "`t* You are committing to the master branch (Current: $env:BHBranchName) `n"
}