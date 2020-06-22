Describe "General project validation: $env:BHProjectName" {
    BeforeEach {
        $FileSearch = @{
            Path    = $env:BHProjectPath
            Include = '*.ps1', '*.psm1', '*.psd1'
            Recurse = $true
        }
        $Scripts = Get-ChildItem @FileSearch

        # TestCases are splatted to the script so we need hashtables
        $TestCases = $Scripts | ForEach-Object { @{File = $_ } }
    }

    Context "Project Files" {
        It '<File> should be valid PowerShell' -TestCases $TestCases {
            param($File)

            $File.FullName | Should -Exist

            $FileContents = Get-Content -Path $File.FullName -ErrorAction Stop
            $Errors = $null
            [System.Management.Automation.PSParser]::Tokenize($FileContents, [ref]$Errors) > $null
            $Errors.Count | Should -Be 0
        }

        It 'can cleanly import the module' {
            { Import-Module $env:BHPSModuleManifest -Force } | Should -Not -Throw
        }

        It 'can remove and re-import the module without errors' {
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