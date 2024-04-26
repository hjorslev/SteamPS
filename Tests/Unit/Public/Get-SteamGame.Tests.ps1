Describe 'Get-SteamGame Tests' {
    Context 'When searching for a single application using ApplicationName' {
        It 'Should return the correct AppID and name' {
            $SteamApp = Get-SteamGame -ApplicationName 'Ground Branch Dedicated Server'
            $SteamApp.ApplicationName | Should -BeExactly 'GROUND BRANCH Dedicated Server'
            $SteamApp.ApplicationID | Should -BeExactly 476400
        }
    }
    Context 'When searching for a single application using ApplicationID' {
        It 'Should return the correct AppID and name' {
            $SteamApp = Get-SteamGame -ApplicationID 440
            $SteamApp.ApplicationName | Should -BeExactly 'Team Fortress 2'
            $SteamApp.ApplicationID | Should -BeExactly 440
        }
    }

    Context 'When no application is found' {
        It 'Should return no result' {
            $SteamApp = Get-SteamGame -ApplicationName 'Nonexistent Application'
            $SteamApp | Should -BeNull
        }
    }
}
