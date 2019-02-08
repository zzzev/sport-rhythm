library(tidyverse)
library(rvest)
library(lubridate)

scrape_cfb_year <- function(year) {
  str_glue("https://www.sports-reference.com/cfb/years/",
           year, "-schedule.html") %>%
    read_html %>%
    html_nodes("tbody tr:not(.thead)") %>%
    map_dfr(function(row)
      list(week = html_node(row, "[data-stat=\"week_number\"]") %>%
             html_text %>% parse_number,
           date = html_node(row, "[data-stat=\"date_game\"]") %>%
             html_text %>% mdy,
           time = html_node(row, "[data-stat=\"time_game\"]") %>% html_text,
           winner = html_node(row, "[data-stat=\"winner_school_name\"]") %>%
             html_text,
           winner_points = html_node(row, "[data-stat=\"winner_points\"]") %>%
             html_text %>% parse_number,
           loser = html_node(row, "[data-stat=\"loser_school_name\"]") %>%
             html_text,
           loser_points = html_node(row, "[data-stat=\"loser_points\"]") %>%
             html_text %>% parse_number,
           notes = html_node(row, "[data-stat=\"notes\"]") %>% html_text)) %>%
    write_rds(str_glue("cfb_", year, ".rds"))
}

scrape_cfb_year(2017)
scrape_cfb_year(2018)
