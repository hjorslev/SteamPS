Describe 'Disconnect-SteamAPI Tests' {
    Context 'When Force is specified and API key is found' {
        BeforeAll {
            Mock -CommandName Test-Path -ModuleName SteamPS -MockWith { return $true } -Verifiable -ParameterFilter { $Path -eq "$env:AppData\SteamPS\SteamPSKey.json" }
            Mock -CommandName Remove-Item -ModuleName SteamPS -MockWith {} -Verifiable -ParameterFilter { $Path -eq "$env:AppData\SteamPS\SteamPSKey.json" }
        }
        It 'Deletes the Steam API key file' {
            Disconnect-SteamAPI -Force | Should -InvokeVerifiable
        }
    }
}
