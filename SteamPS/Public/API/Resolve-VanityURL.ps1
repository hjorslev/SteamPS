function Resolve-VanityURL {
    <#
    .SYNOPSIS
    Resolve a vanity URL (also named custom URL).

    .DESCRIPTION
    Resolve a vanity URL (also named custom URL) and return the 64 bit SteamID
    that belongs to said URL.

    .PARAMETER VanityURL
    Enter the vanity URL (also named custom URL) to get a SteamID for. Do not enter
    the fully qualified URL, but just the ID e.g. hjorslev instead of
    "https://steamcommunity.com/id/hjorslev/"

    .PARAMETER UrlType
    The type of vanity URL. 1 (default): Individual profile, 2: Group, 3: Official game group

    .PARAMETER OutputFormat
    Format of the output. Options are json (default), xml or vdf.

    .EXAMPLE
    Resolve-VanityURL -VanityURL hjorslev

    Returns a 64 bit Steam ID.

    .INPUTS
    String.

    .OUTPUTS
    64 bit Steam ID.

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
        [string]$VanityURL,

        [Parameter(Mandatory = $false,
            HelpMessage = 'The type of vanity URL. 1 (default): Individual profile, 2: Group, 3: Official game group.')]
        [ValidateSet(1, 2, 3)]
        [int]$UrlType = 1,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Format of the output. Options are json (default), xml or vdf.')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1/?key=$(Get-SteamAPIKey)&vanityurl=$VanityURL&url_type=$UrlType&format=$OutputFormat" -UseBasicParsing

        if (($Request.Content | ConvertFrom-Json).response.success -eq '1') {
            [PSCustomObject]@{
                'SteamID64' = ([int64]($Request.Content | ConvertFrom-Json).response.steamid)
            }
        } elseif (($Request.Content | ConvertFrom-Json).response.success -eq '42') {
            $Exception = [Exception]::new("Unable to find $VanityURL.")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                "VanityURLNotFound",
                [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                ($Request.Content | ConvertFrom-Json).response.success
            )
            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        }
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet