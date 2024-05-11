Describe 'Get-SteamApp Tests' {
    Context 'When searching for a single application using ApplicationName' {
        It 'Should return the correct AppID and name' {
            $SteamApp = Get-SteamApp -ApplicationName 'Ground Branch Dedicated Server'
            $SteamApp.ApplicationName | Should -BeExactly 'GROUND BRANCH Dedicated Server'
            $SteamApp.ApplicationID | Should -BeExactly 476400
        }
    }
    Context 'When searching for a single application using ApplicationID' {
        It 'Should return the correct AppID and name' {
            $SteamApp = Get-SteamApp -ApplicationID 440
            $SteamApp.ApplicationName | Should -BeExactly 'Team Fortress 2'
            $SteamApp.ApplicationID | Should -BeExactly 440
        }
    }

    Context 'When no application is found' {
        It 'Should write an error when no application name were found' {
            { Get-SteamApp -ApplicationName 'Nonexistent Application' -ErrorAction Stop } | Should -Throw
        }
        It 'Should write an error when no application ID were found' {
            { Get-SteamApp -ApplicationID '1234567' -ErrorAction Stop } | Should -Throw
        }
    }
}
