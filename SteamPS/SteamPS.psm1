# Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Recurse -ErrorAction SilentlyContinue )

# Dot source the files
foreach ($Import in @($Public + $Private)) {
    try {
        . $Import.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Import.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName

if ($Host.Name -eq 'Windows PowerShell ISE Host') {
    Write-Warning -Message 'Output from SteamCMD might not be visible in PowerShell ISE, but will run in the background.'
    Write-Warning -Message 'Consider using PowerShell ConsoleHost instead.'
}

Load-Module Logging