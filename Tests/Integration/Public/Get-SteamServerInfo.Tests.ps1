Describe "Get-SteamServerInfo Tests" {
    Context "When querying a valid server" {
        It "Should return server information" {
            # Mocking the Get-SteamServerInfo function
            Mock Get-SteamServerInfo {
                [PSCustomObject]@{
                    Protocol      = 17
                    ServerName    = "SAS Proving Ground 10 (EU)"
                    Map           = "TH-SmallTown"
                    InstallDir    = "groundbranch"
                    GameName      = "Ground Branch"
                    AppID         = 16900
                    Players       = 6
                    MaxPlayers    = 10
                    Bots          = 0
                    ServerType    = "Dedicated"
                    Environment   = "Windows"
                    Visibility    = "Public"
                    VAC           = "Unsecured"
                    Version       = "1.0.0.0"
                    ExtraDataFlag = 177
                    IPAddress     = "135.239.211.40"
                    Port          = 27015
                    Ping          = 65
                }
            }

            # Invoke the function under test
            $result = Get-SteamServerInfo -IPAddress '135.239.211.40' -Port 27015

            # Assertions
            $result | Should -Not -BeNullOrEmpty
            $result.ServerName | Should -Be "SAS Proving Ground 10 (EU)"
            $result.Map | Should -Be "TH-SmallTown"
            $result.InstallDir | Should -Be "groundbranch"
            $result.GameName | Should -Be "Ground Branch"
            $result.AppID | Should -Be 16900
            $result.Players | Should -Be 6
            $result.MaxPlayers | Should -Be 10
            $result.Bots | Should -Be 0
            $result.ServerType | Should -Be "Dedicated"
            $result.Environment | Should -Be "Windows"
            $result.Visibility | Should -Be "Public"
            $result.VAC | Should -Be "Unsecured"
            $result.Version | Should -Be "1.0.0.0"
            $result.IPAddress | Should -Be "135.239.211.40"
            $result.Port | Should -Be 27015
            $result.Ping | Should -Be 65
        }
    }

    Context "When querying an invalid server" {
        It "Should throw an error" {
            # Mocking the Get-SteamServerInfo function to simulate failure
            Mock Get-SteamServerInfo {
                throw "Server not found"
            }

            # Invoke the function under test and capture the exception
            $errorActionPreference = 'Stop'
            { Get-SteamServerInfo -IPAddress 'invalid' -Port 1234 } | Should -Throw
            $errorActionPreference = 'Continue'
        }
    }
}
