
Describe 'Update-SteamServer Tests' -Tag 'Unit' {
    Context 'When executing Update-SteamServer without SteamCMD installed' {
        BeforeAll {
            Mock -CommandName Test-Admin -ModuleName SteamPS -MockWith {
                return $true
            }
            Mock -CommandName Get-SteamPath -ModuleName SteamPS -MockWith {
                return $null
            }
            Mock -CommandName Get-Service -ModuleName SteamPS -MockWith {
                return @{ Name = 'GB-PG10' }
            }
        }
        It 'Should throw an error' {
            { Update-SteamServer -AppID 476400 -ServiceName 'GB-PG10' -IPAddress '1.1.1.1' -Port 27015 } | Should -Throw 'SteamCMD could not be found in the env:Path. Have you executed Install-SteamCMD?'
        }
    }

    Context 'When executing Update-SteamServer with insufficient permissions' {
        BeforeAll {
            Mock -CommandName Test-Admin -ModuleName SteamPS -MockWith {
                return $false
            }
            Mock -CommandName Get-SteamPath -ModuleName SteamPS -MockWith {
                return [PSCustomObject]@{
                    'Path'       = 'C:\Program Files\'
                    'Executable' = 'C:\Program Files\steamcmd.exe'
                }
            }
            Mock -CommandName Get-Service -ModuleName SteamPS -MockWith {
                return @{ Name = 'GB-PG10' }
            }
        }
        It 'Should throw an error' {
            { Update-SteamServer -AppID 476400 -ServiceName 'GB-PG10' -IPAddress '1.1.1.1' -Port 27015 } | Should -Throw 'The current PowerShell session is not running as Administrator. Start PowerShell by using the Run as Administrator option, and then try running the script again.'
        }
    }
}
