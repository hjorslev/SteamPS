BeforeAll {
    function Get-SteamAPIKey {}
    InModuleScope $env:BHProjectName {
        Mock -CommandName Get-SteamAPIKey -MockWith {
            Write-Output -InputObject $env:STEAMWEBAPI
        }
    }
}

Describe 'Steam Web API' {
    Context "Find-SteamAppID" {
        BeforeEach {
            $Response = [PSCustomObject]@{
                Content = Get-Content -Path "$env:BHProjectPath\Tests\data\applist.json"
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                $Response
            }
        }
        It "Finds game 'Ground Branch'" {
            $GB = Find-SteamAppID -ApplicationName 'Ground Branch Dedicated Server'
            $GB.appid | Should -Be 476400
            $GB.name | Should -Be 'Ground Branch Dedicated Server'
        }
    }

    Context 'Get-SteamFriendList' {
        BeforeEach {
            $Response = [PSCustomObject]@{
                Content = Get-Content -Path "$env:BHProjectPath\Tests\data\friendlist.json"
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                $Response
            }
        }

        It "Finds a Steam friend with ID '76561197960265738" {
            $FriendList = Get-SteamFriendList -SteamID64 76561197960435530 | ConvertFrom-Json
            $FriendList.friendslist.friends.steamid[1] | Should -BeExactly 76561197960265738
        }
    }

    Context 'Get-SteamNews' {
        BeforeEach {
            $Response = [PSCustomObject]@{
                Content = Get-Content -Path "$env:BHProjectPath\Tests\data\appnews.json"
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                $Response
            }
        }

        It "Finds the post entitled 'Lockdown Throwdown 2'" {
            $AppNews = Get-SteamNews -AppID 440 | ConvertFrom-Json
            $AppNews.appnews.newsitems.title | Should -BeExactly 'Lockdown Throwdown 2'
        }
    }

    Context 'Get-SteamPlayerBan' {
        BeforeEach {
            $Response = [PSCustomObject]@{
                Content = Get-Content -Path "$env:BHProjectPath\Tests\data\playerban.json"
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                $Response
            }
        }

        It 'Finds a player with a fine record' {
            $PlayerBans = Get-SteamPlayerBan -SteamID64 76561197960435530 | ConvertFrom-Json
            $PlayerBans = $PlayerBans.players | Where-Object -FilterScript { $_.SteamId -eq 76561197960435530 }
            $PlayerBans.SteamId | Should -BeExactly 76561197960435530
            $PlayerBans.NumberOfVACBans | Should -BeExactly 0
        }

        It 'Finds a player with a less than fine record' {
            $PlayerBans = Get-SteamPlayerBan -SteamID64 76561197960434622 | ConvertFrom-Json
            $PlayerBans = $PlayerBans.players | Where-Object -FilterScript { $_.SteamId -eq 76561197960434622 }
            $PlayerBans.SteamId | Should -BeExactly 76561197960434622
            $PlayerBans.NumberOfVACBans | Should -BeExactly 3413
        }
    }

    Context 'Get-SteamPlayerSummary' {
        BeforeEach {
            $Response = [PSCustomObject]@{
                Content = Get-Content -Path "$env:BHProjectPath\Tests\data\playersummary.json"
            }
            Mock -CommandName Invoke-WebRequest -MockWith {
                $Response
            }
        }

        It "Finds player 'Toby the First'" {
            $PlayerSummary = Get-SteamPlayerSummary -SteamID64 76561197960435530 | ConvertFrom-Json
            $PlayerSummary.response.players.realname | Should -BeExactly 'Toby the First'
        }
    }

    Context 'Resolve-VanityURL' {
        It "Resolves an individual profile" {
            (Resolve-VanityURL -VanityURL 'hjorslev').SteamID64 | Should -BeExactly 76561197983367235
        }
        It "Resolves a group" {
            (Resolve-VanityURL -VanityURL 'SASEliteVirtualRegiment' -UrlType 2).SteamID64 | Should -BeExactly 103582791433675899
        }
    }
} # Describe