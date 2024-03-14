[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Does not hold any real secret.')]
param()

    BeforeAll {
        . $SteamPSModulePath\Private\API\Get-SteamAPIKey.ps1
    }

Describe "Get-SteamAPIKey Tests" {
    Context "When SteamPSKey.json exists" {
        BeforeAll {
            # Create a dummy SteamPSKey.json file
            $SteamPSKeyLocation = "$env:AppData\SteamPS\SteamPSKey.json"
            New-Item -Path $SteamPSKeyLocation -ItemType File -Force
            $dummyKey = ConvertTo-SecureString -String "dummyKey" -AsPlainText -Force
            $dummyKey | ConvertFrom-SecureString | Set-Content -Path $SteamPSKeyLocation
        }

        AfterAll {
            # Remove the dummy SteamPSKey.json file
            Remove-Item -Path "$env:AppData\SteamPS\SteamPSKey.json" -Force
        }

        It "Should return the API key in plain text" {
            $apiKey = Get-SteamAPIKey
            $apiKey | Should -BeExactly "dummyKey"
        }
    }

    Context "When SteamPSKey.json does not exist" {
        It "Should throw an error" {
            { Get-SteamAPIKey } | Should -Throw
        }
    }
}
