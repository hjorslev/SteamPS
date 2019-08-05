function Load-Module {
    [CmdletBinding()]
    param (
        [string]$Module
    )

    process {
        # If module is imported say that and do nothing.
        if (Get-Module -Name $Module) {
            Write-Warning -Message "Module $($Module) is already imported."
        } else {
            # If module is not imported, but available on disk then import.
            if (Get-Module -Name $Module -ListAvailable) {
                # Load module
                Write-Verbose -Message "Initializing $($Module)"
                Import-Module -Name $Module
                # Runs background job where module is updated if needed.
                Start-Job -Name "Update $($Module)" -ScriptBlock { Update-Module -Name $Args[0] -Force } -ArgumentList $Module | Out-Null
            } else {
                # If module is not imported, not available on disk, but is in online gallery then install and import.
                if (Find-Module -Name $Module) {
                    # If prompt is elevated module making it available to all users else it's installed locally.
                    if ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $true) {
                        Write-Verbose -Message "Installing $($Module) globally, making it available for all users. Hang on."
                        Install-Module -Name $Module -Force
                        Import-Module -Name $Module
                    } else {
                        Write-Verbose -Message "Installing $($Module) locally, making it available for $($env:USERNAME). Hang on."
                        Install-Module -Name $Module -Force -Scope CurrentUser -AllowClobber
                        Import-Module -Name $Module
                    }
                } else {
                    # If module is not imported, not available and not in online gallery then abort.
                    Throw "Module $($Module) not imported, not available and not in online gallery, exiting."
                }
            }
        }
    } # Process
} # Cmdlet