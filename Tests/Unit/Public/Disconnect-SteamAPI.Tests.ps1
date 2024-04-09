Describe 'Disconnect-SteamAPI Tests' {
    BeforeAll {
        Mock -ModuleName SteamPS Test-Path { return $true } -Verifiable -ParameterFilter { $Path -eq "$env:AppData\SteamPS\SteamPSKey.json" }
        Mock -ModuleName SteamPS Remove-Item {} -Verifiable -ParameterFilter { $Path -eq "$env:AppData\SteamPS\SteamPSKey.json" }
    }

    Context 'When Force is specified' {
        It 'Deletes the Steam API key file' {
            Disconnect-SteamAPI -Force -Verbose | Should -InvokeVerifiable
        }
    }
}
