library(tidyverse)
library(lubridate)

cbb <- read_rds("cbb_2017_2018.rds") %>% unnest %>% mutate(league = "cbb")
cfb <- read_rds("cfb_2018_19.rds") %>% mutate(league = "cfb")
mlb <- read_rds("mlb_2018.rds") %>% mutate(league = "mlb")
nba <- read_rds("nba_2017_18.rds") %>% mutate(league = "nba")
nfl <- read_rds("nfl_2018_19.rds") %>% select(-week) %>% mutate(league = "nfl")
nhl <- read_rds("nhl_2017_18.rds") %>% mutate(league = "nhl")

bind_rows(cbb, cfb, mlb, nba, nfl, nhl) %>%
  select(date, league) %>%
  count(date, league) %>%
  complete(date, league, fill = list(n = 0)) %>%
  ggplot(aes(date, n, color = league)) +
    geom_line() +
    facet_grid(rows = vars(league), scales = "free")
