library(tidyverse)
library(lubridate)

cbb <- bind_rows(read_rds("cbb_2017.rds"), read_rds("cbb_2018.rds")) %>%
  mutate(league = "cbb")
cfb <- bind_rows(read_rds("cfb_2017.rds"), read_rds("cfb_2018.rds")) %>%
  mutate(league = "cfb")
mlb <- bind_rows(read_rds("mlb_2017.rds"), read_rds("mlb_2018.rds")) %>%
  mutate(league = "mlb")
nba <- read_rds("nba_2017_18.rds") %>% mutate(league = "nba")
nfl <- bind_rows(read_rds("nfl_2016.rds"),
                 read_rds("nfl_2017.rds"),
                 read_rds("nfl_2018.rds")) %>%
  select(-week) %>% mutate(league = "nfl")
nhl <- read_rds("nhl_2017_18.rds") %>% mutate(league = "nhl")

bind_rows(cbb, cfb, mlb, nba, nfl, nhl) %>%
  select(date, league) %>%
  count(date, league) %>%
  complete(date = full_seq(c(ymd(20160701), ymd(20190301)), 1),
           league, fill = list(n = 0)) %>%
  ggplot(aes(date, n, color = league)) +
    geom_line() +
    facet_grid(rows = vars(league), scales = "free")
