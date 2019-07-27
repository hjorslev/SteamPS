$PowerShellFiles = Get-ChildItem $env:BHProjectPath -Recurse -Filter *.ps*1 -Exclude 'build.ps1', 'install.ps1', 'psake.ps1'
$ExcludeRules = 'PSAvoidUsingWriteHost', 'PSAvoidUsingInvokeExpression'

foreach ($PowerShellFile in $PowerShellFiles) {
    Describe "File $($PowerShellFile) should not produce any PSScriptAnalyzer warnings" {
        $Analysis = Invoke-ScriptAnalyzer -Path $PowerShellFile.FullName -ExcludeRule $ExcludeRules

        foreach ($Rule in $ScriptAnalyzerRules) {
            It "Should pass $Rule" {
                if ($Analysis.RuleName -contains $Rule) {

                    $Analysis | Where-Object RuleName -eq $Rule -OutVariable Failures | Out-Default

                    $Failures.Count | Should -Be 0
                }
            } # It
        } # foreach
    } # Describe
} # foreach