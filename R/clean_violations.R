# setwd("~/Dropbox/Documents/school/grad/607/nyc_housing_violations")

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

# Get tract from Census
raw$tract <- append_geoid(raw, geoid_type='tract')

# Save data
write.csv('./data/clean/violations.tsv', row.names=FALSE)


# census_api_key(CENSUS_API_KEY)
# 
# # Variables
# v15 <- load_variables(2016, "acs5", cache = TRUE)
# 
# vt <- get_acs(geography = "tract", 
#               variables = c(x = "B11001_001"), 
#               state = "NY")
# 
# 
# # Look at just one tract
# tract <- raw %>%
#     filter(censustract == 214) %>%
#     arrange(approveddate)

