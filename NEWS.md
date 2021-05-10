# **wehoop 0.9.0**

### **Loading capabilities added to the package**
- [```wehoop::load_wbb_pbp()```](https://saiemgilani.github.io/wehoop/reference/load_wbb_pbp.html) and [```wehoop::update_wbb_db()```](https://saiemgilani.github.io/wehoop/reference/update_wbb_db.html) functions added
- [```wehoop::load_wnba_pbp()```](https://saiemgilani.github.io/wehoop/reference/load_wnba_pbp.html) and [```wehoop::update_wnba_db()```](https://saiemgilani.github.io/wehoop/reference/update_wnba_db.html) functions added

# **wehoop 0.3.0**

###  **Dependencies**
- ```R``` version 3.5.0 or greater dependency added
- ```purrr``` version 0.3.0 or greater dependency added
- ```rvest``` version 1.0.0 or greater dependency added
- ```progressr``` version 0.6.0 or greater dependency added
- ```usethis``` version 1.6.0 or greater dependency added
- ```xgboost``` version 1.1.0 or greater dependency added
- ```tidyr``` version 1.0.0 or greater dependency added
- ```stringr``` version 1.3.0 or greater dependency added
- ```tibble``` version 3.0.0 or greater dependency added
- ```furrr``` dependency added
- ```future``` dependency added

## **Test coverage**

* Added tests for all ESPN functions

#### **Function Naming Convention Change**

* Similarly, data and metrics sourced from ESPN will begin with `espn_` as opposed to `wbb_` or `wnba_`. 

* Data sourced directly from the NCAA website will start the function with `ncaa_`

# **wehoop 0.2.0**

- Added support for ESPN's play-by-play endpoints with the addition of the following functions:
- ```wehoop::espn_wnba_game_all()``` - a convenience wrapper function around the following three functions (returns the results as a list of three data frames)
- ```wehoop::espn_wnba_team_box()```
- ```wehoop::espn_wnba_player_box()```
- ```wehoop::espn_wnba_pbp()```
- ```wehoop::espn_wnba_teams()``` 
- ```wehoop::espn_wbb_scoreboard()``` 

# **wehoop 0.1.0**

- Added support for ESPN's play-by-play endpoints with the addition of the following functions:
- ```wehoop::espn_wbb_game_all()``` - a convenience wrapper function around the following three functions (returns the results as a list of three data frames)
- ```wehoop::espn_wbb_team_box()```
- ```wehoop::espn_wbb_player_box()```
- ```wehoop::espn_wbb_pbp()```
- ```wehoop::espn_wbb_teams()``` 
- ```wehoop::espn_wbb_conferences()``` 
- ```wehoop::espn_wbb_scoreboard()``` 
- ```wehoop::ncaa_wbb_NET_rankings()``` 
- ```wehoop::espn_wbb_rankings()``` 