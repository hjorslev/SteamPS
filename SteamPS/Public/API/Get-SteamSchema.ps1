function Get-SteamSchema {
    <#
    .SYNOPSIS
    Returns gamename, gameversion and availablegamestats (achievements and stats).

    .DESCRIPTION
    Returns gamename, gameversion and availablegamestats (achievements and stats).

    .PARAMETER AppID
    The AppID of the game you want stats of.

    .PARAMETER OutputFormat
    Format of the output. Options are json (default), xml or vdf.

    .EXAMPLE
    Get-SteamSchema -AppID 400

    .INPUTS
    int64

    .OUTPUTS
    Returns a string that is either formatted as json, xml or vdf.

    .NOTES
    Author: Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamSchema.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'The AppID of the game you want stats of.')]
        [int]$AppID,

        [Parameter(Mandatory = $false,
            HelpMessage = 'If specified, it will return language data for the requested language.')]
        [int]$Language,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Format of the output. Options are json (default), xml or vdf.')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-WebRequest -Uri "http://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?format=$OutputFormat&key=$(Get-SteamAPIKey)&appid=$AppID"

        Write-Output -InputObject $Request.Content
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet