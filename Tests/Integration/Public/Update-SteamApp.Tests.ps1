
Describe 'Update-SteamApp Tests' -Tag 'Integration' {
    BeforeAll {
        . "$($SteamPSModulePath)\Private\Server\Add-EnvPath.ps1"
        Add-EnvPath -Path 'TestDrive:\Test\SteamCMD'

        if  ((Test-Path -Path "$TestDrive\Test\SteamCMD\steamcmd.exe") -eq $false) {
            Install-SteamCMD -InstallPath 'TestDrive:\Test' -Force
        }
    }

    Context 'When executing Update-SteamApp' {
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