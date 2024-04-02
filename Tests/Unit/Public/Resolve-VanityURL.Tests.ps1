Describe 'Resolve-VanityURL Tests' -Tag 'Unit' {
    BeforeAll {
        . $SteamPSModulePath\Private\API\Get-SteamAPIKey.ps1
        Mock -CommandName Get-SteamAPIKey -ModuleName SteamPS -MockWith {
            return $true
        }
    }

    Context 'When resolving a valid VanityURL' {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return '{"response":{"steamid":"7656119711117235","success": 1}}' | ConvertFrom-Json
            } # Mock
        }
        It 'Should return a PSCustomObject with SteamID64' {
            (Resolve-VanityURL -VanityURL 'Toby').SteamID64 | Should -BeExactly 7656119711117235
        }
    }

    Context 'When resolving an invalid VanityURL' {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return '{"response":{"success": 42,"message": "No match"}}' | ConvertFrom-Json
            } # Mock
        }

        It 'Should throw an error' {
            { Resolve-VanityURL -VanityURL 'invalidVanityURL' -ErrorAction Stop } | Should -Throw
        }
    }

    Context 'When resolving an invalid, fully qualified VanityURL' {
        It 'Should throw an error' {
            { Resolve-VanityURL -VanityURL 'https://steamcommunity.com/id/test' } | Should -Throw
        }
    }
}
