
# wehoop <a href='http://saiemgilani.github.io/wehoop'><img src="man/figures/logo.png" align="right" height="139"/></a>

<!-- badges: start -->

![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![R-CMD-check](https://github.com/saiemgilani/wehoop/workflows/R-CMD-check/badge.svg)
[![Twitter
Follow](https://img.shields.io/twitter/follow/saiemgilani?style=social)](https://twitter.com/saiemgilani)
<!-- badges: end -->

`wehoop` is an R package for working with women’s college and
professional basketball data. A scraping and aggregating interface for
ESPN’s women’s college basketball and WNBA statistics,
[espn.com](https://espn.com). It provides users with the capability to
access the API’s game play-by-plays, box scores, standings and results
to analyze the data for themselves.

#### v0.2.0: Support for ESPN’s WNBA game data

See the following six functions:

  - [`wehoop::wnba_espn_game_all()`](https://saiemgilani.github.io/wehoop/reference/wnba_espn_game_all.html)
  - [`wehoop::wnba_espn_pbp()`](https://saiemgilani.github.io/wehoop/reference/wnba_espn_pbp.html)
  - [`wehoop::wnba_espn_team_box()`](https://saiemgilani.github.io/wehoop/reference/wnba_espn_team_box.html)
  - [`wehoop::wnba_espn_player_box()`](https://saiemgilani.github.io/wehoop/reference/wnba_espn_player_box.html)
  - [`wehoop::wnba_espn_teams()`](https://saiemgilani.github.io/wehoop/reference/wnba_espn_teams.html)
  - [`wehoop::wnba_espn_scoreboard()`](https://saiemgilani.github.io/wehoop/reference/wnba_espn_scoreboard.html)

#### v0.1.0: Support for ESPN’s women’s college basketball game data and NCAA NET Rankings

See the following eight functions:

  - [`wehoop::wbb_espn_game_all()`](https://saiemgilani.github.io/wehoop/reference/wbb_espn_game_all.html)

  - [`wehoop::wbb_espn_pbp()`](https://saiemgilani.github.io/wehoop/reference/wbb_espn_pbp.html)

  - [`wehoop::wbb_espn_team_box()`](https://saiemgilani.github.io/wehoop/reference/wbb_espn_team_box.html)

  - [`wehoop::wbb_espn_player_box()`](https://saiemgilani.github.io/wehoop/reference/wbb_espn_player_box.html)

  - [`wehoop::wbb_espn_teams()`](https://saiemgilani.github.io/wehoop/reference/wbb_espn_teams.html)

  - [`wehoop::wbb_espn_conferences()`](https://saiemgilani.github.io/wehoop/reference/wbb_espn_conferences.html)

  - [`wehoop::wbb_espn_scoreboard()`](https://saiemgilani.github.io/wehoop/reference/wbb_espn_scoreboard.html)

  - [`wehoop::wbb_ncaa_NET_rankings()`](https://saiemgilani.github.io/wehoop/reference/wbb_ncaa_NET_rankings.html)

  - [`wehoop::wbb_rankings()`](https://saiemgilani.github.io/wehoop/reference/wbb_rankings.html)

## Installation

You can install `wehoop` from
[GitHub](https://github.com/saiemgilani/wehoop) with:

``` r
# Install via devtools package using the following:
devtools::install_github(repo = "saiemgilani/wehoop")
```

## Documentation

For more information on the package and function reference, please see
the `wehoop` [documentation](https://saiemgilani.github.io/wehoop/).

## Code of Conduct

Please note that the `wehoop` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
