#' Get ESPN's WNBA game data (play-by-play, team and player box)
#' @author Saiem Gilani
#' @param game_id Game ID
#' @keywords WNBA Game
#' @importFrom rlang .data
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @import rvest
#' @export
#' @examples
#' espn_wnba_game_all(game_id = 401244185)

espn_wnba_game_all <- function(game_id){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)

  play_base_url <- "http://cdn.espn.com/wnba/playbyplay?render=false&userab=1&xhr=1&"

  ## Inputs
  ## game_id
  full_url <- paste0(play_base_url,
                     "gameId=", game_id)
  res <- httr::RETRY(
    "GET", full_url
  )
  
  # Check the result
  check_status(res)
  resp <- res %>%
    httr::content(as = "text", encoding = "UTF-8") 
  raw_play_df <- jsonlite::fromJSON(resp)[["gamepackageJSON"]]
  raw_play_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_play_df),flatten=TRUE)

  #---- Play-by-Play ------
  plays <- raw_play_df[["plays"]] %>%
    tidyr::unnest_wider(unlist(.data$participants, use.names=FALSE))
  suppressWarnings(
    aths <- plays %>%
      dplyr::group_by(.data$id) %>%
      dplyr::select(.data$id, .data$athlete.id) %>%
      tidyr::unnest_wider(unlist(.data$athlete.id, use.names=FALSE),names_sep = ".")
  )
  names(aths)[1]<-c("play.id")
  plays_df <- dplyr::bind_cols(plays, aths) %>%
    select(-.data$athlete.id)
  #---- Team Box ------
  teams_box_score_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_play_df[["boxscore"]][["teams"]]),flatten=TRUE)
  teams_box_score_df_2 <- teams_box_score_df[[1]][[2]] %>%
    dplyr::select(.data$displayValue, .data$label) %>%
    dplyr::rename(Home = .data$displayValue)
  teams_box_score_df_1 <- teams_box_score_df[[1]][[1]] %>%
    dplyr::select(.data$displayValue) %>%
    dplyr::rename(Away = .data$displayValue)

  team_box_score = dplyr::bind_cols(teams_box_score_df_2, teams_box_score_df_1)
  tm <- c(teams_box_score_df[2,"team.shortDisplayName"], "Team", teams_box_score_df[1,"team.shortDisplayName"])
  names(tm) <- c("Home","label","Away")
  team_box_score = dplyr::bind_rows(tm, team_box_score)
  #---- Player Box ------
  players_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_play_df[["boxscore"]][["players"]]), flatten=TRUE) %>%
    tidyr::unnest(.data$statistics) %>%
    tidyr::unnest(.data$athletes)
  stat_cols <- players_df$names[[1]]
  stats <- players_df$stats

  stats_df <- as.data.frame(do.call(rbind,stats))
  colnames(stats_df) <- stat_cols

  players_df <- players_df %>%
    dplyr::filter(!.data$didNotPlay) %>%
    dplyr::select(.data$starter,.data$ejected, .data$didNotPlay,.data$active,
                  .data$athlete.displayName,.data$athlete.jersey,
                  .data$athlete.id,.data$athlete.shortName,
                  .data$athlete.position.name,
                  .data$athlete.position.abbreviation,.data$team.shortDisplayName,
                  .data$team.name,.data$team.logo,.data$team.id,.data$team.abbreviation,
                  .data$team.color,.data$team.alternateColor
    )

  player_box <- dplyr::bind_cols(stats_df,players_df) %>%
    dplyr::select(.data$athlete.displayName,.data$team.shortDisplayName, tidyr::everything())
  plays_df <- plays_df %>% 
    janitor::clean_names()
  team_box_score <- team_box_score %>% 
    janitor::clean_names()
  player_box <- player_box %>% 
    janitor::clean_names() %>% 
    dplyr::rename(
      '+/-'=.data$x,
      fg3 = .data$x3pt
    )
  pbp <- c(list(plays_df), list(team_box_score),list(player_box))
  names(pbp) <- c("Plays","Team","Player")
  return(pbp)
}

#' Get ESPN's WNBA play by play data
#' @author Saiem Gilani
#' @param game_id Game ID
#' @keywords WNBA PBP
#' @importFrom rlang .data
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @import rvest
#' @export
#' @examples
#' espn_wnba_pbp(game_id = 401244185)
espn_wnba_pbp <- function(game_id){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)

  play_base_url <- "http://cdn.espn.com/wnba/playbyplay?render=false&userab=1&xhr=1&"

  ## Inputs
  ## game_id
  full_url <- paste0(play_base_url,
                     "gameId=", game_id)
  res <- httr::RETRY(
    "GET", full_url
  )
  
  # Check the result
  check_status(res)
  resp <- res %>%
    httr::content(as = "text", encoding = "UTF-8") 
  raw_play_df <- jsonlite::fromJSON(resp)[["gamepackageJSON"]]
  raw_play_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_play_df),flatten=TRUE)
  #---- Play-by-Play ------
  plays <- raw_play_df[["plays"]] %>%
    tidyr::unnest_wider(unlist(.data$participants, use.names=FALSE))
  suppressWarnings(
    aths <- plays %>%
      dplyr::group_by(.data$id) %>%
      dplyr::select(.data$id, .data$athlete.id) %>%
      tidyr::unnest_wider(unlist(.data$athlete.id, use.names=FALSE),names_sep = ".")
  )
  names(aths)[1]<-c("play.id")
  plays_df <- dplyr::bind_cols(plays, aths) %>%
    select(-.data$athlete.id)

  plays_df <- plays_df %>% 
    janitor::clean_names()
  return(plays_df)
}
#' Get ESPN's WNBA team box data
#' @author Saiem Gilani
#' @param game_id Game ID
#' @keywords WNBA Team Box
#' @importFrom rlang .data
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @import rvest
#' @export
#' @examples
#' espn_wnba_team_box(game_id = 401244185)
espn_wnba_team_box <- function(game_id){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  play_base_url <- "http://cdn.espn.com/wnba/playbyplay?render=false&userab=1&xhr=1&"

  ## Inputs
  ## game_id
  full_url <- paste0(play_base_url,
                     "gameId=", game_id)
  res <- httr::RETRY(
    "GET", full_url
  )
  
  # Check the result
  check_status(res)
  resp <- res %>%
    httr::content(as = "text", encoding = "UTF-8") 
  raw_play_df <- jsonlite::fromJSON(resp)[["gamepackageJSON"]]
  raw_play_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_play_df),flatten=TRUE)
  #---- Team Box ------
  teams_box_score_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_play_df[["boxscore"]][["teams"]]),flatten=TRUE)
  teams_box_score_df_2 <- teams_box_score_df[[1]][[2]] %>%
    dplyr::select(.data$displayValue, .data$label) %>%
    dplyr::rename(Home = .data$displayValue)
  teams_box_score_df_1 <- teams_box_score_df[[1]][[1]] %>%
    dplyr::select(.data$displayValue) %>%
    dplyr::rename(Away = .data$displayValue)

  team_box_score = dplyr::bind_cols(teams_box_score_df_2, teams_box_score_df_1)
  tm <- c(teams_box_score_df[2,"team.shortDisplayName"], "Team", teams_box_score_df[1,"team.shortDisplayName"])
  names(tm) <- c("Home","label","Away")
  team_box_score = dplyr::bind_rows(tm, team_box_score)
  team_box_score <- team_box_score %>% 
    janitor::clean_names()
  return(team_box_score)
}
#' Get ESPN's WNBA player box data
#' @author Saiem Gilani
#' @param game_id Game ID
#' @keywords WNBA Player Box
#' @importFrom rlang .data
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows
#' @importFrom tidyr unnest unnest_wider everything
#' @import rvest
#' @export
#' @examples
#' espn_wnba_player_box(game_id = 401244185)
espn_wnba_player_box <- function(game_id){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  play_base_url <- "http://cdn.espn.com/wnba/playbyplay?render=false&userab=1&xhr=1&"

  ## Inputs
  ## game_id
  full_url <- paste0(play_base_url,
                     "gameId=", game_id)
  res <- httr::RETRY(
    "GET", full_url
  )
  
  # Check the result
  check_status(res)
  resp <- res %>%
    httr::content(as = "text", encoding = "UTF-8") 
  
  raw_play_df <- jsonlite::fromJSON(resp)[["gamepackageJSON"]]
  raw_play_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_play_df),flatten=TRUE)
  #---- Player Box ------
  players_df <- jsonlite::fromJSON(jsonlite::toJSON(raw_play_df[["boxscore"]][["players"]]), flatten=TRUE) %>%
    tidyr::unnest(.data$statistics) %>%
    tidyr::unnest(.data$athletes)
  stat_cols <- players_df$names[[1]]
  stats <- players_df$stats

  stats_df <- as.data.frame(do.call(rbind,stats))
  colnames(stats_df) <- stat_cols

  players_df <- players_df %>%
    dplyr::filter(!.data$didNotPlay) %>%
    dplyr::select(.data$starter,.data$ejected, .data$didNotPlay,.data$active,
                  .data$athlete.displayName,.data$athlete.jersey,
                  .data$athlete.id,.data$athlete.shortName,.data$athlete.position.name,
                  .data$athlete.position.abbreviation,.data$team.shortDisplayName,
                  .data$team.name, .data$team.logo,.data$team.id,.data$team.abbreviation,
                  .data$team.color,.data$team.alternateColor
    )

  player_box <- dplyr::bind_cols(stats_df,players_df) %>%
    dplyr::select(.data$athlete.displayName,.data$team.shortDisplayName, tidyr::everything())
  player_box <- player_box %>% 
    janitor::clean_names() %>% 
    dplyr::rename(
      '+/-'=.data$x,
      fg3 = .data$x3pt
    )
  
  return(player_box)
}

#' Get ESPN's WNBA team names and ids
#' @author Saiem Gilani
#' @keywords WNBA Teams
#' @importFrom rlang .data
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr filter select rename bind_cols bind_rows row_number group_by mutate as_tibble ungroup
#' @importFrom tidyr unnest unnest_wider everything pivot_wider
#' @import rvest
#' @export
#' @examples
#' espn_wnba_teams()

espn_wnba_teams <- function(){
  options(stringsAsFactors = FALSE)
  options(scipen = 999)
  play_base_url <- "http://site.api.espn.com/apis/site/v2/sports/basketball/wnba/teams?limit=1000"
  res <- httr::RETRY(
    "GET", play_base_url
  )
  
  # Check the result
  check_status(res)
  resp <- res %>%
    httr::content(as = "text", encoding = "UTF-8") 
  
  ## Inputs
  ## game_id
  leagues <- jsonlite::fromJSON(resp)[["sports"]][["leagues"]][[1]][['teams']][[1]][['team']] %>%
    dplyr::group_by(.data$id) %>%
    tidyr::unnest_wider(unlist(.data$logos, use.names=FALSE),names_sep = "_") %>%
    tidyr::unnest_wider(.data$logos_href,names_sep = "_") %>%
    dplyr::select(-.data$logos_width,-.data$logos_height,
                  -.data$logos_alt, -.data$logos_rel) %>%
    dplyr::ungroup()
  
  wnba_teams <- leagues %>%
    dplyr::select(.data$id, 
                  .data$location, 
                  .data$name, 
                  .data$displayName, 
                  .data$shortDisplayName, 
                  .data$abbreviation, 
                  .data$color, 
                  .data$alternateColor, 
                  .data$logos_href_1, 
                  .data$logos_href_2) %>%
    dplyr::rename(
      logo = .data$logos_href_1,
      logo_dark = .data$logos_href_2,
      mascot = .data$name,
      team = .data$location,
      team_id = .data$id,
      alternate_color = .data$alternateColor,
      short_name = .data$shortDisplayName,
      display_name = .data$displayName
    )
  
  return(wnba_teams)
}


#' Get WNBA schedule for a specific year/date from ESPN's API
#'
#' @param season Either numeric or character
#' @author Thomas Mock, you a genius for this one.
#' @return Returns a tibble
#' @import utils
#' @import rvest
#' @importFrom dplyr select rename any_of mutate
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr unnest_wider unchop hoist
#' @importFrom glue glue
#' @import rvest
#' @export
#' @examples
#' # Get schedule from 2020 season (returns 1000 results, max allowable.)
#' # Must iterate through dates to get full year's schedule, as below:
#' espn_wnba_scoreboard (season = 2020)
#' # Get schedule from date 2020-08-29
#' espn_wnba_scoreboard (season = "20200829")

espn_wnba_scoreboard <- function(season){

  # message(glue::glue("Returning data for {season}!"))

  max_year <- substr(Sys.Date(), 1,4)

  if(!(as.integer(substr(season, 1, 4)) %in% c(2001:max_year))){
    message(paste("Error: Season must be between 2001 and", max_year))
  }

  # year > 2000
  season <- as.character(season)

  season_dates <- season

  schedule_api <- glue::glue("http://site.api.espn.com/apis/site/v2/sports/basketball/wnba/scoreboard?limit=1000&dates={season_dates}")
  res <- httr::RETRY(
    "GET", schedule_api
  )
  
  # Check the result
  check_status(res)
  raw_sched <- res %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyDataFrame = FALSE, simplifyVector = FALSE, simplifyMatrix = FALSE)
  
  wnba_data <- raw_sched[["events"]] %>%
    tibble::tibble(data = .data$.) %>%
    tidyr::unnest_wider(.data$data) %>%
    tidyr::unchop(.data$competitions) %>%
    dplyr::select(-.data$id, -.data$uid, -.data$date, -.data$status) %>%
    tidyr::unnest_wider(.data$competitions) %>%
    dplyr::rename(matchup = .data$name, matchup_short = .data$shortName, game_id = .data$id, game_uid = .data$uid, game_date = .data$date) %>%
    tidyr::hoist(.data$status,
                 status_name = list("type", "name")) %>%
    dplyr::select(!dplyr::any_of(c("timeValid", "neutralSite", "conferenceCompetition","recent", "venue", "type"))) %>%
    tidyr::unnest_wider(.data$season) %>%
    dplyr::rename(season = .data$year) %>%
    dplyr::select(-dplyr::any_of("status")) %>%
    tidyr::hoist(
      .data$competitors,
      home_team_name = list(1, "team", "name"),
      home_team_logo = list(1, "team", "logo"),
      home_team_abb = list(1, "team", "abbreviation"),
      home_team_id = list(1, "team", "id"),
      home_team_location = list(1, "team", "location"),
      home_team_full = list(1, "team", "displayName"),
      home_team_color = list(1, "team", "color"),
      home_score = list(1, "score"),
      home_win = list(1, "winner"),
      home_record = list(1, "records", 1, "summary"),
      # away team
      away_team_name = list(2, "team", "name"),
      away_team_logo = list(2, "team", "logo"),
      away_team_abb = list(2, "team", "abbreviation"),
      away_team_id = list(2, "team", "id"),
      away_team_location = list(2, "team", "location"),
      away_team_full = list(2, "team", "displayName"),
      away_team_color = list(2, "team", "color"),
      away_score = list(2, "score"),
      away_win = list(2, "winner"),
      away_record = list(2, "records", 1, "summary"),
    ) %>%
    dplyr::mutate(home_win = as.integer(.data$home_win),
                  away_win = as.integer(.data$away_win),
                  home_score = as.integer(.data$home_score),
                  away_score = as.integer(.data$away_score))

  if("leaders" %in% names(wnba_data)){
    schedule_out <- wnba_data %>%
      tidyr::hoist(
        .data$leaders,
        # points
        points_leader_yards = list(1, "leaders", 1, "value"),
        points_leader_stat = list(1, "leaders", 1, "displayValue"),
        points_leader_name = list(1, "leaders", 1, "athlete", "displayName"),
        points_leader_shortname = list(1, "leaders", 1, "athlete", "shortName"),
        points_leader_headshot = list(1, "leaders", 1, "athlete", "headshot"),
        points_leader_team_id = list(1, "leaders", 1, "team", "id"),
        points_leader_pos = list(1, "leaders", 1, "athlete", "position", "abbreviation"),
        # rebounds
        rebounds_leader_yards = list(2, "leaders", 1, "value"),
        rebounds_leader_stat = list(2, "leaders", 1, "displayValue"),
        rebounds_leader_name = list(2, "leaders", 1, "athlete", "displayName"),
        rebounds_leader_shortname = list(2, "leaders", 1, "athlete", "shortName"),
        rebounds_leader_headshot = list(2, "leaders", 1, "athlete", "headshot"),
        rebounds_leader_team_id = list(2, "leaders", 1, "team", "id"),
        rebounds_leader_pos = list(2, "leaders", 1, "athlete", "position", "abbreviation"),
        # assists
        assists_leader_yards = list(3, "leaders", 1, "value"),
        assists_leader_stat = list(3, "leaders", 1, "displayValue"),
        assists_leader_name = list(3, "leaders", 1, "athlete", "displayName"),
        assists_leader_shortname = list(3, "leaders", 1, "athlete", "shortName"),
        assists_leader_headshot = list(3, "leaders", 1, "athlete", "headshot"),
        assists_leader_team_id = list(3, "leaders", 1, "team", "id"),
        assists_leader_pos = list(3, "leaders", 1, "athlete", "position", "abbreviation"),
      )

    if("broadcasts" %in% names(schedule_out)) {
      schedule_out %>%
        tidyr::hoist(
          .data$broadcasts,
          broadcast_market = list(1, "market"),
          broadcast_name = list(1, "names", 1)
        ) %>%
        dplyr::select(!where(is.list)) %>% 
          janitor::clean_names()    
    } else {
      schedule_out %>% 
        janitor::clean_names()
    }
  } else {
    wnba_data %>% dplyr::select(!where(is.list)) %>% 
      janitor::clean_names()
  }

}
#' Get ESPN WNBA Standings
#'
#' @author Geoff Hutchinson
#' @param year Either numeric or character (YYYY)
#' @keywords WNBA Standings
#' @importFrom rlang .data
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom dplyr select rename
#' @importFrom tidyr pivot_wider
#' @importFrom data.table rbindlist
#' @export
#' @examples
#' \dontrun{
#' espn_wnba_standings(year = 2021)
#' }
espn_wnba_standings <- function(year){
  
  standings_url <- "https://site.web.api.espn.com/apis/v2/sports/basketball/wnba/standings?region=us&lang=en&contentorigin=espn&type=0&level=1&sort=winpercent%3Adesc%2Cwins%3Adesc%2Cgamesbehind%3Aasc&"
  
  ## Inputs
  ## year
  full_url <- paste0(standings_url,
                     "season=", year)
  
  res <- httr::RETRY("GET", full_url)
  
  # Check the result
  check_status(res)
  tryCatch(
    expr = {
      resp <- res %>%
        httr::content(as = "text", encoding = "UTF-8")
      
      raw_standings <- jsonlite::fromJSON(resp)[["standings"]]
      
      #Create a dataframe of all NBA teams by extracting from the raw_standings file
      
      teams <- raw_standings[["entries"]][["team"]]
      
      teams <- teams %>%
        dplyr::select(.data$id, .data$displayName) %>%
        dplyr::rename(team_id = .data$id,
                      team = .data$displayName)
      
      #creating a dataframe of the WNBA raw standings table from ESPN
      
      standings_df <- raw_standings[["entries"]][["stats"]]
      
      standings_data <- data.table::rbindlist(standings_df, fill = TRUE, idcol = T)
      
      #Use the following code to replace NA's in the dataframe with the correct corresponding values and removing all unnecessary columns
      
      standings_data$value <- ifelse(is.na(standings_data$value) & !is.na(standings_data$summary), standings_data$summary, standings_data$value)
      
      standings_data <- standings_data %>%
        dplyr::select(.data$.id, .data$type, .data$value)
      
      #Use pivot_wider to transpose the dataframe so that we now have a standings row for each team
      
      standings_data <- standings_data %>%
        tidyr::pivot_wider(names_from = .data$type, values_from = .data$value)
      
      standings_data <- standings_data %>%
        dplyr::select(-.data$.id)
      
      #joining the 2 dataframes together to create a standings table
      
      standings <- cbind(teams, standings_data)
    },
    error = function(e) {
      message(glue::glue("{Sys.time()}: Invalid arguments or no standings data available!"))
    },
    warning = function(w) {
    },
    finally = {
    }
    
  )
  return(standings)
}

#' @import utils
utils::globalVariables(c("where"))
