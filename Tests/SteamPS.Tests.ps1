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

Describe "Install with SteamCMD" {
    Add-EnvPath -Path 'TestDrive:\Test\SteamCMD' -Container Session
    New-Item -Path 'TestDrive:' -Name 'GB-AppID' -ItemType Directory
    New-Item -Path 'TestDrive:' -Name 'GB-AppName' -ItemType Directory

    Install-SteamCMD -InstallPath 'TestDrive:\Test' -Force

    Context "Install applications" {
        It "Installs Ground Branch Dedicated Server using AppID" {
            Update-SteamApp -AppID 476400 -Path 'TestDrive:\GB-AppID' -Force
            Test-Path -Path 'TestDrive:\GB-AppID\GroundBranchServer.exe' | Should -Exist
        }

        It "Installs Ground Branch Dedicated Server using Application Name" {
            Update-SteamApp -ApplicationName 'Ground Branch D' -Path 'TestDrive:\GB-AppName' -Force
            Test-Path -Path 'TestDrive:\GB-AppName\GroundBranchServer.exe' | Should -Exist
        }
    }

    # Wait for the process steamerrorreporter to be close - else test folder wont be deleted.
    Wait-Process -Name 'steamerrorreporter' -ErrorAction SilentlyContinue
}