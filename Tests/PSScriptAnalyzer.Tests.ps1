$ScriptAnalyzerRules = Get-ScriptAnalyzerRule
$PowerShellFiles = Get-ChildItem $env:BHProjectPath -Recurse -Filter *.ps*1

foreach ($PowerShellFile in $PowerShellFiles) {
    Describe "File $($PowerShellFile) should not produce any PSScriptAnalyzer warnings" {
        $Analysis = Invoke-ScriptAnalyzer -Path $PowerShellFile.FullName -Settings "$($env:BHProjectPath)\PSScriptAnalyzerSettings.psd1"

        foreach ($Rule in $ScriptAnalyzerRules) {
            It "Should pass $Rule" {
                if ($Analysis.RuleName -contains $Rule) {
                    $Analysis | Where-Object -FilterScript { $_.RuleName -eq $Rule } -OutVariable Failures | Out-Default
                    $Failures.Count | Should -Be 0
                }
            } # It
        } # foreach
    } # Describe
} # foreach