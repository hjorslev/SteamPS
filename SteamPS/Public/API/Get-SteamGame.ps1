function Get-SteamGame {
    <#
    .SYNOPSIS
    Retrieves a Steam AppID by searching the name or ID of the application.

    .DESCRIPTION
    This function searches for a Steam application by name or ID and returns the corresponding AppID. If multiple applications are found, the user can select the correct one from a list.

    .PARAMETER ApplicationName
    The name of the application to search for. If multiple applications are found, the user will be presented with a list from which they can select the correct application.

    .PARAMETER ApplicationID
    The unique identifier for a Steam application. Use this parameter to search for an application by its ID.

    .INPUTS
    System.String or System.Int32. Get-SteamGame accepts either a string value for the application name or an integer value for the application ID.

    .OUTPUTS
    PSCustomObject. This function returns a custom object with the application name and application ID.

    .EXAMPLE
    Get-SteamGame -ApplicationName 'Ground Branch'

    Searches for applications with names that start with 'Ground Branch'. If multiple applications are found, the user can choose between them, such as the game 'Ground Branch' or 'Ground Branch Dedicated Server'.

    .EXAMPLE
    Get-SteamGame -ApplicationID 440

    Searches for the application with the AppID 440 and returns its name and ID.

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
        # ParameterSet ApplicationName
        if ($PSCmdlet.ParameterSetName -eq 'ApplicationName') {
            Write-Verbose -Message 'ParameterSetName is ApplicationName'
            # Filter on ApplicationName. Might result in multiple hits.
            # The user can then later choose their preference.
            $FilteredApps = $SteamApps.Where({ $_.name -match "^$ApplicationName" })
            # If only one application is found when searching by application name.
            if (($FilteredApps | Measure-Object).Count -eq 1 -and $null -ne $FilteredApps) {
                Write-Verbose -Message "Only one application found: $($FilteredApps.name) - $($FilteredApps.appid)."
                [PSCustomObject]@{
                    ApplicationID   = $FilteredApps.appid
                    ApplicationName = $FilteredApps.name
                }
            }
            # If more than one application is found, the user is prompted to select the exact application.
            elseif (($FilteredApps | Measure-Object).Count -ge 1) {
                # An Out-GridView is presented to the user where the exact AppID can be located. This variable contains the AppID selected in the Out-GridView.
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
        # ParameterSet ApplicationID
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
