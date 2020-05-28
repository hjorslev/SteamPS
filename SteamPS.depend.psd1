﻿@{
    # Some defaults for all dependencies
    PSDependOptions    = @{
        Target     = '$env:USERPROFILE\Documents\WindowsPowerShell\Modules'
        AddToPath  = $true
        Parameters = @{
            Force = $true
        }
    }
    <#
    # Install Chocolatey
    'Chocolatey'        = @{
        DependencyType = 'Command'
        Source         = 'Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))'
    }

    # Install Chocolatey package
    'Chocolatey-mkdocs' = @{
        DependencyType = 'Command'
        Source         = 'choco install mkdocs -y --no-progress'
    }
#>
    # Grab some modules without depending on PowerShellGet
    'BuildHelpers'     = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'Configuration'    = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'InvokeBuild'      = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'Logging'          = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'Pester'           = @{ DependencyType = 'PSGalleryNuget'; version = '4.10.1' }
    'platyPS'          = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'posh-git'         = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'PSDeploy'         = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'PSScriptAnalyzer' = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'powershell-yaml'  = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
}