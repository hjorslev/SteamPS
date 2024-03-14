Describe 'Resolve-VanityURL' {
    BeforeEach {
        function Get-SteamAPIKey {}
        InModuleScope SteamPS {
            Mock -CommandName Get-SteamAPIKey -MockWith {
                Write-Output -InputObject $env:STEAMWEBAPI
            }
        }
    }
    It "Resolves an individual profile" {
        (Resolve-VanityURL -VanityURL 'hjorslev').SteamID64 | Should -BeExactly 76561197983367235
    }
    It "Resolves a group" {
        (Resolve-VanityURL -VanityURL 'SASEliteVirtualRegiment' -UrlType 2).SteamID64 | Should -BeExactly 103582791433675899
    }
}
