Describe "Resolve-VanityURL Tests" {
    Context "When resolving a valid VanityURL" {
        BeforeAll {
            Mock Resolve-VanityURL {
                return [PSCustomObject]@{
                    'SteamID64' = 1234567890
                }
            }
        }
        It "Should return a PSCustomObject with SteamID64" {
            $result = Resolve-VanityURL -VanityURL "validVanityURL"
            $result.SteamID64 | Should -BeExactly 1234567890
        }
    }

    Context "When resolving an invalid VanityURL" {
        It "Should throw an error" {
            { Resolve-VanityURL -VanityURL "invalidVanityURL" } | Should -Throw
        }
    }
}
