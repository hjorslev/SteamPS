BeforeAll {
    . $SteamPSModulePath\Private\API\Test-SteamAPIKey.ps1
}

Describe 'Test-SteamAPIKey Tests' {
    Context 'When the Steam API key file exists' {
        BeforeAll {
            # Create a dummy SteamPSKey.json file
            $SteamPSKeyLocation = "$env:AppData\SteamPS\SteamPSKey.json"
            New-Item -Path $SteamPSKeyLocation -ItemType File -Force
        }
        AfterAll {
            # Remove the dummy SteamPSKey.json file
            Remove-Item -Path "$env:AppData\SteamPS\SteamPSKey.json" -Force
        }

        It 'Returns $true' {
            $result = Test-SteamAPIKey
            $result | Should -BeOfType [bool]
            $result | Should -Be $true
        }
    }

    Context 'When the Steam API key file does not exist' {
        It 'Returns $false' {
            $result = Test-SteamAPIKey
            $result | Should -BeOfType [bool]
            $result | Should -Be $false
        }
    }
}
