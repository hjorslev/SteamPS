function Resolve-VanityURL {
    <#
    .SYNOPSIS
    Retrieves the SteamID64 linked to a specified vanity URL (custom URL) from the Steam Community.

    .DESCRIPTION
    Using the Steam Web API, this cmdlet fetches the SteamID64 that corresponds to a provided vanity URL (custom URL) from the Steam Community.

    .PARAMETER VanityURL
    This parameter specifies the vanity URL (custom URL) for which the SteamID64 is to be retrieved.

    .PARAMETER UrlType
    This parameter defines the type of vanity URL. The valid values are: 1 (default) for an individual profile, 2 for a group, and 3 for an official game group.

    .EXAMPLE
    Resolve-VanityURL -VanityURL user
    This example retrieves the SteamID64 linked to the vanity URL 'user'.

    .EXAMPLE
    Resolve-VanityURL -VanityURL user1, user2
    This example retrieves the SteamID64s linked to the vanity URLs 'user1' and 'user2'.

    .INPUTS
    The VanityURL parameter accepts string input.

    .OUTPUTS
    The cmdlet returns a custom object containing the VanityURL and its associated SteamID64.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Resolve-VanityURL.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Enter the vanity URL (custom URL) for which the SteamID64 is to be retrieved.')]
        [ValidateScript( {
                if (([System.URI]$_ ).IsAbsoluteUri -eq $true) {
                    throw "Do not enter the fully qualified URL, but just the ID (e.g.) everything after https://steamcommunity.com/id/"
                }
                $true
            })]
        [string[]]$VanityURL,

        [Parameter(Mandatory = $false,
            HelpMessage = 'The type of vanity URL. 1 (default): Individual profile, 2: Group, 3: Official game group.')]
        [ValidateSet(1, 2, 3)]
        [int]$UrlType = 1
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        foreach ($Item in $VanityURL) {
            $Request = Invoke-RestMethod -Uri 'https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/' -UseBasicParsing -Body @{
                key       = Get-SteamAPIKey
                vanityurl = $Item
                url_type  = $UrlType
            }

            if ($Request.response.success -eq '1') {
                [PSCustomObject]@{
                    'VanityURL' = $Item
                    'SteamID64' = ([int64]$Request.response.steamid)
                }
            } elseif ($Request.response.success -eq '42') {
                $Exception = [Exception]::new("Unable to find $Item.")
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    $Exception,
                    "VanityURLNotFound",
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                $Request.response.success
                )
                $PSCmdlet.WriteError($ErrorRecord)
            }
        }
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet