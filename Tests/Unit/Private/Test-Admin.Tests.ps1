BeforeAll {
    . $SteamPSModulePath\Private\Server\Test-Admin.ps1
}

Describe 'Test-Admin Tests' {
    Context 'Function: Test-Admin' {
        It 'Should not throw' {
            { Test-Admin } | Should -Not -Throw
        }

        It 'Should return <Expected> for <OS> based runners' -ForEach @(
            @{
                Expected = if ($IsLinux -or $IsMacOS) {
                    $false
                } else {
                    $true
                }
                OS       = if ($IsLinux -or $IsMacOS) {
                    'Unix'
                } else {
                    'Windows'
                }
            }
        ) {
            Test-Admin | Should -Be $Expected
        }
    }
}
