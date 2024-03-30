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
            $SteamNews = Get-SteamNews -AppID 440

            $SteamNews[0].GID | Should -Be 123
            $SteamNews[0].Title | Should -Be "Test News"
            $SteamNews[0].Url | Should -Be "https://example.com"
            $SteamNews[0].IsExternalUrl | Should -Be $false
            $SteamNews[0].Author | Should -Be "Test Author"
            $SteamNews[0].Contents | Should -Be "This is a test news content."
            $SteamNews[0].FeedLabel | Should -Be "Test Feed"
            $SteamNews[0].Date | Should -Be "2024-02-02 18:54:00"
            $SteamNews[0].FeedName | Should -Be "Test Feed"
            $SteamNews[0].FeedType | Should -Be "Test"
            $SteamNews[0].AppID | Should -Be 440
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
