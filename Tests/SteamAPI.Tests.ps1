Describe "Find-SteamAppID" {
    It "Finds game 'Ground Branch'" {
        $GB = Find-SteamAppID -ApplicationName 'Ground Branch Dedicated Server'
        $GB.appid | Should -Be 476400
        $GB.name | Should -Be 'Ground Branch Dedicated Server'
    }
}