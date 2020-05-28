﻿
$PublicFiles = @(Get-ChildItem -Path "$env:BHModulePath\Public\*.ps1" -ErrorAction SilentlyContinue)
$ModuleInformation = Import-Metadata -Path $env:BHPSModuleManifest # Cmdlet from module Configuration.
$ExportedFunctions = (Import-Module -Name $env:BHPSModuleManifest -Force -ErrorAction Stop -PassThru).ExportedFunctions.Values.Name

Describe "General Project Validation: $env:BHProjectName" {
    Context "Project Files" {
        $FileSearch = @{
            Path    = $env:BHProjectPath
            Include = '*.ps1', '*.psm1', '*.psd1'
            Recurse = $true
        }
        $Scripts = Get-ChildItem @FileSearch

        # TestCases are splatted to the script so we need hashtables
        $TestCases = $Scripts | ForEach-Object { @{File = $_ } }
        It "<File> should be valid powershell" -TestCases $TestCases {
            param($File)

            $File.FullName | Should -Exist

            $FileContents = Get-Content -Path $File.FullName -ErrorAction Stop
            $Errors = $null
            [System.Management.Automation.PSParser]::Tokenize($FileContents, [ref]$Errors) > $null
            $Errors.Count | Should -Be 0
        }

        It "'$env:BHProjectName' can import cleanly" {
 { Import-Module "$env:BHModulePath\$env:BHProjectName.psm1" -Force } | Should -Not -Throw
        }
    }

    Context 'Manifest' {
        It 'Should contain RootModule' { $ModuleInformation.RootModule | Should -Not -BeNullOrEmpty }
        It 'RootModule should not contain default value' { $ModuleInformation.RootModule | Should -Not -BeExactly 'ModuleName.psm1' }
        It 'Should contain GUID' { $ModuleInformation.GUID | Should -Not -BeNullOrEmpty }
        It 'Should contain Author' { $ModuleInformation.Author | Should -Not -BeNullOrEmpty }
        It 'Should contain Company Name' { $ModuleInformation.CompanyName | Should -Not -BeNullOrEmpty }
        It 'Should contain Description' { $ModuleInformation.Description | Should -Not -BeNullOrEmpty }
        It 'Description should not contain default value' { $ModuleInformation.Description | Should -Not -BeExactly 'Module Description' }
        It 'Should contain Copyright' { $ModuleInformation.Copyright | Should -Not -BeNullOrEmpty }
        It 'Copyright should not contain default value' { $ModuleInformation.Copyright | Should -Not -BeExactly '(c) 2019 FIRST LAST. All rights reserved.' }
        It 'Should contain License' { $ModuleInformation.PrivateData.PSData.LicenseURI | Should -Not -BeNullOrEmpty }
        It 'Should contain a Project Link' { $ModuleInformation.PrivateData.PSData.ProjectURI | Should -Not -BeNullOrEmpty }
        It 'Should contain Tags (For the PSGallery)' { $ModuleInformation.Tags.Count | Should -Not -BeNullOrEmpty }

        It "Should have equal number of Function Exported and the Public PS1 files found $($ExportedFunctions.Count) and $($PublicFiles.Count))" {
            $ExportedFunctions.Count -eq $PublicFiles.Count | Should -Be $true }

        It 'Compare the missing function' {
            if (-not ($ExportedFunctions.Count -eq $PublicFiles.Count)) {
                $Commandompare = Compare-Object -ReferenceObject $ExportedFunctions -DifferenceObject $PublicFiles.BaseName
                $Commandompare.InputObject -join ',' | Should -BeNullOrEmpty
            }
        }
    } # Context: Manifest

    if ((Get-BuildEnvironment).BranchName -eq 'master') {
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