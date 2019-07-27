function Update-SteamApp {
    <#
    .SYNOPSIS
    Install or update a Steam application using SteamCMD.

    .DESCRIPTION
    Install or update a Steam application using SteamCMD. If SteamCMD is missing, it will be installed first.
    You can either search for the application by name or enter the specific Application ID.

    .PARAMETER ApplicationName
    Enter the name of the app to make a wildcard search for the application.

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

    .PARAMETER Force
    The Force parameter allows the user to skip the "Should Continue" box.

    .EXAMPLE
    Update-SteamApp -ApplicationName 'Arma 3' -Credential 'Toby' -Path 'C:\Servers\Arma3'

    Because there are multiple hits when searching for Arma 3, the user will be promoted to select the right application.

    .EXAMPLE
    Update-SteamApp -AppID 376030 -Path 'C:\Servers'

    Here we use anonymous login because the particular application (ARK: Survival Evolved Dedicated Server) doesn't require login.

    .NOTES
    Author: Frederik Hjorslev Poulsen

    SteamCMD CLI parameters: https://developer.valvesoftware.com/wiki/Command_Line_Options#Command-line_parameters_4

    .LINK
    https://hjorslev.github.io/SteamPS/Update-SteamApp.html
    #>

    [CmdletBinding(SupportsShouldProcess = $true,
        ConfirmImpact = 'Medium'
    )]
    param (
        [Parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ApplicationName'
        )]
        [Alias('GameName')]
        [string]$ApplicationName,

        [Parameter(Position = 0,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'AppID'
        )]
        [int]$AppID,

        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$Path,

        [ValidateNotNull()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty,

        [Parameter(Mandatory = $false)]
        [string]$Arguments,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    begin {
        $RegistryPath = 'HKLM:\SOFTWARE\SteamPS'
        $InstallPath = (Get-ItemProperty -Path $RegistryPath -Name InstallPath -ErrorAction SilentlyContinue).InstallPath
        $SteamCMDExecutable = "$($InstallPath)\steamcmd.exe"

        # Make Secure.String to plain text string.
        if ($null -eq $Credential) {
            $SecureString = $Credential | Select-Object -ExpandProperty Password
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
            $PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        }

        # Install SteamCMD if it is missing.
        if (-not (Test-Path -Path $SteamCMDExecutable)) {
            Start-Process powershell -ArgumentList '-NoExit -Command "Install-SteamCMD; exit"' -Verb RunAs
            Write-Verbose -Message 'Installing SteamCMD in another window. Please wait and try again.'
            throw "SteamCMD is missing and is being installed in another window. Please wait until the other window closes and try again."
        }
    } # Begin

    process {
        function Use-SteamCMD ($SteamAppID) {
            # If Steam username and Steam password are not empty we use them for logging in.
            if ($null -ne $Credential.UserName) {
                Write-Verbose -Message "Logging into Steam as $($Credential | Select-Object -ExpandProperty UserName)."
                Start-Process -FilePath $SteamCMDExecutable -NoNewWindow -ArgumentList "+login $($Credential | Select-Object -ExpandProperty UserName) $($PlainPassword) +force_install_dir `"$($Path)`" +app_update $($SteamAppID) $($Arguments) validate +quit" -Wait
            }
            # If Steam username and Steam password are empty we use anonymous login.
            elseif ($null -eq $Credential.UserName) {
                Write-Verbose -Message 'Using anonymous Steam login.'
                Start-Process -FilePath $SteamCMDExecutable -NoNewWindow -ArgumentList "+login anonymous +force_install_dir `"$($Path)`" +app_update $($SteamAppID) $($Arguments) validate +quit" -Wait
            }
        }

        # If game is found by searching for game name.
        if ($PSCmdlet.ParameterSetName -eq 'ApplicationName') {
            try {
                $SteamApp = Find-SteamAppID -ApplicationName $ApplicationName
                # Install selected Steam application if a SteamAppID has been selected.
                if (-not ($null -eq $SteamApp)) {
                    if ($Force -or $PSCmdlet.ShouldContinue("Do you want to install or update $(($SteamApp).name)?", "Update SteamApp $(($SteamApp).name)?")) {
                        Write-Verbose -Message "The application $(($SteamApp).name) is being updated. Please wait for SteamCMD to finish."
                        Use-SteamCMD -SteamAppID ($SteamApp).appid
                    } # Should Continue
                }
            } catch {
                Throw "$($ApplicationName) couldn't be updated."
            }
        } # ParameterSet ApplicationName

        # If game is found by using a unique AppID.
        if ($PSCmdlet.ParameterSetName -eq 'AppID') {
            try {
                $SteamAppID = $AppID
                # Install selected Steam application.
                if ($Force -or $PSCmdlet.ShouldContinue("Do you want to install or update $($SteamAppID)?", "Update SteamApp $($SteamAppID)?")) {
                    Write-Verbose -Message "The application with AppID $($SteamAppID) is being updated. Please wait for SteamCMD to finish."
                    Use-SteamCMD -SteamAppID $SteamAppID
                } # Should Continue
            } catch {
                Throw "$($SteamAppID) couldn't be updated."
            }
        } # ParameterSet AppID
    } # Process
} # Cmdlet