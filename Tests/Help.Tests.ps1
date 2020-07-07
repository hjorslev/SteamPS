# https://lazywinadmin.com/2016/05/using-pester-to-test-your-comment-based.html
# Refactored by Joel Sallow - https://github.com/vexx32/

BeforeAll {
    Import-Module $env:BHPSModuleManifest
}

Describe "$env:BHProjectName Comment Based Help" -Tags "Module" {
    #region Discovery
    Import-Module $env:BHPSModuleManifest

    $ShouldProcessParameters = 'WhatIf', 'Confirm'

    # Generate function test cases
    $FunctionList = Get-ChildItem -Path "$env:BHModulePath\Public" | ForEach-Object {
        # The data in these hashtables will map to variables in each It according to the current TestCase (per function)
        @{
            Name       = $_.BaseName
            Path       = $_.FullName
            Ast        = (Get-Content -Path "function:/$($_.BaseName)").Ast
            Help       = Get-Help -Name $_.BaseName -Full
            Parameters = Get-Help $_.BaseName -Parameter * |
            Where-Object { $_.Name -and $_.Name -notin $ShouldProcessParameters }
        }
    }
    #endregion Discovery

    It "has help content for <Name>" -TestCases $FunctionList {
        $Help | Should -Not -BeNullOrEmpty
    }

    It "contains a synopsis for <Name>" -TestCases $FunctionList {
        $Help.Synopsis | Should -Not -BeNullOrEmpty
    }

    It "contains a description for <Name>" -TestCases $FunctionList {
        $Help.Description | Should -Not -BeNullOrEmpty
    }

    It "lists the function author in the Notes section for <Name>" -TestCases $FunctionList {
        $Notes = $Help.AlertSet.Alert.Text -split '\n'
        $Notes[0].Trim() | Should -BeLike "Author: *"
    }

    It "has a help entry for each parameter of <Name>" -TestCases $FunctionList {
        $Parameters.Count | Should -Be $Ast.Body.ParamBlock.Parameters.Count -Because 'the number of parameters in the help should match the number in the function script'
    }

    It "has a description for all parameters of <Name>" -TestCases $FunctionList {
        # Candidate for using ShouldActionPreference = Continue
        foreach ($param in $Parameters) {
            $param.Description | Should -Not -BeNullOrEmpty -Because "parameter $($param.Name) should have a description"
        }
    }

    It "has at least one usage example for <Name>" -TestCases $FunctionList {
        $Help.Examples.Example.Code.Count | Should -BeGreaterOrEqual 1
    }

    It "lists a description for all examples" {
        # Candidate for using ShouldActionPreference = Continue
        foreach ($Example in $Help.Examples.Example) {
            $Example.Remarks | Should -Not -BeNullOrEmpty -Because "example $($Example.Title) should have a description!"
        }
    }
} # Describe