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

    If you use Steam login to install/upload the app the following arguments are already used: "+force_install_dir $Path +login $SteamUserName $SteamPassword +app_update $SteamAppID $Arguments +quit"

    If you use anonymous login to install/upload the app the following arguments are already used: "+force_install_dir $Path +login anonymous +app_update $SteamAppID $Arguments +quit"

    .PARAMETER Force
    The Force parameter allows the user to skip the "Should Continue" box.

    .EXAMPLE
    Update-SteamApp -ApplicationName 'Arma 3' -Credential 'Toby' -Path 'C:\DedicatedServers\Arma3'

    Because there are multiple hits when searching for Arma 3, the user will be promoted to select the right application.

    .EXAMPLE
    Update-SteamApp -AppID 376030 -Path 'C:\DedicatedServers\ARK-SurvivalEvolved'

    Here we use anonymous login because the particular application (ARK: Survival Evolved Dedicated Server) doesn't require login.

    .NOTES
    Author: Frederik Hjorslev Nylander

    SteamCMD CLI parameters: https://developer.valvesoftware.com/wiki/Command_Line_Options#Command-line_parameters_4

    .LINK
    https://hjorslev.github.io/SteamPS/Update-SteamApp.html
    #>

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification='Is implemented but not accepted by PSSA.')]
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
            ParameterSetName = 'ApplicationID'
        )]
        [ValidateScript({
            if ($null -eq (Get-SteamGame -ApplicationID $_)) {
                throw "ApplicationID $_ couldn't be found."
            }
            $true
        })]
        [Alias('AppID')]
        [int]$ApplicationID,

        [Parameter(Mandatory = $true)]
        [ValidateScript( {
                if ($_.Substring(($_.Length -1)) -eq '\') {
                    throw "Path may not end with a trailing slash."
                }
                $true
            })]
        [string]$Path,

        [Parameter(Mandatory = $false)]
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
        if ($null -eq (Get-SteamPath)) {
            throw 'SteamCMD could not be found in the env:Path. Have you executed Install-SteamCMD?'
        }

        # Install SteamCMD if it is missing.
        if (-not (Test-Path -Path (Get-SteamPath).Executable)) {
            Start-Process powershell -ArgumentList '-NoExit -Command "Install-SteamCMD; exit"' -Verb RunAs
            Write-Verbose -Message 'Installing SteamCMD in another window. Please wait and try again.'
            throw "SteamCMD is missing and is being installed in another window. Please wait until the other window closes, restart your console, and try again."
        }
    } # Begin

    process {
        function Use-SteamCMD ($SteamAppID) {
            # If Steam username and Steam password are not empty we use them for logging in.
            if ($null -ne $Credential.UserName) {
                Write-Verbose -Message "Logging into Steam as $($Credential | Select-Object -ExpandProperty UserName)."
                $SteamCMDProcess = Start-Process -FilePath (Get-SteamPath).Executable -NoNewWindow -ArgumentList "+force_install_dir `"$Path`" +login $($Credential.UserName) $($Credential.GetNetworkCredential().Password) +app_update $SteamAppID $Arguments +quit" -Wait -PassThru
                if ($SteamCMDProcess.ExitCode -ne 0) {
                    Write-Error -Message ("SteamCMD closed with ExitCode {0}" -f $SteamCMDProcess.ExitCode) -Category CloseError
                }
            }
            # If Steam username and Steam password are empty we use anonymous login.
            elseif ($null -eq $Credential.UserName) {
                Write-Verbose -Message 'Using SteamCMD as anonymous.'
                $SteamCMDProcess = Start-Process -FilePath (Get-SteamPath).Executable -NoNewWindow -ArgumentList "+force_install_dir `"$Path`" +login anonymous +app_update $SteamAppID $Arguments +quit" -Wait -PassThru
                if ($SteamCMDProcess.ExitCode -ne 0) {
                    Write-Error -Message ("SteamCMD closed with ExitCode {0}" -f $SteamCMDProcess.ExitCode) -Category CloseError
                }
            }
        }

        # If game is found by searching for game name.
        if ($PSCmdlet.ParameterSetName -eq 'ApplicationName') {
            try {
                $SteamApp = Get-SteamGame -ApplicationName $ApplicationName
                # Install selected Steam application if a SteamAppID has been selected.
                if (-not ($null -eq $SteamApp)) {
                    if ($Force -or $PSCmdlet.ShouldContinue("Do you want to install or update $($SteamApp.ApplicationName)?", "Update SteamApp $($SteamApp.ApplicationName)?")) {
                        Write-Verbose -Message "The application $($SteamApp.ApplicationName) is being updated. Please wait for SteamCMD to finish."
                        Use-SteamCMD -SteamAppID $SteamApp.ApplicationID
                    } # Should Continue
                }
            } catch {
                Throw "$ApplicationName couldn't be updated."
            }
        } # ParameterSet ApplicationName

        # If game is found by using a unique ApplicationID.
        if ($PSCmdlet.ParameterSetName -eq 'ApplicationID') {
            try {
                $SteamAppID = $ApplicationID
                # Install selected Steam application.
                if ($Force -or $PSCmdlet.ShouldContinue("Do you want to install or update $($SteamAppID)?", "Update SteamApp $($SteamAppID)?")) {
                    Write-Verbose -Message "The application with AppID $SteamAppID is being updated. Please wait for SteamCMD to finish."
                    Use-SteamCMD -SteamAppID $SteamAppID
                } # Should Continue
            } catch {
                Throw "$SteamAppID couldn't be updated."
            }
        } # ParameterSet AppID
    } # Process
} # Cmdlet