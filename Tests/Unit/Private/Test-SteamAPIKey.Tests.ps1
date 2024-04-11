BeforeAll {
    . $SteamPSModulePath\Private\API\Test-SteamAPIKey.ps1
}

Describe 'Test-SteamAPIKey Tests' {
    Context 'When the Steam API key file exists' {
        BeforeAll {
            Mock -CommandName Test-Path -ModuleName SteamPS -MockWith { $true }
        }
        It 'Returns $true' {
            $result = Test-SteamAPIKey
            $result | Should -BeOfType [bool]
            $result | Should -Be $true
        }
    }

    Context 'When the Steam API key file does not exist' {
        BeforeAll {
            Mock -CommandName Test-Path -ModuleName SteamPS -MockWith { $false }
        }
        It 'Returns $false' {
            $result = Test-SteamAPIKey
            $result | Should -BeOfType [bool]
            $result | Should -Be $false
        }
    }
}
