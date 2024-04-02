Describe 'Get-SteamPlayerSummary' -Tag 'Unit' {
    BeforeAll {
        . $SteamPSModulePath\Private\API\Get-SteamAPIKey.ps1
        Mock -CommandName Get-SteamAPIKey -ModuleName SteamPS -MockWith {
            return $true
        }
    }

    Context 'With valid SteamID64' {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return '{
                    "response": {
                        "players": [
                            {
                                "steamid": "12345678901234567",
                                "communityvisibilitystate": 3,
                                "profilestate": 1,
                                "personaname": "TestUser",
                                "commentpermission": 1,
                                "profileurl": "https://steamcommunity.com/id/testuser/",
                                "avatar": "https://example.com/avatar.jpg",
                                "avatarmedium": "https://example.com/avatar_medium.jpg",
                                "avatarfull": "https://example.com/avatar_full.jpg",
                                "avatarhash": "abcdef123456",
                                "lastlogoff": 1712083677,
                                "personastate": 1,
                                "realname": "John Doe",
                                "primaryclanid": "987654321098765432",
                                "timecreated": 1577836800,
                                "gameid": 16900,
                                "gameserverip": "1.2.3.4",
                                "gameextrainfo": "Test Game",
                                "personastateflags": 0,
                                "loccountrycode": "US",
                                "locstatecode": "CA",
                                "loccityid": 54321
                            }
                        ]
                    }
                }' | ConvertFrom-Json
            }
        }

        It 'Should return player summary' {
            $PlayerSummary = Get-SteamPlayerSummary -SteamID64 12345678901234567
            $PlayerSummary.SteamID64 | Should -Be '12345678901234567'
            $PlayerSummary.PersonaState | Should -BeExactly 'Online'
            $PlayerSummary.CommunityVisibilityState | Should -BeExactly 'Public'
            $PlayerSummary.LastLogOff | Should -BeExactly '2024-04-02 18:47:57'
            $PlayerSummary.TimeCreated | Should -BeExactly '2020-01-01 00:00:00'
            $PlayerSummary.GameServerIP | Should -BeExactly '1.2.3.4'
            $PlayerSummary.GameServerIP | Should -BeOfType ipaddress
        }
    }

    Context 'With invalid SteamID64' {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return '{"players":[{}]}' | ConvertFrom-Json
            }
        }

        It 'Should throw an error' {
            { Get-SteamPlayerSummary -SteamID64 12345678901234567890 -ErrorAction Stop } | Should -Throw
        }
    }
}
