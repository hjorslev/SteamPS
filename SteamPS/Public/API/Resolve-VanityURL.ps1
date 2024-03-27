function Resolve-VanityURL {
    <#
    .SYNOPSIS
    Retrieves the SteamID64 associated with a given vanity URL (custom URL) from Steam Community.

    .DESCRIPTION
    This function retrieves the SteamID64 associated with a given vanity URL (custom URL) from Steam Community using the Steam Web API.

    .PARAMETER VanityURL
    Specifies the vanity URL (custom URL) to retrieve the SteamID64 for.

    .PARAMETER UrlType
    Specifies the type of vanity URL. Valid values are: 1 (default) for individual profile, 2 for group, and 3 for official game group.

    .EXAMPLE
    Resolve-VanityURL -VanityURL "examplevanityurl"

    Retrieves the SteamID64 associated with the vanity URL "examplevanityurl".

    .INPUTS
    Accepts string input for the VanityURL parameter.

    .OUTPUTS
    Returns a custom object with the VanityURL and associated SteamID64.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Resolve-VanityURL.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Enter the vanity URL (also named custom URL) to get a SteamID for.')]
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
            $Request = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/?key=$(Get-SteamAPIKey)&vanityurl=$Item&url_type=$UrlType" -UseBasicParsing

            Write-Verbose -Message 'API response:'
            Write-Verbose -Message $Request

            if (($Request.Content | ConvertFrom-Json).response.success -eq '1') {
                [PSCustomObject]@{
                    'VanityURL' = $Item
                    'SteamID64' = ([int64]($Request.Content | ConvertFrom-Json).response.steamid)
                }
            } elseif (($Request.Content | ConvertFrom-Json).response.success -eq '42') {
                $Exception = [Exception]::new("Unable to find $Item.")
                $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                    $Exception,
                    "VanityURLNotFound",
                    [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                ($Request.Content | ConvertFrom-Json).response.success
                )
                $PSCmdlet.WriteError($ErrorRecord)
            }
        }
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet