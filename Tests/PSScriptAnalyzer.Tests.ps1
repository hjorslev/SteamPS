Describe 'PSScriptAnalyzer analysis' {
    #region Discovery
    $PowerShellFiles = Get-ChildItem -Path $env:BHModulePath -Recurse -Filter "*.ps*1"
    #endregion Discovery

    It "<Path> Should not violate: <IncludeRule>" -TestCases @(
        foreach ($File in $PowerShellFiles) {
            foreach ($Rule in (Get-ScriptAnalyzerRule)) {
                @{
                    IncludeRule = $Rule.RuleName
                    Path        = $File.FullName
                }
            }
        }
    ) {
        param($IncludeRule, $Path)
        Invoke-ScriptAnalyzer -Path $Path -IncludeRule $IncludeRule -Settings "$env:BHProjectPath\PSScriptAnalyzerSettings.psd1" | Should -BeNullOrEmpty
    }
}