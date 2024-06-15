function Test-SteamAPIKey {
    <#
    .SYNOPSIS
    Tests whether a Steam API key file exists.

    .DESCRIPTION
    The `Test-SteamAPIKey` cmdlet checks if a Steam API key file exists in the specified path.
    It returns a boolean value indicating whether the key file is present.

    .OUTPUTS
    System.Boolean
    Returns `$true` if the Steam API key file exists; otherwise, returns `$false`.

    .EXAMPLE
    PS C:\> Test-SteamAPIKey
    True

    Description:
    This example checks if the Steam API key file exists and returns `True`.

    .EXAMPLE
    PS C:\> Test-SteamAPIKey
    False

    Description:
    This example checks if the Steam API key file exists and returns `False`.

    .NOTES
    Author: Frederik Hjorslev Nylander
    #>

    [CmdletBinding()]
    [OutputType('System.Boolean')]
    param (
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
        $SteamPSKey = Test-Path -Path "$env:AppData\SteamPS\SteamPSKey.json"
    }

    process {
        if ($SteamPSKey -eq $true) {
            return [bool]$true
        } elseif ($SteamPSKey -eq $false) {
            return [bool]$false
        }
    }

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
}