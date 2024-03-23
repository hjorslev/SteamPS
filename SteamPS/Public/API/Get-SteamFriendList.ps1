function Get-SteamFriendList {
    <#
    .SYNOPSIS
    Returns the friend list of any Steam user.

    .DESCRIPTION
    Retrieves the friend list of a Steam user whose profile visibility is set to "Public".

    .PARAMETER SteamID64
    Specifies the 64-bit Steam ID of the user whose friend list will be retrieved.

    .PARAMETER Relationship
    Specifies the relationship type to filter the friend list. Possible values are 'all' or 'friend'. Default is 'friend'.

    .PARAMETER OutputFormat
    Specifies the format of the output. Options are 'json' (default), 'xml', or 'vdf'.

    .EXAMPLE
    Get-SteamFriendList -SteamID64 76561197960435530

    Retrieves the friend list of the specified user.

    .EXAMPLE
    Get-SteamFriendList -SteamID64 76561197960435530 -OutputFormat xml

    Retrieves the friend list of the specified user and outputs it in XML format.

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
        [string]$Relationship = 'friend',

        [Parameter(Mandatory = $false,
            HelpMessage = 'Specifies the format of the output. Options are "json" (default), "xml", or "vdf".')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUser/GetFriendList/v1/?key=$(Get-SteamAPIKey)&steamid=$SteamID64&relationship=$Relationship&format=$OutputFormat" -UseBasicParsing

        Write-Output -InputObject $Request.Content
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet
