library(tidyverse)
library(lubridate)
library(rvest)

start <- ymd(20171110)
end <- ymd(20180402)

date <- start
start:end %>%
  as_date %>%
  tibble %>%
  rename(date = ".") %>%
  mutate(games = map(date, function(date) {
    print(date)
    str_glue("https://www.sports-reference.com/cbb/boxscores/index.cgi",
             "?month=", month(date),
             "&day=", day(date),
             "&year=", year(date)) %>%
      read_html(url) %>%
      html_nodes(".game_summary") %>%
      map_dfr(function(game) {
        loser <- html_nodes(game, ".loser td")
        winner <- html_nodes(game, ".winner td")
        list(loser = html_text(loser[[1]]),
             loser_pts = html_text(loser[[2]]),
             winner = html_text(winner[[1]]),
             winner_pts = html_text(winner[[2]]),
             box_url = html_node(game, ".gamelink a") %>% html_attr("href"))
      })
  })) %>% write_rds("cbb_2017_2018.rds")

