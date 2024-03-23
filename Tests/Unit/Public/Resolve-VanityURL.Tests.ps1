Describe "Resolve-VanityURL Tests" {
    Context "When resolving a valid VanityURL" {
        BeforeAll {
            Mock Resolve-VanityURL {
                return [PSCustomObject]@{
                    'VanityURL' = 'Toby'
                    'SteamID64' = 1234567890
                }
            }
        }
        It "Should return a PSCustomObject with SteamID64" {
            $result = Resolve-VanityURL -VanityURL "validVanityURL"
            $result.SteamID64 | Should -BeExactly 1234567890
            $result.VanityURL | Should -BeExactly 'Toby'
        }
    }

    Context "When resolving an invalid VanityURL" {
        It "Should throw an error" {
            { Resolve-VanityURL -VanityURL "invalidVanityURL" -ErrorAction Stop } | Should -Throw
        }
    }

    Context "When resolving an invalid, fully qualified VanityURL" {
        It "Should throw an error" {
            { Resolve-VanityURL -VanityURL "https://steamcommunity.com/id/test" } | Should -Throw
        }
    }
}
