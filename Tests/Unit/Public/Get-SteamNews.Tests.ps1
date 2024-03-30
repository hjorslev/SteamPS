Describe "Get-SteamNews Tests" {
    Context "When providing valid input" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return '{
                    "appnews": {
                        "newsitems": [
                            {
                                "gid": 123,
                                "title": "Test News",
                                "url": "https://example.com",
                                "is_external_url": false,
                                "author": "Test Author",
                                "contents": "This is a test news content.",
                                "feedlabel": "Test Feed",
                                "date": "1706900040",
                                "feedname": "Test Feed",
                                "feed_type": "Test",
                                "appid": 440
                            }
                        ]
                    }
                }' | ConvertFrom-Json
            }
        }
        It "Should return news items for a given AppID" {
            $result = Get-SteamNews -AppID 440

            $result.Count | Should -Be 1
            $result[0].GID | Should -Be 123
            $result[0].Title | Should -Be "Test News"
            $result[0].Url | Should -Be "https://example.com"
            $result[0].IsExternalUrl | Should -Be $false
            $result[0].Author | Should -Be "Test Author"
            $result[0].Contents | Should -Be "This is a test news content."
            $result[0].FeedLabel | Should -Be "Test Feed"
            $result[0].Date | Should -Be "2024-02-02 18:54:00"
            $result[0].FeedName | Should -Be "Test Feed"
            $result[0].FeedType | Should -Be "Test"
            $result[0].AppID | Should -Be 440
        }
    }

    Context "When no news found for the given AppID" {
        BeforeAll {
            Mock -CommandName Invoke-RestMethod -ModuleName SteamPS -MockWith {
                return $null
            }
        }
        It "Should throw an error" {
            { Get-SteamNews -AppID 123 -ErrorAction Stop } | Should -Throw "No news found for 123."
        }
    }
}
