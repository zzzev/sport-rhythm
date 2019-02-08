library(tidyverse)
library(rvest)
library(lubridate)

url <- "https://www.pro-football-reference.com/years/2018/games.htm"
raw <- read_html(url)
raw %>%
  html_nodes("tbody tr:not(.thead)") %>%
  map_dfr(function(row) {
    raw_date <- row %>%
      html_node("[data-stat=\"game_date\"]") %>%
      html_text
    if (raw_date == "Playoffs") return(list())
    date <- raw_date %>%
      str_glue(", 2018") %>%
      mdy
    if (month(date, label = FALSE) < 9) {
      year(date) <- 2019
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
  }) %>% write_rds("nfl_2018_19.rds")
