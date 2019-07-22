$ProjectRoot = Resolve-Path "$($PSScriptRoot)/.."
$ModuleRoot = Split-Path (Resolve-Path "$($ProjectRoot)/*/*.psm1")
$ModuleName = Split-Path $ModuleRoot -Leaf

$PublicFiles = @(Get-ChildItem -Path "$($ProjectRoot)\Public\*.ps1" -ErrorAction SilentlyContinue)
$ModuleInformation = Import-Metadata -Path "$($ProjectRoot)\$($ModuleName)\$($ModuleName).psd1" # Cmdlet from module Configuration.

Describe "General Project Validation: $($ModuleName)" {
    Context "Project Files" {
        $FileSearch = @{
            Path    = $ProjectRoot
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

        It "'$ModuleName' can import cleanly" {
            { Import-Module (Join-Path $ModuleRoot "$ModuleName.psm1") -Force } | Should -Not -Throw
        }
    }

    Context 'Manifest' {
        It 'Should contain RootModule' { $ModuleInformation.RootModule | Should -Not -BeNullOrEmpty }
        It 'Should contain Author' { $ModuleInformation.Author | Should -Not -BeNullOrEmpty }
        It 'Should contain Company Name' { $ModuleInformation.CompanyName | Should -Not -BeNullOrEmpty }
        It 'Should contain Description' { $ModuleInformation.Description | Should -Not -BeNullOrEmpty }
        It 'Should contain Copyright' { $ModuleInformation.Copyright | Should -Not -BeNullOrEmpty }
        It 'Should contain License' { $ModuleInformation.PrivateData.PSData.LicenseURI | Should -Not -BeNullOrEmpty }
        It 'Should contain a Project Link' { $ModuleInformation.PrivateData.PSData.ProjectURI | Should -Not -BeNullOrEmpty }
        It 'Should contain Tags (For the PSGallery)' { $ModuleInformation.Tags.Count | Should -Not -BeNullOrEmpty }

        It "Should have equal number of Function Exported and the Public PS1 files found ($($ExportedFunctions.Count) and $($PublicFiles.Count))" {
            $ExportedFunctions.Count -eq $PublicFiles.Count | Should -Be $true }

        It "Compare the missing function" {
            if (-not ($ExportedFunctions.Count -eq $PublicFiles.Count)) {
                $Commandompare = Compare-Object -ReferenceObject $ExportedFunctions -DifferenceObject $PublicFiles.BaseName
                $Commandompare.InputObject -join ',' | Should -BeNullOrEmpty
            }
        }
    } # Context: Manifest

    Context "Changelog" {
        It "Version in Changelog should be greater than version in Manifest" {
            # Expects that the latest version is located at line 8.
            $ChangeLog = [version]((Get-Content -Path "$($ProjectRoot)\CHANGELOG.md")[7]).Substring(4, 5) | Should -BeGreaterThan (Test-ModuleManifest -Path ".\$($ModuleName)\$($ModuleName).psd1").Version
        }

        It "Should not be Unreleased, but display a date" {
            ((Get-Content -Path "$($ProjectRoot)\CHANGELOG.md")[7]).Substring(13) | Should -not -BeExactly 'Unreleased'
        }
    } # Context: Changelog
} # Describe