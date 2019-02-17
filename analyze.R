library(tidyverse)
library(lubridate)

cbb <- bind_rows(read_rds("data/cbb_2017.rds"),
                 read_rds("data/cbb_2018.rds"),
                 read_rds("data/cbb_2019.rds")) %>%
  mutate(league = "cbb")
cfb <- bind_rows(read_rds("data/cfb_2016.rds"),
                 read_rds("data/cfb_2017.rds"),
                 read_rds("data/cfb_2018.rds")) %>%
  mutate(league = "cfb")
mlb <- bind_rows(read_rds("data/mlb_2017.rds"), read_rds("data/mlb_2018.rds")) %>%
  mutate(league = "mlb")
nba <- bind_rows(read_rds("data/nba_2017.rds"),
                 read_rds("data/nba_2018.rds"),
                 read_rds("data/nba_2019.rds")) %>% mutate(league = "nba")
nfl <- bind_rows(read_rds("data/nfl_2016.rds"),
                 read_rds("data/nfl_2017.rds"),
                 read_rds("data/nfl_2018.rds")) %>%
  select(-week) %>% mutate(league = "nfl")
nhl <- bind_rows(read_rds("data/nhl_2017.rds"),
                 read_rds("data/nhl_2018.rds"),
                 read_rds("data/nhl_2019.rds"))%>% mutate(league = "nhl")

seasons <- tribble(
  ~league, ~season, ~reg_start,    ~reg_end,      ~post_start,   ~post_end,
  "cbb",   2016,    ymd(20161111), ymd(20170305), ymd(20170314), ymd(20170403),
  "cbb",   2017,    ymd(20171110), ymd(20180304), ymd(20180313), ymd(20180402),
  "cbb",   2018,    ymd(20181106), ymd(20190310), NA,            NA,
  "cfb",   2016,    ymd(20160826), ymd(20161210), ymd(20161217), ymd(20170109),
  "cfb",   2017,    ymd(20170826), ymd(20171209), ymd(20171216), ymd(20180108),
  "cfb",   2018,    ymd(20180825), ymd(20181208), ymd(20181215), ymd(20190107),
  "mlb",   2017,    ymd(20170402), ymd(20171001), ymd(20171003), ymd(20171101),
  "mlb",   2018,    ymd(20180329), ymd(20181001), ymd(20181002), ymd(20181028),
  "nba",   2017,    ymd(20161025), ymd(20180412), ymd(20180415), ymd(20180612),
  "nba",   2018,    ymd(20171017), ymd(20180411), ymd(20180414), ymd(20180608),
  "nba",   2019,    ymd(20181016), ymd(20190410), NA,            NA,
  "nfl",   2016,    ymd(20160908), ymd(20170101), ymd(20170107), ymd(20170205),
  "nfl",   2017,    ymd(20170907), ymd(20171231), ymd(20170106), ymd(20180204),
  "nfl",   2018,    ymd(20180906), ymd(20181230), ymd(20190105), ymd(20190205),
  "nhl",   2017,    ymd(20161012), ymd(20170409), ymd(20170412), ymd(20170611),
  "nhl",   2018,    ymd(20171004), ymd(20180408), ymd(20180411), ymd(20180607),
  "nhl",   2019,    ymd(20181003), ymd(20190406), NA,           NA
)

bind_rows(cbb, cfb, mlb, nba, nfl, nhl) %>%
  select(date, league) %>%
  count(date, league) %>%
  complete(date = full_seq(c(ymd(20160701), ymd(20190301)), 1),
           league, fill = list(n = 0)) %>%
  ggplot(aes(date, n, color = league)) +
    geom_line(show.legend = FALSE) +
    scale_x_date(limits = c(ymd(20161201), ymd(20190201)),
                 date_labels = "%b %Y") +
    scale_y_continuous(position = "right", minor_breaks = NULL) +
    facet_grid(rows = vars(league), scales = "free", switch="y") +
    labs(title = "The Rhythm of American Sports",
         subtitle = "Games played per day in US leagues, 2017-2018",
         x = NULL, y = NULL)

ggsave("sport-rhythm.svg", device="svg", width=8, height=8, dpi = 2160 / 8)
