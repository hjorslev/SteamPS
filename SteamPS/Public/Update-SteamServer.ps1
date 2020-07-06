function Update-SteamServer {
    <#
    .SYNOPSIS
    Update a Steam based game server.

    .DESCRIPTION
    This cmdlet presents a workflow to keep a steam based game server up to date.
    The server is expecting the game server to be running as a Windows Service.

    .PARAMETER AppID
    Enter the application ID you wish to install.

    .PARAMETER ServiceName
    Specify the Windows Service Name. You can get a list of services with Get-Service.

    .PARAMETER Path
    Install location of the game server.

    .PARAMETER Arguments
    Enter any additional arguments here.

    .PARAMETER IPAddress
    Enter the IP address of the Steam based server.

    .PARAMETER Port
    Enter the port number of the Steam based server.

    .PARAMETER LogPath
    Specify the location of the log files.

    .PARAMETER DiscordWebhookUri
    Enter a Discord Webhook Uri if you wish to get notifications about the server
    update.

    .PARAMETER AlwaysNotify
    Always receive a notification when a server has been updated. Default is
    only to send on errors.

    .PARAMETER TimeoutLimit
    Number of times the cmdlet checks if the server is online or offline. When
    the limit is reached an error is thrown.

    .EXAMPLE
    Update-SteamServer -AppID 476400 -ServiceName GB-PG10 -IPAddress '185.15.73.207' -Port 27015

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

        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [System.Net.IPAddress]$IPAddress,

        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [int]$Port,

        [Parameter(Mandatory = $false)]
        [Alias('ApplicationPath')]
        [string]$Path = "C:\DedicatedServers\$ServiceName",

        [Parameter(Mandatory = $false)]
        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory = $false)]
        [string]$Arguments,

        [Parameter(Mandatory = $false)]
        [Alias('LogLocation')]
        [string]$LogPath = "C:\DedicatedServers\Logs\$ServiceName\$($ServiceName)_$((Get-Date).ToShortDateString()).log",

        [Parameter(Mandatory = $false)]
        [string]$DiscordWebhookUri,

        [Parameter(Mandatory = $false)]
        [string]$AlwaysNotify,

        [Parameter(Mandatory = $false)]
        [int]$TimeoutLimit = 10
    )

    begin {
        if ($null -eq (Get-SteamPath)) {
            throw 'SteamCMD could not be found in the env:Path. Have you executed Install-SteamCMD?'
        }

        # Create a log file with information about the operation.
        Set-LoggingDefaultLevel -Level 'INFO'
        Add-LoggingTarget -Name Console
        Add-LoggingTarget -Name File -Configuration @{ Path = $LogPath }

        # Variable that stores how many times the cmdlet has checked whether the
        # server is offline or online.
        $TimeoutCounter = 0
    }

    process {
        # Get server status and output it.
        $ServerStatus = Get-SteamServerInfo -IPAddress $IPAddress -Port $Port
        Write-Log -Message $ServerStatus

        # Waiting to server is empty. Checking every 60 seconds.
        while ($ServerStatus.Players -ne 0) {
            Write-Log -Message "Awaiting that the server is empty before updating."
            $ServerStatus = Get-SteamServerInfo -IPAddress $IPAddress -Port $Port
            Write-Log -Message $ServerStatus | Select-Object -Property ServerName, Port, Players
            Start-Sleep -Seconds 60
        }
        # Server is now empty and we stop, update and start the server.
        Write-Log -Message "Stopping $ServiceName"
        Stop-Service -Name $ServiceName
        Write-Log -Message "$($ServiceName): $((Get-Service -Name $ServiceName).Status)."

        Write-Log -Message "Updating $ServiceName..."
        if ($null -ne $Credential) {
            Update-SteamApp -AppID $AppID -Path $Path -Credential $Credential -Arguments "$Arguments" -Force
        } else {
            Update-SteamApp -AppID $AppID -Path $Path -Arguments "$Arguments" -Force
        }

        Write-Log -Message "Starting $ServiceName"
        Start-Service -Name $ServiceName
        Write-Log -Message "$($ServiceName): $((Get-Service -Name $ServiceName).Status)."

        do {
            $TimeoutCounter++ # Add +1 for every loop.
            Write-Log -Message 'Waiting for server to come online again.'
            Start-Sleep -Seconds 60
            # Getting new server information.
            $ServerStatus = Get-SteamServerInfo -IPAddress $IPAddress -Port $Port | Select-Object -Property ServerName, Port, Players
            Write-Log -Message $ServerStatus
            Write-Log -Message "TimeoutCounter: $TimeoutCounter/$TimeoutLimit"
            if ($TimeoutCounter -ge $TimeoutLimit) {
                break
            }
        } until ($null -ne $ServerStatus.ServerName)

        if ($null -ne $ServerStatus.ServerName) {
            Write-Log -Message "$($ServerStatus.ServerName) is now ONLINE."
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
            $ServerFact = New-DiscordFact -Name 'Game Server Info' -Value $(Get-SteamServerInfo -IPAddress $IPAddress -Port $Port | Select-Object -Property ServerName, IP, Port, Players | Out-String)
            $ServerStateFact = New-DiscordFact -Name 'Server State' -Value $(Write-Output -InputObject "Server is $ServerState!")
            $LogFact = New-DiscordFact -Name 'Log Location' -Value $LogPath
            $Section = New-DiscordSection -Title "$ServiceName - Update Script Executed" -Facts $ServerStateFact, $ServerFact, $LogFact -Color $Color
            Send-DiscordMessage -WebHookUrl $DiscordWebhookUri -Sections $Section
        }
    } # End
} # Cmdlet