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
    mutate(approveddate = as.Date(approveddate, '%Y-%m-%dT%X'))

df <- raw %>%
    group_by(approveddate) %>%
    summarise(n = n()) %>%
    mutate(month = month(approveddate, label=TRUE),
           dom = day(approveddate),
           wday = wday(approveddate, label=TRUE))

library(rpart)

dt <- rpart(n ~ month + dom + wday, df)



dow <- df %>% group_by(month) %>% summarise(n = sum(n))

ggplot(df, aes(x=month, y=n)) + geom_boxplot()


# Top
raw %>% 
    filter(approveddate >= as.Date('2015-01-01')) %>%
    group_by(censustract) %>% 
    summarise(n = n()) %>% 
    arrange(desc(n))
# # A tibble: 454 x 2
# censustract     n
# <int> <int>
#     1         301    82
# 2         992    59
# 3         385    50
# 4        1130    49
# 5       59402    46
# 6         920    45
# 7         255    42
# 8        1194    42
# 9         251    40
# 10          29    38