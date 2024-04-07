Describe 'Disconnect-SteamAPI' {
    Mock -ModuleName SteamPS Write-Verbose {} -Verifiable -ParameterFilter { $Message -eq "[BEGIN  ] Starting: $($MyInvocation.MyCommand)" }
    Mock -ModuleName SteamPS Test-Path { return $true } -Verifiable -ParameterFilter { $Path -eq "$env:AppData\SteamPS\SteamPSKey.json" }
    Mock -ModuleName SteamPS Remove-Item {} -Verifiable -ParameterFilter { $Path -eq "$env:AppData\SteamPS\SteamPSKey.json" }
    Mock -ModuleName SteamPS Write-Verbose {} -Verifiable -ParameterFilter { $Message -eq "$SteamAPIKey were deleted." }
    Mock -ModuleName SteamPS [Exception]::new {} -Verifiable -ParameterFilter { $Message -eq "Steam Web API configuration file not found in '$env:AppData\SteamPS\SteamPSKey.json'." }
    Mock -ModuleName SteamPS [System.Management.Automation.ErrorRecord]::new {} -Verifiable -ParameterFilter { $CategoryInfo.Category -eq [System.Management.Automation.ErrorCategory]::ObjectNotFound }
    Mock -ModuleName SteamPS $PSCmdlet.ThrowTerminatingError {} -Verifiable -ParameterFilter { $ErrorId -eq 'SteamAPIKeyNotFound' }

    Context 'When Force is specified' {
        It 'Deletes the Steam API key file' {
            $result = Disconnect-SteamAPI -Force
            Should -InvokeVerifiable
        }
    }

    Context 'When Force is not specified' {
        Mock -ModuleName SteamPS $PSCmdlet.ShouldContinue { return $true }
        It 'Deletes the Steam API key file' {
            $result = Disconnect-SteamAPI
            Should -InvokeVerifiable
        }
    }
}
