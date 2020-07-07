Describe 'Static Analysis: Module & Repository Files' {
    #region Discovery
    $FileSearch = @{
        Path    = $env:BHProjectPath
        Include = '*.ps1', '*.psm1', '*.psd1'
        Recurse = $true
    }
    $Scripts = Get-ChildItem @FileSearch

    # TestCases are splatted to the script so we need hashtables
    $TestCases = $Scripts | ForEach-Object { @{File = $_ } }
    #endregion Discovery

    Context 'Repository Code' {
        It 'has no invalid syntax errors in <File>' -TestCases $TestCases {
            $File.FullName | Should -Exist

            $FileContents = Get-Content -Path $File.FullName -ErrorAction Stop
            $Errors = $null
            [System.Management.Automation.PSParser]::Tokenize($FileContents, [ref]$Errors) > $null
            $Errors.Count | Should -Be 0
        }
    }

    Context 'Module Import' {
        It 'cleanly imports the module' {
            { Import-Module $env:BHPSModuleManifest -Force } | Should -Not -Throw
        }

        It 'removes and re-imports the module without errors' {
            $Script = {
                Remove-Module $env:BHProjectName
                Import-Module $env:BHPSModuleManifest
            }

            $Script | Should -Not -Throw
        }
    }

    if (((Get-BuildEnvironment).BranchName -eq 'master') -and ($env:BHCommitMessage -like "*!deploy*")) {
        Context 'Changelog' {
            It 'Version in Changelog should be greater than version in Manifest' {
                # Expects that the latest version is located at line 8.
                [version]((Get-Content -Path "$env:BHProjectPath\CHANGELOG.md")[7]).Substring(4, 5) | Should -BeGreaterThan (Import-PowerShellDataFile -Path $env:BHPSModuleManifest).ModuleVersion
            }
            It 'Should not be Unreleased, but display a date' {
                ((Get-Content -Path "$env:BHProjectPath\CHANGELOG.md")[7]).Substring(13) | Should -not -BeExactly 'Unreleased'
            }
        } # Context: Changelog
    } else {
        Write-Verbose -Message "Skipping checking for 'Unreleased' string since we are on dev branch."
    }
} # Describe