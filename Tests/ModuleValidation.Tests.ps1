$ProjectRoot = Resolve-Path "$($PSScriptRoot)/.."
$ModuleRoot = Split-Path (Resolve-Path "$($ProjectRoot)/*/*.psm1")
$ModuleName = Split-Path $ModuleRoot -Leaf

$PublicFiles = @(Get-ChildItem -Path "$($ProjectRoot)\Public\*.ps1" -ErrorAction SilentlyContinue)
$ModuleInformation = Import-Metadata -Path "$($ProjectRoot)\$($ModuleName)\$($ModuleName).psd1"

Describe "General project validation: $($ModuleName)" {
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

    Context 'Manifest' {
        It 'Should contains RootModule' { $ModuleInformation.RootModule | Should not BeNullOrEmpty }
        It 'Should contains Author' { $ModuleInformation.Author | Should not BeNullOrEmpty }
        It 'Should contains Company Name' { $ModuleInformation.CompanyName | Should not BeNullOrEmpty }
        It 'Should contains Description' { $ModuleInformation.Description | Should not BeNullOrEmpty }
        It 'Should contains Copyright' { $ModuleInformation.Copyright | Should not BeNullOrEmpty }
        It 'Should contains License' { $ModuleInformation.PrivateData.PSData.LicenseURI | Should not BeNullOrEmpty }
        It 'Should contains a Project Link' { $ModuleInformation.PrivateData.PSData.ProjectURI | Should not BeNullOrEmpty }
        It 'Should contain Tags (For the PSGallery)' { $ModuleInformation.Tags.count | Should not BeNullOrEmpty }

        It "Should have equal number of Function Exported and the Public PS1 files found ($($ExportedFunctions.Count) and $($PublicFiles.count))" {
            $ExportedFunctions.count -eq $publicFiles.count | Should -Be $true }

        It "Compare the missing function" {
            if (-not($ExportedFunctions.count -eq $publicFiles.Count)) {
                $Commandompare = Compare-Object -ReferenceObject $ExportedFunctions -DifferenceObject $publicFiles.basename
                $Commandompare.inputobject -join ',' | Should BeNullOrEmpty
            }
        }
    }
}