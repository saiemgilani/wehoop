
cols <- c("athlete_display_name", "team_short_display_name", 
          "min", "fg", "fg3", "ft", "oreb", "dreb", "reb", 
          "ast", "stl", "blk", "to", "pf", "pts", 
          "starter", "ejected", "did_not_play", "active", 
          "athlete_jersey", "athlete_id", "athlete_short_name", 
          "athlete_headshot_href", "athlete_position_name", 
          "athlete_position_abbreviation", "team_name", "team_logo", 
          "team_id", "team_abbreviation", "team_color", "team_alternate_color")

test_that("ESPN - WBB Player Box", {
  skip_on_cran()
  x <- espn_wbb_player_box(game_id = 401276115)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})