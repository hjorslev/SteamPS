function Get-PacketString {
    <#
    .SYNOPSIS
    Get a string in a byte stream.

    .DESCRIPTION
    Get a string in a byte stream.

    .PARAMETER Stream
    Accepts BinaryReader.

    .EXAMPLE
    Get-PacketString -Stream $Stream

    Assumes that you already have a byte stream. See more detailed usage in
    Get-SteamServerInfo.

    .NOTES
    Author: Jordan Borean and Chris Dent
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.BinaryReader]$Stream
    )

    process {
        # Check if the stream has any bytes available
        if ($Stream.BaseStream.Length -gt 0) {
            # Find the end of the string, terminated with \0 and convert that byte range to a string.
            $stringBytes = while ($true) {
                $byte = $Stream.ReadByte()
                if ($byte -eq 0) {
                    break
                }
                $byte
            }
        }

        if ($stringBytes.Count -gt 0) {
            [System.Text.Encoding]::UTF8.GetString($stringBytes)
        }
    } # Process
} # Cmdlet