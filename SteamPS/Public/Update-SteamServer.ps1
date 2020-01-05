function Update-SteamServer {
    <#
    .SYNOPSIS
    Update a Steam based game server.

    .DESCRIPTION
    This cmdlet presents a workflow to keep a steam based game server up to date.
    The server is expecting the game server to be running as a Windows Service.

    .PARAMETER AppID
    Enter the application ID you wish to install..

    .PARAMETER ServiceName
    Specify the Windows Service Name. You can get a list of services with Get-Service.

    .PARAMETER ApplicationPath
    Install location of the game server.

    .PARAMETER Arguments
    Enter any additional arguments here.

    .PARAMETER RsiServerID
    Enter the Rust Server ID. More information about adding and obtaining an ID:
    https://rust-servers.info/add.html

    .PARAMETER LogLocation
    Specify the location of the log files.

    .PARAMETER DiscordWebhookUri
    Enter a Discord Webhook Uri if you wish to get notifications about the server
    update.,

    .PARAMETER AlwaysNotify
    Use this if you allways want to receive a notification when a server has been
    updated. Default is only to send on errors.,

    .PARAMETER TimeoutLimit
    Number of times the cmdlet checks if the server is online or offline. When
    the limit is reached an error is thrown.

    .EXAMPLE
    Update-SteamServer -AppID 476400 -ServiceName GB-PG10 -RsiServerID 2743

    .NOTES
    Author: Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Update-SteamServer.html
    #>

    [CmdletBinding(SupportsShouldProcess = $true,
        ConfirmImpact = 'High')]

    param (
        [Parameter(Mandatory = $true)]
        [int]$AppID,

        [Parameter(Mandatory = $true)]
        [ValidateScript( { Get-Service -Name $_ })]
        [string]$ServiceName,

        [Parameter(Mandatory = $true)]
        [int]$RsiServerID,

        [Parameter(Mandatory = $false)]
        [string]$ApplicationPath = "C:\DedicatedServers\$($ServiceName)",

        [Parameter(Mandatory = $false)]
        [string]$Arguments,

        [Parameter(Mandatory = $false)]
        [string]$LogLocation = "C:\DedicatedServers\Logs\$($ServiceName)\$($ServiceName)_$((Get-Date).ToShortDateString()).log",

        [Parameter(Mandatory = $false)]
        [string]$DiscordWebhookUri,

        [Parameter(Mandatory = $false)]
        [string]$AlwaysNotify,

        [Parameter(Mandatory = $false)]
        [string]$TimeoutLimit = 10
    )

    begin {
        # Create a log file with information about the operation.
        Set-LoggingDefaultLevel -Level 'INFO'
        Add-LoggingTarget -Name Console
        Add-LoggingTarget -Name File -Configuration @{ Path = $LogLocation }

        # Variable that stores how many times the cmdlet has checked whether the
        # server is offline or online.
        $TimeoutCounter = 0
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
        Write-Log -Message "$($ServiceName): $((Get-Service -Name $ServiceName).Status)."

        Write-Log -Message "Updating $($ServiceName)..."
        Update-SteamApp -AppID $AppID -Path $ApplicationPath -Arguments "$($Arguments)" -Force -Verbose

        Write-Log -Message "Starting $($ServiceName)"
        Start-Service -Name $ServiceName
        Write-Log -Message "$($ServiceName): $((Get-Service -Name $ServiceName).Status)."

        do {
            $TimeoutCounter++ # Add +1 for every loop.
            Write-Log -Message 'Waiting for server to come online again.'
            Start-Sleep -Seconds 60
            # Getting new server information.
            $ServerStatus = Get-SteamServerInfo -ServerID $RsiServerID | Select-Object -Property hostname, ip, port, online_state, players_cur, checked
            Write-Log -Message $ServerStatus
            Write-Log -Message "TimeoutCounter: $($TimeoutCounter)/10"
            if ($TimeoutCounter -ge $TimeoutLimit) {
                break
            }
        } until ($ServerStatus.online_state -eq '1')

        if ($ServerStatus.online_state -eq '1') {
            Write-Log -Message "$($ServerStatus.hostname) is now ONLINE."
            $ServerState = 'ONLINE'
            $Color = 'Green'
        } else {
            Write-Log -Level ERROR -Message "Server seems to be OFFLINE after the update..."
            $ServerState = 'OFFLINE'
            $Color = 'Red'
        }
    } # Process

    end {
        if ($null -ne $DiscordWebhookUri -and ($ServerState -eq 'OFFLINE' -or $AlwaysNotify -eq $true)) {
            # Send Message to Discord about the update.
            $ServerFact = New-DiscordFact -Name 'Game Server Info' -Value $(Get-SteamServerInfo -ServerID $RsiServerID | Select-Object -Property hostname, ip, port, online_state, players_cur, checked | Out-String)
            $ServerStateFact = New-DiscordFact -Name 'Server State' -Value $(Write-Output -InputObject "Server is $($ServerState)!")
            $LogFact = New-DiscordFact -Name 'Log Location' -Value $LogLocation
            $Section = New-DiscordSection -Title "$($ServiceName) - Update Script Executed" -Facts $ServerStateFact, $ServerFact, $LogFact -Color $Color
            Send-DiscordMessage -WebHookUrl $DiscordWebhookUri -Sections $Section -Verbose
        }
    } # End
} # Cmdlet