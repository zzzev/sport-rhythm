library(tidyverse)
library(rvest)
library(lubridate)

url <- "https://www.sports-reference.com/cfb/years/2018-schedule.html"
raw <- read_html(url)
raw %>%
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
  write_rds("cfb_2018_19.rds")
