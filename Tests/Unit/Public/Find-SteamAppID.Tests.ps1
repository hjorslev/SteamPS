Describe "Find-SteamAppID Tests" {
    Context "When searching for a single application" {
        It "Should return the correct AppID and name" {
            $result = Find-SteamAppID -ApplicationName 'Ground Branch Dedicated Server'
            $result.name | Should -BeExactly 'GROUND BRANCH Dedicated Server'
            $result.appid | Should -BeExactly 476400
        }
    }

    Context "When no application is found" {
        It "Should return no result" {
            $result = Find-SteamAppID -ApplicationName 'Nonexistent Application'
            $result | Should -BeNull
        }
    }
}