﻿function Get-SteamGlobalAchievementPercentagesForApp {
    <#
    .SYNOPSIS
    Returns on global achievements overview of a specific game in percentages.

    .DESCRIPTION
    Returns on global achievements overview of a specific game in percentages.

    .PARAMETER AppID
    AppID of the game you want the percentages of.

    .PARAMETER OutputFormat
    Output format. json (default), xml or vdf.

    .EXAMPLE
    Get-SteamGlobalAchievementPercentagesForApp -AppID 400

    .INPUTS
    int64

    .OUTPUTS
    Returns a string that is either formatted as json, xml or vdf.

    .NOTES
    Author: Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamGlobalAchievementPercentagesForApp.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'AppID of the game you want the percentages of.')]
        [int]$AppID,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Output format. json (default), xml or vdf.')]
        [ValidateSet('json', 'xml', 'vdf')]
        [string]$OutputFormat = 'json'
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $Request = Invoke-WebRequest -Uri "https://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/?gameid=$AppID&format=$OutputFormat"

        if ($null -eq $Request) {
            $Exception = [Exception]::new("No results were returned. Perhaps there are not data for AppID $AppID.")
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                "NoResults",
                [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                $Request # usually the object that triggered the error, if possible
            )
            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        }

        Write-Output -InputObject $Request.Content
    } # Process

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
} # Cmdlet