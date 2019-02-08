library(tidyverse)
library(lubridate)
library(rvest)

url <- "https://www.hockey-reference.com/leagues/NHL_2018_games.html"
raw <- read_html(url)
nhl <- raw %>%
  html_nodes("tbody tr") %>%
  map_dfr(function(row) {
    list(date = row %>% html_node("[data-stat=\"date_game\"]") %>%
           html_text %>% ymd,
         visitor = row %>% html_node("[data-stat=\"visitor_team_name\"]") %>%
           html_text,
         home = row %>% html_node("[data-stat=\"home_team_name\"]") %>%
           html_text,
         visitor_pts = row %>% html_node("[data-stat=\"visitor_goals\"]") %>%
           html_text %>% parse_number,
         home_pts = row %>% html_node("[data-stat=\"home_goals\"]") %>%
           html_text %>% parse_number,
         ot = row %>% html_node("[data-stat=\"overtimes\"]") %>%
           html_text,
         attendance = row %>% html_node("[data-stat=\"attendance\"]") %>%
           html_text %>% parse_number,
         length = row %>% html_node("[data-stat=\"game_duration\"]") %>%
           html_text)
  }) %>% write_rds("nhl_2017_18.rds")
