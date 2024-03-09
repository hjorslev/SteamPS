function Install-SteamCMD {
    <#
    .SYNOPSIS
    Install SteamCMD.

    .DESCRIPTION
    This cmdlet downloads SteamCMD and configures it in a custom or
    predefined location (C:\Program Files\SteamCMD).

    .PARAMETER InstallPath
    Specifiy the install location of SteamCMD.

    .PARAMETER Force
    The Force parameter allows the user to skip the "Should Continue" box.

    .EXAMPLE
    Install-SteamCMD

    Installs SteamCMD in C:\Program Files\SteamCMD.

    .EXAMPLE
    Install-SteamCMD -InstallPath 'C:'

    Installs SteamCMD in C:\SteamCMD.

    .NOTES
    Author: Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Install-SteamCMD.html
    #>

    [CmdletBinding(SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateScript( {
                if ($_.Substring(($_.Length -1)) -eq '\') {
                    throw "InstallPath may not end with a trailing slash."
                }
                $true
            })]
        [string]$InstallPath = "$env:ProgramFiles",

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    begin {
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
        if ($isAdmin -eq $false) {
            $Exception = [Exception]::new('The current PowerShell session is not running as Administrator. Start PowerShell by using the Run as Administrator option, and then try running the script again.')
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                'MissingUserPermissions',
                [System.Management.Automation.ErrorCategory]::PermissionDenied,
                $isAdmin
            )
            $PSCmdlet.ThrowTerminatingError($ErrorRecord)
        }
    }

    process {
        if ($Force -or $PSCmdlet.ShouldContinue('Would you like to continue?', 'Install SteamCMD')) {
            # Ensures that SteamCMD is installed in a folder named SteamCMD.
            $InstallPath = $InstallPath + '\SteamCMD'

            if (-not ((Get-SteamPath).Path -eq $InstallPath)) {
                Write-Verbose -Message "Adding $InstallPath to Environment Variable PATH."
                Add-EnvPath -Path $InstallPath -Container Machine
            } else {
                Write-Verbose -Message "Path $((Get-SteamPath).Path) already exists."
            }

            $TempDirectory = 'C:\Temp'
            if (-not (Test-Path -Path $TempDirectory)) {
                Write-Verbose -Message 'Creating Temp directory.'
                New-Item -Path 'C:\' -Name 'Temp' -ItemType Directory | Write-Verbose
            }

            # Download SteamCMD.
            Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile "$TempDirectory\steamcmd.zip" -UseBasicParsing

            # Create SteamCMD directory if necessary.
            if (-not (Test-Path -Path $InstallPath)) {
                Write-Verbose -Message "Creating SteamCMD directory: $InstallPath"
                New-Item -Path $InstallPath -ItemType Directory | Write-Verbose
                Expand-Archive -Path "$TempDirectory\steamcmd.zip" -DestinationPath $InstallPath
            }

            # Doing some initial configuration of SteamCMD. The first time SteamCMD is launched it will need to do some updates.
            Write-Host -Object 'Configuring SteamCMD for the first time. This might take a little while.'
            Write-Host -Object 'Please wait' -NoNewline
            Start-Process -FilePath "$InstallPath\steamcmd.exe" -ArgumentList 'validate +quit' -WindowStyle Hidden
            do {
                Write-Host -Object "." -NoNewline
                Start-Sleep -Seconds 3
            }
            until (-not (Get-Process -Name "*steamcmd*"))
        }
    } # Process

    end {
        if (Test-Path -Path "$TempDirectory\steamcmd.zip") {
            Remove-Item -Path "$TempDirectory\steamcmd.zip" -Force
        }

        if (Test-Path -Path (Get-SteamPath).Executable) {
            Write-Output -InputObject "SteamCMD is now installed. Please close/open your PowerShell host."
        }
    } # End
} # Cmdlet