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

Describe "Test SteamCMD cmdlets" {
    . "$($env:BHModulePath)\Private\Add-EnvPath.ps1"
    Add-EnvPath -Path 'TestDrive:\Test\SteamCMD' -Container Session

    Install-SteamCMD -InstallPath 'TestDrive:\Test' -Force

    Context "Install and update applications" {
        It "Finds steamcmd.exe" {
            Test-Path -Path "$($TestDrive)\Test\SteamCMD\steamcmd.exe" | Should -BeTrue
        }

        It "Installs Ground Branch Dedicated Server using AppID" {
            Update-SteamApp -AppID 476400 -Path "$($TestDrive)\GB-AppID" -Force
            Test-Path -Path "$($TestDrive)\GB-AppID\GroundBranchServer.exe" | Should -BeTrue
        }

        It "Installs Ground Branch Dedicated Server using Application Name" {
            Update-SteamApp -ApplicationName 'Ground Branch D' -Path "$($TestDrive)\GB-AppName" -Force
            Test-Path -Path "$($TestDrive)\GB-AppName\GroundBranchServer.exe" | Should -BeTrue
        }

        It "Passes custom argument and installs testing branch of Ground Branch Dedicated Server" {
            Update-SteamApp -AppID 476400 -Path "$($TestDrive)\GB-TestingBranch" -Arguments "-beta testing" -Force
            Test-Path -Path "$($TestDrive)\GB-TestingBranch\GroundBranchServer.exe" | Should -BeTrue
        }
    }

    # Wait for the process steamerrorreporter to be close - else test folder wont be deleted.
    Wait-Process -Name 'steamerrorreporter' -ErrorAction SilentlyContinue
}