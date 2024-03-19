BeforeAll {
    . $SteamPSModulePath\Private\Server\Add-EnvPath.ps1
}
Describe "Add-EnvPath" {
    Context "When adding a new path to the session environment" {
        It "Should add the path to the session environment" {
            $originalPath = [Environment]::GetEnvironmentVariable('Path', 'Process')
            $newPath = "C:\NewPath"

            Add-EnvPath -Path $newPath

            $updatedPath = [Environment]::GetEnvironmentVariable('Path', 'Process')

            $updatedPath -split [System.IO.Path]::PathSeparator | Should -Contain $newPath

            # Cleanup
            [Environment]::SetEnvironmentVariable('Path', $originalPath, 'Process')
        }
    }

    Context "When adding an existing path to the session environment" {
        It "Should not add the path again" {
            $originalPath = [Environment]::GetEnvironmentVariable('Path', 'Process')
            $existingPath = $originalPath -split [System.IO.Path]::PathSeparator | Select-Object -First 1

            Add-EnvPath -Path $existingPath

            $updatedPath = [Environment]::GetEnvironmentVariable('Path', 'Process')

            $updatedPath -split [System.IO.Path]::PathSeparator | Should -Contain $existingPath

            # Cleanup
            [Environment]::SetEnvironmentVariable('Path', $originalPath, 'Process')
        }
    }

    Context "When adding a new path to the user environment" {
        It "Should add the path to the user environment" {
            $originalPath = [Environment]::GetEnvironmentVariable('Path', 'User')
            $newPath = "C:\NewPath"

            Add-EnvPath -Path $newPath -Container 'User'

            $updatedPath = [Environment]::GetEnvironmentVariable('Path', 'User')

            $updatedPath -split [System.IO.Path]::PathSeparator | Should -Contain $newPath

            # Cleanup
            [Environment]::SetEnvironmentVariable('Path', $originalPath, 'User')
        }
    }

    Context "When adding a new path to the machine environment" {
        It "Should add the path to the machine environment" {
            $originalPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
            $newPath = "C:\NewPath"

            Add-EnvPath -Path $newPath -Container 'Machine'

            $updatedPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')

            $updatedPath -split [System.IO.Path]::PathSeparator | Should -Contain $newPath

            # Cleanup
            [Environment]::SetEnvironmentVariable('Path', $originalPath, 'Machine')
        }
    }
}
