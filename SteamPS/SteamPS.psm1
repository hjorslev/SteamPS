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

Use-Module -Name Logging

# Enums
enum ServerType {
    Dedicated = 0x64    #d
    NonDedicated = 0x6C #l
    SourceTV = 0x70     #p
}
enum Environment {
    Linux = 108   #l
    Windows = 119 #w
    Mac = 109     #m
    MacOsX = 111  #o
}
enum VAC {
    Unsecured = 0
    Secured = 1
}
enum Visibility {
    Public  = 0
    Private = 1
}