library(tidyverse)
library(rvest)
library(lubridate)

scrape_nba_year <- function(year) {
  str_glue("https://www.basketball-reference.com/leagues/NBA_",
           year, "_games.html") %>%
    read_html %>%
    html_nodes(".filter a") %>%
    html_attr("href") %>%
    map(~ read_html(str_glue("https://www.basketball-reference.com", .x))) %>%
    map_dfr(function(month_html) month_html %>%
      html_nodes("tbody tr:not(.thead)") %>%
      map_dfr(function(row) {
        list(date = row %>% html_node("[data-stat=\"date_game\"]") %>%
               html_text %>% mdy,
             time = row %>% html_node("[data-stat=\"game_start_time\"]") %>%
               html_text,
             visitor = row %>% html_node("[data-stat=\"visitor_team_name\"]") %>%
               html_text,
             visitor_points = row %>% html_node("[data-stat=\"visitor_pts\"]") %>%
               html_text %>% parse_number,
             home = row %>% html_node("[data-stat=\"home_team_name\"]") %>%
               html_text,
             home_points = row %>% html_node("[data-stat=\"home_pts\"]") %>%
               html_text %>% parse_number,
             box_url = row %>% html_node("[data-stat=\"box_score_text\"] a") %>%
               html_attr("href"),
             ots = row %>% html_node("[data-stat=\"ots\"]") %>%
               html_text,
             attendance = row %>% html_node("[data-stat=\"attendance\"]") %>%
               html_text %>% parse_number
        )
      })) %>% write_rds(str_glue("nba_", year, ".rds"))
}

# scrape_nba_year(2017)
# scrape_nba_year(2018)
scrape_nba_year(2019)
