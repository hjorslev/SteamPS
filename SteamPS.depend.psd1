@{
    # Some defaults for all dependencies
    PSDependOptions    = @{
        Target     = '$env:USERPROFILE\Documents\WindowsPowerShell\Modules'
        AddToPath  = $true
        Parameters = @{
            Force = $true
        }
    }

    # Grab some modules without depending on PowerShellGet
    'BuildHelpers'     = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'Configuration'    = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'InvokeBuild'      = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'Pester'           = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'platyPS'          = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'posh-git'         = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'PSDeploy'         = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'PSFramework'      = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'PSScriptAnalyzer' = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
    'powershell-yaml'  = @{ DependencyType = 'PSGalleryNuget'; version = 'latest' }
}