Describe 'Disconnect-SteamAPI Tests' {
    Context 'With an API key' {
        BeforeAll {
            Mock -CommandName Test-Path -ModuleName SteamPS -MockWith {
                return $true
            }
            Mock -CommandName Remove-Item -ModuleName SteamPS -MockWith {
                return $true
            }
        }
        It 'Should remove the API key when -Force is used' {
            { Disconnect-SteamAPI -Force | Should -Not -Throw }
        }
    }

    Context 'Without an API key' {
        BeforeAll {
            Mock -CommandName Test-Path -ModuleName SteamPS -MockWith {
                return $false
            }
            Mock -CommandName Remove-Item -ModuleName SteamPS -MockWith {
                return $false
            }
        }
        It 'Should fail when no API key is found' {
            { Disconnect-SteamAPI -Force | Should -Throw }
        }
    }
}