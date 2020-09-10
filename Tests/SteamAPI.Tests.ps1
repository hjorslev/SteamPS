Describe "Find-SteamAppID" {
    It "Finds game 'Ground Branch'" {
        $GB = Find-SteamAppID -ApplicationName 'Ground Branch Dedicated Server'
        $GB.appid | Should -Be 476400
        $GB.name | Should -Be 'Ground Branch Dedicated Server'
    }
}

Describe 'Resolve-VanityURL' {
    BeforeEach {
        function Get-SteamAPIKey {}
        Mock -CommandName Get-SteamAPIKey -MockWith {
            Write-Output -InputObject $env:SteamWebAPI
        }
    }
    It "Resolves an individual profile" {
        (Resolve-VanityURL -VanityURL 'hjorslev').SteamID64 | Should -BeExactly 76561197983367235
    }
    It "Resolves a group" {
        (Resolve-VanityURL -VanityURL 'SASEliteVirtualRegiment' -UrlType 2).SteamID64 | Should -BeExactly 103582791433675899
    }
}