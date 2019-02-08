library(tidyverse)
library(rvest)
library(lubridate)

url <- "https://www.baseball-reference.com/leagues/MLB/2018-schedule.shtml"
raw <- read_html(url)
mlb_2018 <- raw %>%
  html_nodes(".game , h3") %>%
  map_dfr(function(el) {
    type <- html_name(el)
    if (type == "h3") {
      return(list(date = html_text(el) %>% mdy))
    } else if (type == "p") {
      as <- el %>% html_nodes("a")
      return(list(away = html_text(as[[1]]),
                  home = html_text(as[[2]]),
                  box_url = html_attr(as[[3]], "href")))
    }
  }) %>%
  fill(date) %>%
  filter(!is.na(home))
mlb_2018 %>% write_rds("mlb_2018.rds")
