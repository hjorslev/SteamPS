Describe 'Test-SteamAPIKey Tests' {
    Context 'When the Steam API key file exists' {
        BeforeAll {
            Mock Test-Path { $true }
        }
        It 'Returns $true' {
            $result = Test-SteamAPIKey
            $result | Should -BeOfType [bool]
            $result | Should -Be $true
        }
    }

    Context 'When the Steam API key file does not exist' {
        BeforeAll {
            Mock Test-Path { $false }
        }
        It 'Returns $false' {
            $result = Test-SteamAPIKey
            $result | Should -BeOfType [bool]
            $result | Should -Be $false
        }
    }
}
