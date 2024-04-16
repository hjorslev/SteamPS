function Test-Admin {
    <#
    .SYNOPSIS
    Checks whether the current user has administrator privileges.

    .DESCRIPTION
    This cmdlet verifies if the current user has administrator privileges on the system.

    .EXAMPLE
    PS C:\> Test-Admin
    True
    This example checks if the current user has administrator privileges and returns True if they do.

    .NOTES
    Author: Marius Storhaug <https://github.com/PSModule/Admin>
    #>

    [OutputType([System.Boolean])]
    [CmdletBinding()]
    [Alias('Test-Administrator', 'IsAdmin', 'IsAdministrator')]
    param (
    )

    begin {
        Write-Verbose -Message "[BEGIN  ] Starting: $($MyInvocation.MyCommand)"
    }

    process {
        $IsUnix = $PSVersionTable.Platform -eq 'Unix'
        if ($IsUnix) {
            Write-Verbose -Message "Running on Unix, checking if user is root."
            $whoAmI = $(whoami)
            Write-Verbose -Message "whoami: $whoAmI"
            $IsRoot = $whoAmI -eq 'root'
            Write-Verbose -Message "IsRoot: $IsRoot"
            $IsRoot
        } else {
            Write-Verbose -Message "Running on Windows, checking if user is an Administrator."
            $User = [Security.Principal.WindowsIdentity]::GetCurrent()
            $Principal = New-Object Security.Principal.WindowsPrincipal($User)
            $isAdmin = $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
            Write-Verbose -Message "IsAdmin: $isAdmin"
            $isAdmin
        }
    }

    end {
        Write-Verbose -Message "[END    ] Ending: $($MyInvocation.MyCommand)"
    }
}
