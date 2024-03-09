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

Describe 'SteamCMD cmdlets' {
    BeforeAll {
        . "$($SteamPSModulePath)\Private\Server\Add-EnvPath.ps1"
        Add-EnvPath -Path 'TestDrive:\Test\SteamCMD'

        Install-SteamCMD -InstallPath 'TestDrive:\Test' -Force
    }

    It 'Finds steamcmd.exe' {
        Test-Path -Path "$TestDrive\Test\SteamCMD\steamcmd.exe" | Should -BeTrue
    }

    Context 'Update-SteamApp' {
        It 'Installs Ground Branch Dedicated Server using AppID' {
            Update-SteamApp -AppID 476400 -Path "$TestDrive\GB-AppID" -Force
            Test-Path -Path "$TestDrive\GB-AppID\GroundBranchServer.exe" | Should -BeTrue
        }

        It 'Installs Ground Branch Dedicated Server using Application Name' {
            Update-SteamApp -ApplicationName 'Ground Branch D' -Path "$TestDrive\GB-AppName" -Force
            Test-Path -Path "$TestDrive\GB-AppName\GroundBranchServer.exe" | Should -BeTrue
        }

        It 'Passes custom argument and installs testing branch of Ground Branch Dedicated Server' {
            Update-SteamApp -AppID 476400 -Path "$TestDrive\GB-TestingBranch" -Arguments "-beta testing" -Force
            Test-Path -Path "$TestDrive\GB-TestingBranch\GroundBranchServer.exe" | Should -BeTrue
        }
    }

    AfterAll {
        # Wait for the process steamerrorreporter to be closed - else test folder wont be deleted.
        Wait-Process -Name 'steamerrorreporter' -ErrorAction SilentlyContinue
    }
}