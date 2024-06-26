﻿Describe 'Get-SteamFriendList Tests' -Tag 'Unit' {
    BeforeAll {
        . $SteamPSModulePath\Private\API\Get-SteamAPIKey.ps1
        Mock -CommandName Get-SteamAPIKey -ModuleName SteamPS -MockWith {
            return $true
        }
    }

    Context 'When retrieving friend list' {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return '{ "friendslist": { "friends":[ { "steamid":"11111197987580876", "relationship":"friend", "friend_since":1454562868 }, { "steamid":"99991197997032827", "relationship":"friend", "friend_since":1614836906 }] } }' | ConvertFrom-Json
            } # Mock
        } # Context

        It 'Retrieves friend list correctly' {
            $FriendList = Get-SteamFriendList -SteamID64 123456789

            # Check if the FriendList is not null
            $FriendList | Should -Not -BeNullOrEmpty

            $FriendList[0].SteamID64 | Should -Be '11111197987580876'
            $FriendList[0].Relationship | Should -Be 'friend'
            $FriendList[0].FriendSince | Should -Be '2016-02-04 05:14:28'

            $FriendList[1].SteamID64 | Should -Be '99991197997032827'
            $FriendList[1].Relationship | Should -Be 'friend'
            $FriendList[1].FriendSince | Should -Be '2021-03-04 05:48:26'
        }

        Context 'With invalid SteamID64' {
            It 'Throws an error' {
                { Get-SteamFriendList -SteamID64 'invalidID' } | Should -Throw
            }
        }
    }

    Context 'With a private profile' {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return $null
            } # Mock
        }
        It 'Writes an error' {
            { Get-SteamFriendList -SteamID64 1234567890 -ErrorAction Stop } | Should -Throw
        }
    }
}
