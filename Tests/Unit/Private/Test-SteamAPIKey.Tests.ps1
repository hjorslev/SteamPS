BeforeAll {
    . $SteamPSModulePath\Private\API\Test-SteamAPIKey.ps1
}

Describe 'Test-SteamAPIKey Tests' {
    Context 'When the Steam API key file exists' {
        BeforeAll {
            Mock -CommandName Test-Path -MockWith { return $true }
        }

        It 'Returns $true' {
            Test-SteamAPIKey | Should -BeTrue
        }
    }

    Context 'When the Steam API key file does not exist' {
        BeforeEach {
            Mock -CommandName Test-Path -MockWith { return $false }
        }

        It 'Returns $false' {
            Test-SteamAPIKey | Should -BeFalse
        }
    }
}
