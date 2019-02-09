library(tidyverse)
library(lubridate)
library(rvest)

# year is the year of the tournament
scrape_cbb_year <- function(year) {
  start <- ymd((year - 1) * 10000 + 1101)
  end <- ymd(year * 10000 + 410)
  start:end %>%
    as_date %>%
    tibble %>%
    rename(date = ".") %>%
    mutate(games = map(date, function(date) {
      print(date)
      url <- str_glue("https://www.sports-reference.com/cbb/boxscores/index.cgi",
               "?month=", month(date),
               "&day=", day(date),
               "&year=", year(date))
      url %>%
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
    })) %>%
    unnest %>%
    write_rds(str_glue("cbb_", year, ".rds"))
}

# scrape_cbb_year(2017)
# scrape_cbb_year(2018)
scrape_cbb_year(2019)

