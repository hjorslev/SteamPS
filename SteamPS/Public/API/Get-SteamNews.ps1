function Get-SteamNews {
    <#
    .SYNOPSIS
    Fetches the latest news for a game using its AppID.

    .DESCRIPTION
    Fetches the latest news for a game using its AppID from the Steam API.

    .PARAMETER AppID
    The AppID of the game for which the news is to be fetched.

    .PARAMETER Count
    The number of news entries to fetch. By default, it fetches all news entries.

    .PARAMETER MaxLength
    The maximum length for each news entry. Entries longer than this will be truncated. By default, there is no truncation.

    .EXAMPLE
    Get-SteamNews -AppID 440

    This example fetches all available news entries for the game with AppID 440.

    .EXAMPLE
    Get-SteamNews -AppID 440 -Count 1

    This example fetches the most recent news entry for the game with AppID 440.

    .EXAMPLE
    Get-SteamNews -AppID 440 -MaxLength 100

    This example fetches all available news entries for the game with AppID 440 and truncates the news content to 100 characters.

    .INPUTS
    System.Int32

    .OUTPUTS
    Outputs an object containing:
    - GID: The ID of the news item.
    - Title: The title of the news item.
    - Url: The URL of the news item.
    - IsExternalUrl: A boolean indicating if the URL is external.
    - Author: The author of the news item.
    - Contents: The content of the news item.
    - FeedLabel: The label of the news feed.
    - Date: The date and time when the news item was published.
    - FeedName: The name of the news feed.
    - FeedType: The type of the news feed.
    - AppID: The AppID of the game associated with the news item.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamNews.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Specifies the AppID of the game for which you want to retrieve news.')]
        [int]$AppID,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Specifies the number of news entries to retrieve.')]
        [int]$Count,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Specifies the maximum length of each news entry.')]
        [int]$MaxLength
    )


    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        # TODO: When only supporting pwsh use null coalescing operator (??)
        # to handle the case when $Count or $MaxLength is not defined
        $Body = @{
            appid = $AppID
        }
        if ($Count) {
            $Body.Add('count', $Count)
        }
        if ($MaxLength) {
            $Body.Add('maxlength', $MaxLength)
        }
        $Request = Invoke-RestMethod -Uri 'http://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/' -UseBasicParsing -Body $Body

        if ($Request) {
            foreach ($Item in $Request.appnews.newsitems) {
                [PSCustomObject]@{
                    GID           = [int64]$Item.gid
                    Title         = $Item.title
                    Url           = $Item.url
                    IsExternalUrl = [bool]$Item.is_external_url
                    Author        = $Item.author
                    Contents      = $Item.contents
                    FeedLabel     = $Item.feedlabel
                    Date          = ((Get-Date "01.01.1970") + ([System.TimeSpan]::FromSeconds($Item.date))).ToString("yyyy-MM-dd HH:mm:ss")
                    FeedName      = $Item.feedname
                    FeedType      = $Item.feed_type
                    AppID         = $Item.appid
                }
            }
        } elseif ($null -eq $Request) {
            $Exception = [Exception]::new("No news found for $AppID.")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                'NoNewsFound',
                [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                $Request
            )
            $PSCmdlet.WriteError($ErrorRecord)
        }
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet