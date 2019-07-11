function Get-SteamServerInfo {
    <#
    .SYNOPSIS
    - Get server information about game servers.

    .DESCRIPTION
    Get server information about game servers from Rust Server Info (RSI).
    Servers must be added at https://api.rust-servers.info/ prior to using this app.


    .PARAMETER ServerID
    Enter server ID from Rust Server Info. A list of all servers can be found at
    https://rust-servers.info/all-servers.html - ID is located in the URL e.g.
    https://rust-servers.info/server/id-2743.html

    .EXAMPLE
    Get-SteamServerInfo -ServerID 2743

    .NOTES
    Author: Frederik Hjorslev Poulsen

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('ID')]
        [string]$ServerID
    )

    process {
        $ServerInformation = Invoke-RestMethod -Uri "https://api.rust-servers.info/info/$($ServerID)"
        if ($ServerInformation -eq "Errror: You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near '' at line 1") {
            Throw "Server with ID $($ServerID) not found. Please ensure the server has been added, or add it manually at https://api.rust-servers.info/"
        } else {
            Write-Output -InputObject $ServerInformation
        }
    }
}