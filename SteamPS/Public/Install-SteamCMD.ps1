function Install-SteamCMD {
    <#
    .SYNOPSIS
    Install SteamCMD.

    .DESCRIPTION
    This cmdlet downloads SteamCMD and configures it in any desired folders.

    .PARAMETER InstallPath
    Specifiy the location of SteamCMD. Default is C:\SteamCMD.

    .EXAMPLE
    An example

    .NOTES
    General notes
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $false)]
        [string]$InstallPath = 'C:\SteamCMD'
    )

    begin {
        $TempDirectory = 'C:\Temp'
        if (-not (Test-Path -Path $TempDirectory)) {
            Write-Verbose -Message 'Creating Temp directory.'
            New-Item -Path 'C:\' -Name 'Temp' -ItemType Directory | Write-Verbose
        }
    }

    process {
        # Download SteamCMD.
        Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile "$($TempDirectory)\steamcmd.zip" -UseBasicParsing

        # Create SteamCMD directory in C:\ if necessary.
        if (-not (Test-Path -Path $InstallPath)) {
            Write-Verbose -Message "Creating SteamCMD directory: $($InstallPath)"
            New-Item -Path $InstallPath -ItemType Directory | Write-Verbose
            Expand-Archive -Path "$($TempDirectory)\steamcmd.zip" -DestinationPath $InstallPath
        }

        # Doing some initial configuration of SteamCMD. The first time SteamCMD is launched it will need to do some updates.
        Write-Host -Object 'Setting up SteamCMD for the first time. Please wait.' -NoNewline
        Start-Process -FilePath $InstallPath\steamcmd.exe -ArgumentList 'validate +quit' -WindowStyle Hidden
        do {
            Write-Host -Object "." -NoNewline
            Start-Sleep -Seconds 3
        }
        until (-not (Get-Process -Name "*steamcmd*"))
    }

    end {
        Remove-Item -Path "$($TempDirectory)\steamcmd.zip"
    }
}
