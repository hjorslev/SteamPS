function Get-SteamNews {
    <#
    .SYNOPSIS
    Returns the latest news of a game specified by its AppID.

    .DESCRIPTION
    Returns the latest news of a game specified by its AppID.

    .PARAMETER AppID
    AppID of the game you want the news of.

    .PARAMETER Count
    How many news entries you want to get returned.

    .PARAMETER MaxLength
    Maximum length of each news entry.

    .PARAMETER OutputFormat
    Format of the output. Options are json (default), xml or vdf.

    .EXAMPLE
    Get-SteamNews -AppID 440

    Lists number of news that are available for the AppID.

    .EXAMPLE
    Get-SteamNews -AppID 440 -Count 1

    Retrieves 1 (the latest) news item for the AppID 440.

    .INPUTS
    int64

    .OUTPUTS
    Returns a string that is either formatted as json, xml or vdf.

    An appnews object containing:

    appid, the AppID of the game you want news of

    newsitems, an array of news item information:
    - An ID, title and url.
    - A shortened excerpt of the contents (to maxlength characters), terminated by "..." if longer than maxlength.
    - A comma-separated string of labels and UNIX timestamp.

    .NOTES
    Author: Frederik Hjorslelv Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamNews.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'AppID of the game you want the news of.')]
        [int]$AppID,

        [Parameter(Mandatory = $false,
            HelpMessage = 'How many news entries you want to get returned.')]
        [int]$Count,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Maximum length of each news entry.')]
        [int]$MaxLength,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Format of the output. Options are json (default), xml or vdf.')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-WebRequest -Uri "http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=$AppID&count=$Count&maxlength=$MaxLength&format=$OutputFormat"

        Write-Output -InputObject $Request.Content
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet