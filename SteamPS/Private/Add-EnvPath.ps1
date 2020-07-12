function Add-EnvPath {
    <#
    .LINK
    https://gist.github.com/mkropat/c1226e0cc2ca941b23a9
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string]$Container = 'Session'
    )

    process {
        Write-Verbose -Message "Container is set to: $Container"
        if ($Container -ne 'Session') {
            $containerMapping = @{
                Machine = [EnvironmentVariableTarget]::Machine
                User    = [EnvironmentVariableTarget]::User
            }
            $containerType = $containerMapping[$Container]

            $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
            if ($persistedPaths -notcontains $Path) {
                $persistedPaths = $persistedPaths + $Path | Where-Object -FilterScript { $_ }
                [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
                Write-Verbose -Message "Adding $Path to environment path."
            } else {
                Write-Verbose -Message "$Path is already located in env:Path."
            }
        }

        $envPaths = $env:Path -split ';'
        if ($envPaths -notcontains $Path) {
            $envPaths = $envPaths + $Path | Where-Object -FilterScript { $_ }
            $env:Path = $envPaths -join ';'
            Write-Verbose -Message "Adding $Path to environment path."
        } else {
            Write-Verbose -Message "$Path is already located in env:Path."
        }
    } # Process
} # Cmdlet