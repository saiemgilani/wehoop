
cols <- c("shooting_play", "sequence_number", "home_score", "scoring_play",
          "away_score", "id", "text", "score_value", "period_display_value", "period_number", 
          "coordinate_x", "coordinate_y", "clock_display_value", 
          "team_id", "type_id", "type_text", "play_id", "athlete_id_1", "athlete_id_2")

test_that("ESPN - WBB Play-by-Play", {
  skip_on_cran()
  x <- espn_wbb_pbp(game_id = 401276115)
  expect_equal(colnames(x), cols)
  expect_s3_class(x, "data.frame")
})