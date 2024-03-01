function Add-EnvPath {
    <#
    .LINK
    https://gist.github.com/mkropat/c1226e0cc2ca941b23a9
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string]$Container = 'Session'
    )

    process {
        Write-Verbose -Message "Container is set to: $Container"
        $Path = $Path.Trim()

        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User    = [EnvironmentVariableTarget]::User
            Session = [EnvironmentVariableTarget]::Process
        }

        $containerType = $containerMapping[$Container]
        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType).
            Split([System.IO.Path]::PathSeparator).Trim() -ne ''

        if ($persistedPaths -notcontains $Path) {
            # previous step with `Trim()` + `-ne ''` already takes care of empty tokens,
            # no need to filter again here
            $persistedPaths = ($persistedPaths + $Path) -join [System.IO.Path]::PathSeparator
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths, $containerType)

            Write-Verbose -Message "Adding $Path to environment path."
        } else {
            Write-Verbose -Message "$Path is already located in env:Path."
        }
    } # Process
} # Cmdlet