function Get-SteamGame {
    <#
    .SYNOPSIS
    Find a Steam AppID by searching the name of the application.

    .DESCRIPTION
    Find a Steam AppID by searching the name of the application.

    .PARAMETER ApplicationName
    Enter the name of the application. If multiple hits the user will be presented
    with an Out-GridView where he/she can choose the correct application.

    .INPUTS
    System.String. Find-SteamAppID accepts a string value.

    .OUTPUTS
    System.String and Int. It returns the application name and application ID.

    .EXAMPLE
    Find-SteamAppID -ApplicationName 'Ground Branch'

    Will results in multiple hits and let the user choose between the application
    'Ground Branch' which is the game or 'Ground Branch Dedicated Server' which
    is the dedicated server to 'Ground Branch'.

    .EXAMPLE
    Find-SteamAppID -ApplicationName 'Ground Branch D'

    This Will only yield one result which is 'Ground Branch Dedicated Server'.
    Output is the AppID and name of the application.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamGame.html
    #>

    [CmdletBinding(DefaultParameterSetName = 'ApplicationName')]
    [Alias('Find-SteamAppID')]
    param (
        [Parameter(ParameterSetName = 'ApplicationName',
            Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('GameName')]
        [string]$ApplicationName,

        [Parameter(ParameterSetName = 'ApplicationID',
            Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('GameID')]
        [int]$ApplicationID
    )

    begin {
        if ($null -eq $SteamApps) {
            Write-Verbose -Message 'Fetching app list from Steam Web API.'
            $SteamApps = (Invoke-RestMethod -Uri 'https://api.steampowered.com/ISteamApps/GetAppList/v2/' -UseBasicParsing).applist.apps
        }
    }

    process {
        # ParemeterSet ApplicationName
        if ($PSCmdlet.ParameterSetName -eq 'ApplicationName') {
            Write-Verbose -Message 'ParameterSetName is ApplicationName'
            # Filter on ApplicationName. Might results in multiple hits.
            # The user can then later can choose her preference.
            $FilteredApps = $SteamApps.Where({ $_.name -match "^$ApplicationName" })
            # If only one application is found when searching by application name.
            if (($FilteredApps | Measure-Object).Count -eq 1 -and $null -ne $FilteredApps) {
                Write-Verbose -Message "Only one application found: $($FilteredApps.name) - $($FilteredApps.appid)."
                [PSCustomObject]@{
                    ApplicationID   = $FilteredApps.appid
                    ApplicationName = $FilteredApps.name
                }
            }
            # If more than one application is found the user is prompted to select the exact application.
            elseif (($FilteredApps | Measure-Object).Count -ge 1) {
                # An OutGridView is presented to the user where the exact AppID can be located. This variable contains the AppID selected in the Out-GridView.
                $SteamApp = $FilteredApps | Select-Object @{Name = 'appid'; Expression = { $_.appid.toString() } }, name | Out-GridView -Title 'Select application' -PassThru
                if ($SteamApp) {
                    Write-Verbose -Message "$(($SteamApp).name) - $(($SteamApp).appid) selected from Out-GridView."
                    [PSCustomObject]@{
                        ApplicationID   = $SteamApp.appid
                        ApplicationName = $SteamApp.name
                    }
                }
            }
        }
        # ParemeterSet ApplicationID
        elseif ($PSCmdlet.ParameterSetName -eq 'ApplicationID') {
            Write-Verbose -Message 'ParameterSetName is ApplicationID.'
            $SteamApp = $SteamApps.Where({ $_.appid -eq $ApplicationID })
            if ($SteamApp) {
                [PSCustomObject]@{
                    ApplicationID   = $SteamApp.appid
                    ApplicationName = $SteamApp.name
                }
            }
        }
    } # Process
} # Cmdlet