library(tidyverse)
library(rvest)
library(lubridate)

scrape_nfl_year <- function(year) {
  str_glue("https://www.pro-football-reference.com/years/",
           year, "/games.htm") %>%
    read_html %>%
    html_nodes("tbody tr:not(.thead)") %>%
    map_dfr(function(row) {
      raw_date <- row %>%
        html_node("[data-stat=\"game_date\"]") %>%
        html_text
      if (raw_date == "Playoffs") return(list())
      date <- raw_date %>%
        str_glue(", ", year) %>%
        mdy
      if (month(date, label = FALSE) < 9) {
        year(date) <- year + 1
      }
      list(week = row %>% html_node("th") %>% html_text,
           date = date,
           kickoff = row %>%
             html_node("[data-stat=\"gametime\"]") %>%
             html_text,
           winner = row %>%
             html_node("[data-stat=\"winner\"]") %>%
             html_text,
           loser = row %>%
             html_node("[data-stat=\"loser\"]") %>%
             html_text,
           box_url = row %>%
             html_node("[data-stat=\"boxscore_word\"] a") %>%
             html_attr("href"))
    }) %>% write_rds(str_glue("nfl_", year, ".rds"))
}

scrape_nfl_year(2016)
# scrape_nfl_year(2017)
