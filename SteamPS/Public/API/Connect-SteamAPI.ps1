function Connect-SteamAPI {
    <#
    .SYNOPSIS
    Create or update the Steam Web API config file.

    .DESCRIPTION
    Create or update the Steam Web API config file which contains the API key
    used to authenticate to those Steam Web API's that require authentication.

    .EXAMPLE
    Connect-SteamAPI
    Prompts the user for a Steam Web API key and sets the specified input within
    the config file.

    .INPUTS
    None. You cannot pipe objects to Connect-SteamAPI.

    .OUTPUTS
    None. Nothing is returned when calling Connect-SteamAPI.

    .NOTES
    Author: sysgoblin (https://github.com/sysgoblin) and Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Connect-SteamAPI.html
    #>

    [CmdletBinding()]
    param (
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        if (-not (Test-Path -Path "$env:AppData\SteamPS\SteamPSKey.json")) {
            try {
                $TargetObject = New-Item -Path "$env:AppData\SteamPS\SteamPSKey.json" -Force
                Write-Verbose -Message "Created config file at $env:AppData\SteamPS\SteamPSKey.json"
            } catch {
                $Exception = [Exception]::new("Unable to create file $env:AppData\SteamPS\SteamPSKey.json")
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    $Exception,
                    "CreateSteamAPIKeyFailed",
                    [System.Management.Automation.ErrorCategory]::WriteError,
                    $TargetObject # usually the object that triggered the error, if possible
                )
                $PSCmdlet.ThrowTerminatingError($ErrorRecord)
            }
        }

        $APIKey = Read-Host -Prompt 'Enter your Steam Web API key' -AsSecureString
        $Key = ConvertFrom-SecureString -SecureString $APIKey
        $Key | Out-File "$($env:AppData)\SteamPS\SteamPSKey.json" -Force
        Write-Verbose -Message "Saved key as secure string to config file."
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet