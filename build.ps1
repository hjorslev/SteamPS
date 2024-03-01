﻿# I may've totally stolen this from jborean93 :D
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('Debug', 'Release')]
    [string]
    $Configuration = 'Debug',

    [Parameter()]
    [ValidateSet('Build', 'Test')]
    [string[]]
    $Task = 'Build'
)

end {
    if ($PSEdition -eq 'Desktop') {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 'Tls12'
    }

    $modulePath = [IO.Path]::Combine($PSScriptRoot, 'tools', 'Modules')
    $requirements = Import-PowerShellDataFile ([IO.Path]::Combine($PSScriptRoot, 'tools', 'requiredModules.psd1'))

    foreach ($req in $requirements.GetEnumerator() | Sort-Object { $_.Value['Priority'] }) {
        $targetPath = [IO.Path]::Combine($modulePath, $req.Key)

        if (Test-Path -LiteralPath $targetPath) {
            Import-Module -Name $targetPath -Force -ErrorAction Stop -DisableNameChecking
            continue
        }

        Write-Host "Installing build pre-req $($req.Key) as it is not installed"
        $null = New-Item -Path $targetPath -ItemType Directory -Force

        $webParams = @{
            Uri             = "https://www.powershellgallery.com/api/v2/package/$($req.Key)/$($req.Value['Version'])"
            OutFile         = [IO.Path]::Combine($modulePath, "$($req.Key).zip")
            UseBasicParsing = $true
        }

        if ('Authentication' -in (Get-Command -Name Invoke-WebRequest).Parameters.Keys) {
            $webParams.Authentication = 'None'
        }

        $oldProgress = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'

        try {
            Invoke-WebRequest @webParams
            Expand-Archive -Path $webParams.OutFile -DestinationPath $targetPath -Force
            Remove-Item -LiteralPath $webParams.OutFile -Force
        } finally {
            $ProgressPreference = $oldProgress
        }

        Import-Module -Name $targetPath -Force -ErrorAction Stop -DisableNameChecking
    }

    if (Test-Path (Join-Path $PSScriptRoot src)) {
        $dotnetTools = @(dotnet tool list --global) -join "`n"
        if (-not $dotnetTools.Contains('coverlet.console')) {
            Write-Host 'Installing dotnet tool coverlet.console'
            dotnet tool install --global coverlet.console
        }
    }

    $invokeBuildSplat = @{
        Task          = $Task
        File          = (Get-Item ([IO.Path]::Combine($PSScriptRoot, '*.build.ps1'))).FullName
        Configuration = $Configuration
    }
    Invoke-Build @invokeBuildSplat
}
