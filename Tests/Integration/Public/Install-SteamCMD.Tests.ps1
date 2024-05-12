
Describe 'Install-SteamCMD Tests' -Tag 'Integration' {
    BeforeAll {
        . "$($SteamPSModulePath)\Private\Server\Add-EnvPath.ps1"
        Add-EnvPath -Path 'TestDrive:\Test\SteamCMD'
    }

    Context 'When executing Install-SteamCMD' {
        It 'Should install SteamCMD' {
            Install-SteamCMD -InstallPath 'TestDrive:\Test' -Force
        }

        It 'Should find steamcmd.exe' {
            Test-Path -Path "$TestDrive\Test\SteamCMD\steamcmd.exe" | Should -BeTrue
        }
    }

    AfterAll {
        # Wait for the process steamerrorreporter to be closed - else test folder wont be deleted.
        Wait-Process -Name 'steamerrorreporter' -ErrorAction SilentlyContinue
    }
}
