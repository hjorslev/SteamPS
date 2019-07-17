function Install-SteamCMD {
    <#
    .SYNOPSIS
    Install SteamCMD.

    .DESCRIPTION
    This cmdlet downloads SteamCMD and configures it in a custom or
    predefined location (C:\Program Files\SteamCMD).

    .PARAMETER InstallPath
    Specifiy the install location of SteamCMD.

    .EXAMPLE
    Install-SteamCMD

    Installs SteamCMD in C:\Program Files\SteamCMD.

    .EXAMPLE
    Install-SteamCMD -InstallPath 'C:\SteamCMD'

    Installs SteamCMD in C:\SteamCMD.

    .NOTES
    Author: Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Install-SteamCMD.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$InstallPath
    )

    begin {
        $RegistryPath = 'HKLM:\SOFTWARE\SteamPS'
        if (-not (Get-Item -Path $RegistryPath -ErrorAction SilentlyContinue)) {
            Write-Verbose -Message "Creating registry path $($RegistryPath)."
            New-Item -Path $RegistryPath | Out-Null
        }

        # Set path if $InstallPath is populated.
        if ($InstallPath) {
            Write-Verbose -Message "Setting custom InstallPath to: $($InstallPath)."
            New-ItemProperty -Path $RegistryPath -Name 'InstallPath' -PropertyType String -Value $InstallPath | Write-Verbose
            $InstallPath = (Get-ItemProperty -Path $RegistryPath -Name InstallPath).InstallPath
        } else {
            Write-Verbose -Message "Setting predefined InstallPath to: $($InstallPath)."
            $InstallPath = "$($env:ProgramFiles)\SteamCMD"
            New-ItemProperty -Path $RegistryPath -Name 'InstallPath' -PropertyType String -Value $InstallPath | Write-Verbose
        }

        $TempDirectory = 'C:\Temp'
        if (-not (Test-Path -Path $TempDirectory)) {
            Write-Verbose -Message 'Creating Temp directory.'
            New-Item -Path 'C:\' -Name 'Temp' -ItemType Directory | Write-Verbose
        }
    }

    process {
        # Download SteamCMD.
        Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile "$($TempDirectory)\steamcmd.zip" -UseBasicParsing

        # Create SteamCMD directory if necessary.
        if (-not (Test-Path -Path $InstallPath)) {
            Write-Verbose -Message "Creating SteamCMD directory: $($InstallPath)"
            New-Item -Path $InstallPath -ItemType Directory | Write-Verbose
            Expand-Archive -Path "$($TempDirectory)\steamcmd.zip" -DestinationPath $InstallPath
        }

        # Doing some initial configuration of SteamCMD. The first time SteamCMD is launched it will need to do some updates.
        Write-Host -Object 'Configuring SteamCMD for the first time. This might take a little while.'
        Write-Host -Object 'Please wait' -NoNewline
        Start-Process -FilePath $InstallPath\steamcmd.exe -ArgumentList 'validate +quit' -WindowStyle Hidden
        do {
            Write-Host -Object "." -NoNewline
            Start-Sleep -Seconds 3
        }
        until (-not (Get-Process -Name "*steamcmd*"))
    }

    end {
        Remove-Item -Path "$($TempDirectory)\steamcmd.zip" -Force
    }
}