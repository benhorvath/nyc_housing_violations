setwd("~/Dropbox/Documents/school/grad/607/nyc_housing_violations")

library(dplyr)
library(lubridate)
library(tidycensus)
library(tidyr)
library(tigris)

source('./R/config.R')

raw <- read.csv('./data/raw/housing_violations.csv', stringsAsFactors=TRUE) %>%
    rename(lat=latitude, lon=longitude) %>%
    drop_na(lat, lon) %>%
    mutate(approveddate = as.Date(approveddate, '%Y-%m-%dT%X'))

geo <- raw %>%
    group_by(approveddate, censustract) %>%
    summarise(n = n())

geo_long <- geo %>%
    spread(censustract, n) %>%
    filter(approveddate > as.Date('2013-03-01')) %>%
    mutate_all(replace_na, 0)
    
x <- geo_long
x$approveddate <- NULL

y <- as.data.frame(round(cor(x), 6))

y$`10`[abs(y$`10`) > 0.5]


# We know some of these are very strongly correlated