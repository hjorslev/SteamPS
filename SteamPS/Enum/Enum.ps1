enum ServerType {
    Dedicated = 0x64    #d
    NonDedicated = 0x6C #l
    SourceTV = 0x70     #p
}
enum OSType {
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
    Public = 0
    Private = 1
}

if ($PSVersionTable.PSVersion.Major -le 5 -and $PSVersionTable.PSVersion.Minor -le 1) {
    Write-Warning -Message "The support for Windows PowerShell (v5) will be deprecated in the next major version of SteamPS. Please ensure your system supports PowerShell 7."
}