function Get-SteamAPIKey {
    <#
    .SYNOPSIS
    Grabs API key secure string from file and converts back to plaintext.

    .DESCRIPTION
    Grabs API key secure string from file and converts back to plaintext.

    .EXAMPLE
    Get-SteamAPIKey

    Returns the API key secure string in plain text.

    .NOTES
    Author: sysgoblin (https://github.com/sysgoblin) and Frederik Hjorslev Poulsen
    #>

    [CmdletBinding()]
    Param (
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $SteamPSKey = Test-Path -Path "$env:AppData\SteamPS\SteamPSKey.json"
        if (-not ($SteamPSKey)) {
            $Exception = [Exception]::new("Steam Web API configuration file not found in '$env:AppData\SteamPS\SteamPSKey.json'. Run Connect-SteamAPI to configure an API key.")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                "SteamAPIKeyNotFound",
                [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                $SteamPSKey # usually the object that triggered the error, if possible
            )
            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        } else {
            try {
                $Config = Get-Content "$env:AppData\SteamPS\SteamPSKey.json"
                $APIKeySecString = $Config | ConvertTo-SecureString
                $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($APIKeySecString)
                $APIKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

                Write-Output -InputObject $APIKey
            } catch {
                $Exception = [Exception]::new("Could not decrypt API key from configuration file not found in '$env:AppData\SteamPS\SteamPSKey.json'. Run Connect-SteamAPI to configure an API key.")
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    $Exception,
                    "InvalidAPIKey",
                    [System.Management.Automation.ErrorCategory]::ParserError,
                    $APIKey # usually the object that triggered the error, if possible
                )
                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }
        }
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet