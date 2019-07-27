@{
    # Some defaults for all dependencies
    PSDependOptions    = @{
        Target     = '$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules'
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
    'Pester'           = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'platyPS'          = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'posh-git'         = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'PSDeploy'         = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'psake'            = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'PSGitHub'         = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'PSScriptAnalyzer' = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'powershell-yaml'  = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
}