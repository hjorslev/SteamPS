function Disconnect-SteamAPI {
    <#
    .SYNOPSIS
    Disconnects from the Steam API by removing the stored API key.

    .DESCRIPTION
    The Disconnect-SteamAPI cmdlet removes the stored Steam API key from the system. This effectively disconnects the current session from the Steam API.

    .PARAMETER Force
    When the Force switch is used, the cmdlet will skip the confirmation prompt and directly remove the API key.

    .EXAMPLE
    Disconnect-SteamAPI -Force

    This command will remove the stored Steam API key without asking for confirmation.

    .INPUTS
    None. You cannot pipe objects to Disconnect-SteamAPI.

    .OUTPUTS
    None. Nothing is returned when calling Disconnect-SteamAPI.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Disconnect-SteamAPI.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,
            HelpMessage = 'Skip the confirmation prompt.')][switch]$Force
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
        $SteamAPIKey = "$env:AppData\SteamPS\SteamPSKey.json"
    }

    process {
        if ($Force -or $PSCmdlet.ShouldContinue($SteamAPIKey, 'Do you want to continue removing the API key?')) {
            if (Test-Path -Path $SteamAPIKey) {
                Remove-Item -Path $SteamAPIKey -Force
                Write-Verbose -Message "$SteamAPIKey were deleted."
            } else {
                $Exception = [Exception]::new("Steam Web API configuration file not found in '$env:AppData\SteamPS\SteamPSKey.json'.")
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    $Exception,
                    'SteamAPIKeyNotFound',
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                    $SteamPSKey
                )
                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }
        }
    }

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
}