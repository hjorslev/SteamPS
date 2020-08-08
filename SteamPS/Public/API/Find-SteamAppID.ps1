function Find-SteamAppID {
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
    Author: Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Find-SteamAppID.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('GameName')]
        [string]$ApplicationName
    )

    begin {
        # Get most recent list with all Steam Apps ID and corresponding title and put it into a variable.
        Write-Verbose -Message "Getting all applications and the corresponding ID."
        $SteamApps = ((Invoke-WebRequest -Uri 'https://api.steampowered.com/ISteamApps/GetAppList/v2/' -UseBasicParsing).Content | ConvertFrom-Json).applist.apps
    }

    process {
        $SteamApps = $SteamApps | Where-Object -FilterScript { $PSItem.name -like "$ApplicationName*" }

        # If only one application is found when searching by application name.
        if (($SteamApps | Measure-Object).Count -eq 1) {
            Write-Verbose -Message "Only one application found: $($SteamApps.name) - $($SteamApps.appid)."
            Write-Output -InputObject $SteamApps
        }
        # If more than one application is found the user is prompted to select the exact application.
        elseif (($SteamApps | Measure-Object).Count -ge 1) {
            # An OutGridView is presented to the user where the exact AppID can be located. This variable contains the AppID selected in the Out-GridView.
            $SteamApp = $SteamApps | Out-GridView -Title 'Select application' -PassThru
            Write-Verbose -Message "$(($SteamApp).name) - $(($SteamApp).appid) selected from Out-GridView."
            Write-Output -InputObject $SteamApp
        }
    } # Process
}# Cmdlet