Describe "Get-SteamPlayerBan" {
    BeforeAll {
        . $SteamPSModulePath\Private\API\Get-SteamAPIKey.ps1
        Mock -CommandName Get-SteamAPIKey -ModuleName SteamPS -MockWith {
            return $true
        }
    }

    Context "With valid Steam ID" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return '{
                "players": [
                    {
                        "SteamId": "76561197983367235",
                        "CommunityBanned": false,
                        "VACBanned": false,
                        "NumberOfVACBans": 0,
                        "DaysSinceLastBan": 0,
                        "NumberOfGameBans": 0,
                        "EconomyBan": "none"
                    }
                ]
            }' | ConvertFrom-Json
            }
        }

        It "Should return ban information" {
            $result = Get-SteamPlayerBan -SteamID64 76561197983367235
            $result | Should -Not -BeNullOrEmpty
            $result.SteamID64 | Should -BeExactly 76561197983367235
            $result.CommunityBanned | Should -Be $false
            $result.VACBanned | Should -Be $false
            $result.NumberOfVACBans | Should -Be 0
            $result.DaysSinceLastBan | Should -Be 0
            $result.NumberOfGameBans | Should -Be 0
            $result.EconomyBan | Should -Be "none"
        }
    }

    Context "With invalid Steam ID" {
        It "Should throw an error" {
            { Get-SteamPlayerBan -SteamID64 12345 } | Should -Throw
        }
    }
}
