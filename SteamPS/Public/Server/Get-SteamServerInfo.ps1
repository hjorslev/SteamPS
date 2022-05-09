function Get-SteamServerInfo {
    <#
    .SYNOPSIS
    Query a running steam based game server.

    .DESCRIPTION
    The cmdlet fetches server information from a running game server using UDP/IP packets.
    It will return information ServerName, Map, InstallDir, GameName, AppID, Players
    MaxPlayers, Bots, ServerType, Environment, Visibility, VAC andVersion.

    .PARAMETER IPAddress
    Enter the IP address of the Steam based server.

    .PARAMETER Port
    Enter the port number of the Steam based server.

    .PARAMETER Timeout
    Timeout in milliseconds before giving up querying the server.

    .EXAMPLE
    Get-SteamServerInfo -IPAddress '185.15.73.207' -Port 27015

    ```
    Protocol      : 17
    ServerName    : SAS Proving Ground 10 (EU)
    Map           : TH-SmallTown
    InstallDir    : groundbranch
    GameName      : Ground Branch
    AppID         : 16900
    Players       : 6
    MaxPlayers    : 10
    Bots          : 0
    ServerType    : Dedicated
    Environment   : Windows
    Visibility    : Public
    VAC           : Unsecured
    Version       : 1.0.0.0
    ExtraDataFlag : 177
    IPAddress     : 185.15.73.207
    Port          : 27015
    ```

    .NOTES
    Author: Jordan Borean, Chris Dent and Frederik Hjorslev Nylander

    .LINK
    https://hjorslev.github.io/SteamPS/Get-SteamServerInfo.html
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Enter the IP address of the Steam based server.')]
        [System.Net.IPAddress]$IPAddress,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Enter the port number of the Steam based server.')]
        [int]$Port,

        [Parameter(Mandatory = $false,
            HelpMessage = 'Timeout in milliseconds before giving up querying the server.')]
        [int]$Timeout = 5000
    )

    begin {
        # A2S_INFO: Retrieves information about the server including, but not limited to: its name, the map currently being played, and the number of players.
        # https://developer.valvesoftware.com/wiki/Server_queries#A2S_INFO
        $A2S_INFO = [byte]0xFF, 0xFF, 0xFF, 0xFF, 0x54, 0x53, 0x6F, 0x75, 0x72, 0x63, 0x65, 0x20, 0x45, 0x6E, 0x67, 0x69, 0x6E, 0x65, 0x20, 0x51, 0x75, 0x65, 0x72, 0x79, 0x00
    }

    process {
        try {
            # Instantiate client and endpoint
            $Client = New-Object -TypeName Net.Sockets.UDPClient(0)
            [void]$Client.Send($A2S_INFO, $A2S_INFO.Length, $IPAddress, $Port)
            $Client.Client.SendTimeout = $Timeout
            $Client.Client.ReceiveTimeout = $Timeout
            $IPEndpoint = New-Object -TypeName Net.IPEndpoint([Net.IPAddress]::Any, 0)

            # The first 4 bytes are 255 which seems to be some sort of header.
            $ReceivedData = $Client.Receive([Ref]$IPEndpoint) | Select-Object -Skip 4
            $Stream = [System.IO.BinaryReader][System.IO.MemoryStream][Byte[]]$ReceivedData

            # Challenge:
            if ($Stream.ReadByte() -eq 65) {
                # If the response is a challenge, resend query with last 4 bytes of the challenge
                $challenge = while ($Stream.BaseStream.Position -lt $Stream.BaseStream.Length) {
                    $Stream.ReadByte()
                }
                $newQuery = $A2S_INFO + $challenge

                [void]$Client.Send($newQuery, $newQuery.Length, $IPAddress, $Port)
                # The first 4 bytes are 255 which seems to be some sort of header.
                $ReceivedData = $Client.Receive([Ref]$IPEndpoint) | Select-Object -Skip 4
                $Stream = [System.IO.BinaryReader][System.IO.MemoryStream][Byte[]]$ReceivedData
            }

            $Client.Close()
        } catch {
            $Exception = [Exception]::new("Could not reach server {0}:{1}.") -f $IPAddress, $Port
            $ErrorRecord = [System.Management.Automation.ErrorRecord]::new(
                $Exception,
                "ServerNotFound",
                [System.Management.Automation.ErrorCategory]::ConnectionError,
                $ReceivedData
            )
            $PSCmdlet.WriteError($ErrorRecord)
        }

        # If we cannot reach the server we will not display the empty object.
        if ($Stream) {
            # This is also a header - that will always be equal to 'I' (0x49).
            $Stream.ReadByte() | Out-Null
            [PSCustomObject]@{
                Protocol      = [int]$Stream.ReadByte()
                ServerName    = Get-PacketString -Stream $Stream
                Map           = Get-PacketString -Stream $Stream
                InstallDir    = Get-PacketString -Stream $Stream
                GameName      = Get-PacketString -Stream $Stream
                AppID         = [int]$Stream.ReadUInt16()
                Players       = [int]$Stream.ReadByte()
                MaxPlayers    = [int]$Stream.ReadByte()
                Bots          = $Stream.ReadByte()
                ServerType    = [ServerType]$Stream.ReadByte()
                Environment   = [OSType]$Stream.ReadByte()
                Visibility    = [Visibility]$Stream.ReadByte()
                VAC           = [VAC]$Stream.ReadByte()
                Version       = Get-PacketString -Stream $Stream
                ExtraDataFlag = $Stream.ReadByte()
                IPAddress     = $IPAddress
                Port          = $Port
            } # PSCustomObject
        }
    } # Process
} # Cmdlet