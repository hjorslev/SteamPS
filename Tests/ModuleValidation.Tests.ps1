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
} # Describe