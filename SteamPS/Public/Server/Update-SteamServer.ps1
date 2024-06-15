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

    .PARAMETER IPAddress
    Enter the IP address of the Steam based server.

    .PARAMETER Port
    Enter the port number of the Steam based server.

    .PARAMETER Path
    Install location of the game server.

    .PARAMETER Credential
    If the app requires login to install or update, enter your Steam username and password.

    .PARAMETER Arguments
    Enter any additional arguments here.

    .PARAMETER LogPath
    Specify the directory of the log files.

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
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Update-SteamServer.html
    #>

    # TODO: Implement support for ShouldContinue. Due to compatibility we wait with this.
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '')]
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
        [string]$LogPath = 'C:\DedicatedServers\Logs',

        [Parameter(Mandatory = $false)]
        [string]$DiscordWebhookUri,

        [Parameter(Mandatory = $false)]
        [string]$AlwaysNotify,

        [Parameter(Mandatory = $false)]
        [int]$TimeoutLimit = 10
    )

    begin {
        if ($null -eq (Get-SteamPath)) {
            $Exception = [Exception]::new('SteamCMD could not be found in the env:Path. Have you executed Install-SteamCMD?')
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                'SteamCMDNotInstalled',
                [System.Management.Automation.ErrorCategory]::NotInstalled,
                (Test-Admin)
            )
            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        }

        if ((Test-Admin) -eq $false) {
            $Exception = [Exception]::new('The current PowerShell session is not running as Administrator. Start PowerShell by using the Run as Administrator option, and then try running the script again.')
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                'MissingUserPermissions',
                [System.Management.Automation.ErrorCategory]::PermissionDenied,
                (Test-Admin)
            )
            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        }

        # Log settings
        $PSFLoggingProvider = @{
            Name          = 'logfile'
            InstanceName  = "Update game server $ServiceName"
            FilePath      = "$LogPath\$ServiceName\$ServiceName-%Date%.csv"
            Enabled       = $true
            LogRotatePath = "$LogPath\$ServiceName\$ServiceName-*.csv"
        }
        Set-PSFLoggingProvider @PSFLoggingProvider

        # Variable that stores how many times the cmdlet has checked whether the
        # server is offline or online.
        $TimeoutCounter = 0
    }

    process {
        # Get server status and output it.
        $ServerStatus = Get-SteamServerInfo -IPAddress $IPAddress -Port $Port -ErrorAction SilentlyContinue

        # If server is alive we check it is empty before updating it.
        if ($ServerStatus) {
            Write-PSFMessage -Level Host -Message $ServerStatus -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"

            # Waiting to server is empty. Checking every 60 seconds.
            while ($ServerStatus.Players -ne 0) {
                Write-PSFMessage -Level Host -Message 'Awaiting that the server is empty before updating.' -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
                $ServerStatus = Get-SteamServerInfo -IPAddress $IPAddress -Port $Port -ErrorAction SilentlyContinue
                Write-PSFMessage -Level Host -Message $($ServerStatus | Select-Object -Property ServerName, Port, Players) -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
                Start-Sleep -Seconds 60
            }
            # Server is now empty and we stop, update and start the server.
            Write-PSFMessage -Level Host -Message "Stopping $ServiceName..." -Tag 'ServerUpdate' -ModuleName 'SteamPS' -Target $ServiceName
            Stop-Service -Name $ServiceName
            Write-PSFMessage -Level Host -Message "$($ServiceName): $((Get-Service -Name $ServiceName).Status)." -Tag 'ServerUpdate' -ModuleName 'SteamPS' -Target $ServiceName
        } else {
            Write-PSFMessage -Level Host -Message 'Server could not be reached.' -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
            Write-PSFMessage -Level Host -Message 'Continuing with updating server.' -Tag 'ServerUpdate' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
        }

        Write-PSFMessage -Level Host -Message "Updating $ServiceName..." -Tag 'ServerUpdate' -ModuleName 'SteamPS' -Target $ServiceName
        if ($null -ne $Credential) {
            Update-SteamApp -AppID $AppID -Path $Path -Credential $Credential -Arguments "$Arguments" -Force
        } else {
            Update-SteamApp -AppID $AppID -Path $Path -Arguments "$Arguments" -Force
        }

        Write-PSFMessage -Level Host -Message "Starting $ServiceName" -Tag 'ServerUpdate' -ModuleName 'SteamPS' -Target $ServiceName
        Start-Service -Name $ServiceName
        Write-PSFMessage -Level Host -Message "$($ServiceName): $((Get-Service -Name $ServiceName).Status)." -Tag 'ServerUpdate' -ModuleName 'SteamPS' -Target $ServiceName

        do {
            $TimeoutCounter++ # Add +1 for every loop.
            Write-PSFMessage -Level Host -Message 'Waiting for server to come online again.' -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
            Start-Sleep -Seconds 60
            # Getting new server information.
            $ServerStatus = Get-SteamServerInfo -IPAddress $IPAddress -Port $Port -ErrorAction SilentlyContinue | Select-Object -Property ServerName, Port, Players
            Write-PSFMessage -Level Host -Message $ServerStatus -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
            Write-PSFMessage -Level Host -Message "No response from $($IPAddress):$($Port)." -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
            Write-PSFMessage -Level Host -Message "TimeoutCounter: $TimeoutCounter/$TimeoutLimit" -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
            if ($TimeoutCounter -ge $TimeoutLimit) {
                break
            }
        } until ($null -ne $ServerStatus.ServerName)

        if ($null -ne $ServerStatus.ServerName) {
            Write-PSFMessage -Level Host -Message "$($ServerStatus.ServerName) is now ONLINE." -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
            $ServerState = 'ONLINE'
            $Color = 'Green'
        } else {
            Write-PSFMessage -Level Critical -Message "Server seems to be OFFLINE after the update..." -Tag 'ServerStatus' -ModuleName 'SteamPS' -Target "$($IPAddress):$($Port)"
            $ServerState = 'OFFLINE'
            $Color = 'Red'
        }
    } # Process

    end {
        if ($null -ne $DiscordWebhookUri -and ($ServerState -eq 'OFFLINE' -or $AlwaysNotify -eq $true)) {
            # Send Message to Discord about the update.
            $ServerFact = New-DiscordFact -Name 'Game Server Info' -Value $(Get-SteamServerInfo -IPAddress $IPAddress -Port $Port -ErrorAction SilentlyContinue | Select-Object -Property ServerName, IP, Port, Players | Out-String)
            $ServerStateFact = New-DiscordFact -Name 'Server State' -Value $(Write-Output -InputObject "Server is $ServerState!")
            $LogFact = New-DiscordFact -Name 'Log Location' -Value "$LogPath\$ServiceName\$ServiceName-%Date%.csv"
            $Section = New-DiscordSection -Title "$ServiceName - Update Script Executed" -Facts $ServerStateFact, $ServerFact, $LogFact -Color $Color
            Send-DiscordMessage -WebHookUrl $DiscordWebhookUri -Sections $Section
        }
    } # End
} # Cmdlet