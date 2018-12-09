setwd("~/Dropbox/Documents/school/grad/607/nyc_housing_violations")

library(dplyr)
library(lubridate)
library(tidycensus)
library(tidyr)
library(tigris)

# MONTH IS EXTREMELY IMPORTANT!

source('./R/config.R')

raw <- read.csv('./data/raw/housing_violations.csv', stringsAsFactors=TRUE) %>%
    rename(lat=latitude, lon=longitude) %>%
    drop_na(lat, lon) %>%
    mutate(approveddate = as.Date(approveddate, '%Y-%m-%dT%X')) %>%
    filter(approveddate >= '2016-01-01') %>%
    mutate(year = year(approveddate),
           month = month(approveddate)) %>%
    group_by(year, month, censustract) %>%
    summarise(n=n())

# Fill in all missing dates and areas
month <- seq(1, 12)
year <- c(2016, 2017, 2018)
censustract <- unique(raw$censustract)
df <- crossing(month, year, censustract)

df <- left_join(df, raw, by=c('year', 'month', 'censustract'))
df$n <- replace_na(df$n, 0)

write.csv(df, './data/clean/housing_dv.csv', row.names=FALSE)

lagged <- df %>% arrange(censustract, month, year) %>%
    group_by(censustract) %>%
    mutate(l1 = lag(n,1)) %>%
    na.omit(.)
cor(lagged$n, lagged$l1)
plot(lagged$l1, lagged$n)