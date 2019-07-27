function Update-SteamServer {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER AppID
    Parameter description

    .PARAMETER ApplicationName
    Parameter description

    .PARAMETER ServiceName
    Parameter description

    .PARAMETER ApplicationPath
    Parameter description

    .PARAMETER RsiServerID
    Parameter description

    .PARAMETER LogLocation
    Parameter description

    .PARAMETER DiscordWebhookUri
    Parameter description

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    [CmdletBinding(DefaultParameterSetName = 'AppID',
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'AppID')]
        [int]$AppID,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'ApplicationName')]
        [string]$ApplicationName,

        [Parameter(Mandatory = $true)]
        [string]$ServiceName,

        [Parameter(Mandatory = $true)]
        [int]$RsiServerID,

        [Parameter(Mandatory = $false)]
        [string]$ApplicationPath = "C:\DedicatedServers\$($ServiceName)",

        [Parameter(Mandatory = $false)]
        [string]$LogLocation = "C:\DedicatedServers\Logs\$($ServiceName)\$($ServiceName)_%{+%Y%m%d}.log",

        [Parameter(Mandatory = $false)]
        [string]$DiscordWebhookUri
    )

    begin {
        # Create a log file with information about the operation.
        Set-LoggingDefaultLevel -Level 'INFO'
        Add-LoggingTarget -Name Console
        Add-LoggingTarget -Name File -Configuration @{ Path = $LogLocation }
    }

    process {
        # Get server status and output it.
        $ServerStatus = Get-SteamServerInfo -ServerID $RsiServerID
        Write-Log -Message $ServerStatus

        # Waiting to server is empty. Checking every 60 seconds.
        while ($ServerStatus.players_cur -ne "0") {
            Write-Log -Message "Awaiting that the server is empty."
            $ServerStatus = Get-SteamServerInfo -ServerID $RsiServerID
            Write-Log -Message $ServerStatus | Select-Object -Property hostname, ip, port, online_state, players_cur, checked
            Start-Sleep -Seconds 60
        }
        # Server is now empty and we stop, update and start the server.
        Write-Log -Message "Stopping $($ServiceName)"
        Stop-Service -Name $ServiceName
        Write-Log -Message "$(Get-Service -Name $ServiceName | Out-String)"

        Write-Log -Message "Updating $($ServiceName)..."
        Update-SteamApp -AppID $AppID -Path $ApplicationPath -Force -Verbose

        Write-Log -Message "Starting $($ServiceName)."
        Start-Service -Name $ServiceName
        Write-Log -Message $(Get-Service -Name $ServiceName | Out-String)

        $TimeOutCounter = 0
        do {
            $TimeOutCounter++ # Add +1 for every loop.
            Write-Log -Message 'Waiting for server to come online again.'
            Start-Sleep -Seconds 1
            # Getting new server information.
            $ServerStatus = Get-SteamServerInfo -ServerID $RsiServerID | Select-Object -Property hostname, ip, port, online_state, players_cur, checked
            Write-Log -Message $ServerStatus
            Write-Log -Message "TimeOutCounter: $($TimeOutCounter)/10"
            if ($TimeOutCounter -ge 10) {
                break
            }
        } until ($ServerStatus.online_state -eq '1')

        if ($ServerStatus.online_state -eq '1') {
            Write-Log -Message "$($ServerStatus.hostname) is now ONLINE."
            $ServerState = 'ONLINE'
            $Color = 'Green'
        } else {
            Write-Log -Level ERROR -Message  "Server seems to be OFFLINE after the update..."
            $ServerState = 'OFFLINE'
            $Color = 'Red'
        }
    } # Process

    end {
        if ($null -ne $DiscordWebhookUri) {
            # Send Message to Discord about the update.
            $ServerFact = New-DiscordFact -Name 'Game Server Info' -Value $(Get-SteamServerInfo -ServerID $RsiServerID | Select-Object -Property hostname, ip, port, online_state, players_cur, checked | Out-String)
            $ServerStateFact = New-DiscordFact -Name 'Server State' -Value $(Write-Output -InputObject "Server is $($ServerState)!")
            $LogFact = New-DiscordFact -Name 'Log Location' -Value $LogLocation
            $Section = New-DiscordSection -Title "$($ServiceName) - Update Script Executed" -Facts $ServerStateFact, $ServerFact, $LogFact -Color $Color
            Send-DiscordMessage -WebHookUrl $DiscordWebhookUri -Sections $Section -Verbose
        }
    } # End
} # Cmdlet