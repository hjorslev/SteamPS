<#
.SYNOPSIS
Install or update a Steam application using SteamCMD.

.DESCRIPTION
Install or update a Steam application using SteamCMD. If SteamCMD is missing, it will be installed first. You can either search for the application by name or enter the specific Application ID.

.PARAMETER GameName
Enter the name of the app to make a wildcard search for the game.

.PARAMETER AppID
Enter the application ID you wish to install.

.PARAMETER Credential
If the app requires login to install or update, enter your Steam username and password.

.PARAMETER Path
Path to installation folder.

.PARAMETER Arguments
Enter any additional arguments here.

Beware, the following arguments are already used:

    If you use Steam login to install/upload the app the following arguments are already used: "+login $($SteamUserName) $($SteamPassword) +force_install_dir $($Path) +app_update $($SteamAppID) $($Arguments) validate +quit"

    If you use anonymous login to install/upload the app the following arguments are already used: "+login anonymous +force_install_dir $($Path) +app_update $($SteamAppID) $($Arguments) validate +quit"

.EXAMPLE
Update-SteamApp -GameName 'Arma 3' -Credential 'steam_user' -Path 'C:\Servers'
    Because there are multiple hits when searching for Arma 3, the user will be promoted to select the right application.

Update-SteamApp -AppID 376030 -Path 'C:\Servers'
    Here we use anonymous login because the particular application (ARK: Survival Evolved Dedicated Server) doesn't require login.

.NOTES
Author: Frederik Hjorslev Poulsen

SteamCMD CLI parameters: https://developer.valvesoftware.com/wiki/Command_Line_Options#Command-line_parameters_4

#>
function Update-SteamApp
{
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param
    (
                
        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'GameName'
        )]
        [string[]]$GameName,

        [Parameter(
            Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'AppID'
        )]
        [int]$AppID,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,

        [System.IO.FileInfo]$Path,

        [string]$Arguments
    )
    
    begin
    {
        # PowerShell version 5 is required. We stop here if it isn't installed.
        if (-not ($PSVersionTable.PSVersion.Major -ge 5))
        {
            Throw "PowerShell must be version 5 or higher. Your version is $($PSVersionTable.PSVersion.Major)."  
        }

        # Make Secure.String to plain text string.
        $SecureString = $Credential | Select-Object -ExpandProperty Password
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)            
        $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

        $SteamCMDx64Location = 'C:\SteamCMD'
        $SteamCMDExecutable = "$($SteamCMDx64Location)\steamcmd.exe"    

        # If SteamCMD is not located in the following path we install it.
        if (-not (Test-Path -Path $SteamCMDExecutable))
        {
            $TempDirectory = 'C:\Temp'
            if (-not (Test-Path -Path $TempDirectory))
            {
                Write-Verbose -Message 'Creating Temp directory.'
                New-Item -Path 'C:\' -Name 'Temp' -ItemType Directory | Write-Verbose
            }

            # Download SteamCMD.
            Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile "$($TempDirectory)\steamcmd.zip"

            # Create SteamCMD directory in C:\ if necessary.
            if (-not (Test-Path -Path $SteamCMDx64Location))
            {
                Write-Verbose -Message 'Creating SteamCMD directory in C:\.'
                New-Item -Path 'C:\' -Name 'SteamCMD' -ItemType Directory | Write-Verbose
                Expand-Archive -Path "$($TempDirectory)\steamcmd.zip" -DestinationPath $SteamCMDx64Location
            }

            # Doing some initial configuration of SteamCMD. The first time SteamCMD is launched it will need to do some updates.
            Write-Host -Object 'Setting up SteamCMD for the first time. Please wait.' -NoNewline
            Start-Process -FilePath $SteamCMDExecutable -ArgumentList 'validate +quit' -WindowStyle Hidden
            do
            {
                Write-Host -Object "." -NoNewline
                Start-Sleep -Seconds 3
            }
            until (-not (Get-Process -Name "*steamcmd*"))
        }

        # We only retrieve all Steam apps ID and name if ParameterSetName is GameName.
        if ($PSCmdlet.ParameterSetName -eq 'GameName')
        {
            # Get most recent list with all Steam Apps ID and corresponding title and put it into a variable.
            $SteamAppsJSON = 'C:\Temp\SteamApps.json'
            function Get-SteamAppData
            {
                $SteamApps = Invoke-WebRequest -Uri 'https://api.steampowered.com/ISteamApps/GetAppList/v0001/' | Select-Object -ExpandProperty Content
                $SteamApps | Out-File -FilePath $SteamAppsJSON
                $SteamApps = $SteamApps | ConvertFrom-Json
            }
            if (-not (Test-Path -Path $SteamAppsJSON))
            {
                Get-SteamAppData
                Write-Verbose -Message "$($SteamAppsJSON) was not found. Download newest version."
            }
            if (Test-Path -Path $SteamAppsJSON -OlderThan (Get-Date).AddDays(-7))
            {
                Write-Verbose -Message "$($SteamAppsJSON) is older than 7 days. Downloading the newest version..."
                Get-SteamAppData
            }
            else
            {
                $SteamApps = Get-Content -Path $SteamAppsJSON | ConvertFrom-Json
                Write-Verbose -Message "Using $($SteamAppsJSON) as a source since it has been updated within the last 7 days."
            }
        
            # Access nested object app in apps in applist.
            $SteamApps = $SteamApps.applist.apps.app
        }
    } # Begin
    
    process
    {
        function Use-SteamCMD
        {
            # If Steam username and Steam password are not empty we use them for logging in.
            if ($null -ne $Credential)
            {
                Start-Process -FilePath $SteamCMDExecutable -NoNewWindow -ArgumentList "+login $($Credential | Select-Object -ExpandProperty UserName) $($PlainPassword) +force_install_dir $($Path) +app_update $($SteamAppID) $($Arguments) validate +quit" -Wait
            }
            # If Steam username and Steam password are empty we use anonymous login.
            else
            {
                Start-Process -FilePath $SteamCMDExecutable -NoNewWindow -ArgumentList "+login anonymous +force_install_dir $($Path) +app_update $($SteamAppID) $($Arguments) validate +quit" -Wait
            }
        }

        # If game is found by searching for game name.
        if ($PSCmdlet.ParameterSetName -eq 'GameName')
        {
            try
            {
                $SteamApps = $SteamApps | Where-Object -FilterScript {$PSItem.name -like "$($GameName)*"}

                # If only one game is found when searching by game name.
                if (($SteamApps | Measure-Object).Count -eq 1)
                {
                    Write-Verbose -Message "Only one game found: $($SteamApps.name) / $($SteamApps.appid)."
                    # Put Steam AppID into variable $SteamAppID.
                    $SteamAppID = $SteamApps.appid
                }
                # If more than one game is found the user is promted to select the exact game.
                elseif (($SteamApps | Measure-Object).Count -ge 1)
                {
                    # An OutGridView is presented to the user where the exact AppID can be located. This variable contains the AppID selected in the Out-GridView.
                    $SteamAppID = $SteamApps | Out-GridView -Title 'Select the game you wish to update or install.' -PassThru | Select-Object -ExpandProperty appid
                    Write-Verbose -Message "$($SteamAppID) selected from Out-GridView."
                }
                
                # Install selected Steam application if a SteamAppID has been selected.
                if (-not ($null -eq $SteamAppID))
                {
                    Use-SteamCMD
                }
            }
            catch
            {
                Throw "$($GameName) couldn't be updated."
            }
        } # ParameterSet GameName

        # If game is found by using a unique AppID.
        if ($PSCmdlet.ParameterSetName -eq 'AppID')
        {
            try
            {
                $SteamAppID = $AppID
                Write-Verbose -Message "The game with Steam AppID $($SteamAppID) is being updated. Please wait for SteamCMD to finish."

                # Install selected Steam application.
                Use-SteamCMD
            }
            catch
            {
                Throw "$($SteamAppID) coulnd't be updated."
            }
        } # ParameterSet AppID
    } # Process
} # Cmdlet