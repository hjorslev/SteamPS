BeforeAll {
    . $SteamPSModulePath\Private\Server\Get-PacketString.ps1
}

Describe "Get-PacketString Cmdlet" {
    Context "When using a valid stream" {
        It "Returns the correct string" {
            # Prepare test data
            $stream = New-Object System.IO.MemoryStream
            $binaryWriter = New-Object System.IO.BinaryWriter $stream
            $expectedString = "Hello, World!"
            $expectedStringBytes = [System.Text.Encoding]::UTF8.GetBytes($expectedString)
            $binaryWriter.Write($expectedStringBytes)
            $binaryWriter.Write([byte]0) # Append null terminator
            $stream.Position = 0

            # Execute the cmdlet
            $result = Get-PacketString -Stream (New-Object System.IO.BinaryReader $stream)

            # Assert
            $result | Should -BeExactly $expectedString

            # Cleanup
            $binaryWriter.Dispose()
            $stream.Dispose()
        }
    }

    Context "When using an empty stream" {
        It "Returns nothing" {
            # Prepare test data
            $stream = New-Object System.IO.MemoryStream

            # Execute the cmdlet
            $result = Get-PacketString -Stream (New-Object System.IO.BinaryReader $stream)

            # Assert
            $result | Should -BeNullOrEmpty

            # Cleanup
            $stream.Dispose()
        }
    }

    Context "When using a stream with only null terminator" {
        It "Returns an empty string" {
            # Prepare test data
            $stream = New-Object System.IO.MemoryStream
            $binaryWriter = New-Object System.IO.BinaryWriter $stream
            $binaryWriter.Write([byte]0) # Only null terminator
            $stream.Position = 0

            # Execute the cmdlet
            $result = Get-PacketString -Stream (New-Object System.IO.BinaryReader $stream)

            # Assert
            $result | Should -BeNullOrEmpty

            # Cleanup
            $binaryWriter.Dispose()
            $stream.Dispose()
        }
    }
}
