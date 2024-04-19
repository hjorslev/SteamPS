function Get-SteamFriendList {
    <#
    .SYNOPSIS
    Fetches the friend list of tje specified Steam user.

    .DESCRIPTION
    This cmdlet fetches the friend list of a Steam user using the provided SteamID64. It retrieves data only from public profiles.

    .PARAMETER SteamID64
    The 64-bit Steam ID of the user whose friend list is to be fetched.

    .PARAMETER Relationship
    The relationship type used to filter the friend list. The possible values are 'all' or 'friend'. The default is 'friend'.

    .EXAMPLE
    Get-SteamFriendList -SteamID64 76561197960435530
    This example fetches the friend list of the user with the specified SteamID64.

    .INPUTS
    System.Int64

    .OUTPUTS
    Outputs a string formatted as JSON, XML, or VDF representing the user's friend list.
    The friend list includes the following properties:
    - steamid: The friend's 64-bit Steam ID.
    - relationship: The qualifier of the relationship.
    - friend_since: The Unix timestamp indicating when the relationship was established.

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
