function Get-SteamFriendList {
    <#
    .SYNOPSIS
    Retrieves the friend list of a Steam user.

    .DESCRIPTION
    This cmdlet retrieves the friend list of a Steam user based on the provided SteamID64. Only data from public profiles are retrieved.

    .PARAMETER SteamID64
    Specifies the 64-bit Steam ID of the user whose friend list will be retrieved.

    .PARAMETER Relationship
    Specifies the relationship type to filter the friend list. Possible values are 'all' or 'friend'. Default is 'friend'.

    .EXAMPLE
    Get-SteamFriendList -SteamID64 76561197960435530

    Retrieves the friend list of the specified user.

    .INPUTS
    System.Int64

    .OUTPUTS
    Returns a string formatted as JSON, XML, or VDF representing the user's friend list.
    The friend list contains the following properties:
    - steamid: 64-bit Steam ID of the friend.
    - relationship: Relationship qualifier.
    - friend_since: Unix timestamp of when the relationship was established.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamFriendList.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Specifies the 64-bit Steam ID of the user whose friend list will be retrieved.',
            ValueFromPipelineByPropertyName = $true)]
        [int64]$SteamID64,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Specifies the relationship type to filter the friend list. Possible values are "all" or "friend". Default is "friend".')]
        [ValidateSet('all', 'friend')]
        [string]$Relationship = 'friend'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-RestMethod -Uri 'https://api.steampowered.com/ISteamUser/GetFriendList/v1/' -UseBasicParsing -ErrorAction SilentlyContinue -Body @{
            key          = Get-SteamAPIKey
            steamid      = $SteamID64
            relationship = $Relationship
        }

        if ($Request) {
            foreach ($Item in $Request.friendslist.friends) {
                [PSCustomObject]@{
                    SteamID64    = [int64]$Item.steamid
                    Relationship = $Item.relationship
                    FriendSince  = ((Get-Date "01.01.1970") + ([System.TimeSpan]::FromSeconds($Item.friend_since))).ToString("yyyy-MM-dd HH:mm:ss")
                }
            }
        } elseif ($null -eq $Request) {
            $Exception = [Exception]::new("No friend list found for $SteamID64. This might be because the profile is private.")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                'NoFriendsListFound',
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
