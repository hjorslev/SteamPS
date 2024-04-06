Describe 'Disconnect-SteamAPI' {
    BeforeAll {
        Mock -CommandName Test-Path -MockWith { return $true }
        Mock -CommandName Remove-Item -MockWith {}
    }

    It 'removes the API key when -Force is used' {
        Disconnect-SteamAPI -Force
        Should -Invoke Test-Path -Times 1 -Scope It
        Should -Invoke Remove-Item -Times 1 -Scope It
    }
}
