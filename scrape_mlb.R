library(tidyverse)
library(rvest)
library(lubridate)

scrape_mlb_year <- function(year) {
  str_glue("https://www.baseball-reference.com/leagues/MLB/",
           year, "-schedule.shtml") %>%
    read_html %>%
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
    filter(!is.na(home)) %>%
    write_rds(str_glue("data/mlb_", year, ".rds"))

}

scrape_mlb_year(2017)
