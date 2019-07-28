Describe "Find-SteamAppID" {
    It "Finds game 'Ground Branch'" {
        $GB = Find-SteamAppID -ApplicationName 'Ground Branch Dedicated Server'
        $GB.appid | Should -Be 476400
        $GB.name | Should -Be 'Ground Branch Dedicated Server'
    }
}

Describe "Get-SteamServerInfo" {
    It "Finds information about a Steam based game server" {
        $ServerInfo = Get-SteamServerInfo -ServerID 2743
        $ServerInfo.hostname | Should -Be 'SAS Proving Ground 10 (EU)'
    }
}