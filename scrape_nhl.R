library(tidyverse)
library(lubridate)
library(rvest)

scrape_nhl_year <- function(year) {
  str_glue("https://www.hockey-reference.com/leagues/NHL_",
           year, "_games.html") %>%
    read_html %>%
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
    }) %>% write_rds(str_glue("nhl_", year, ".rds"))
}

scrape_nhl_year(2017)
