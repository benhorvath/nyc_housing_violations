# setwd("~/Dropbox/Documents/school/grad/607/nyc_housing_violations")

library(dplyr)
library(lubridate)
library(tidycensus)
library(tidyr)
library(tigris)

source('./R/config.R')

raw <- read.csv('./data/raw/311_calls_2014.csv', stringsAsFactors=TRUE)
colnames(raw) <- c("address_type","agency","agency_name","bbl","borough","bridge_highway_direction","bridge_highway_name","bridge_highway_segment","city","closed_date","community_board","complaint_type","created_date","cross_street_1","cross_street_2","descriptor","due_date","facility_type","incident_address","incident_zip","intersection_street_1","intersection_street_2","landmark","latitude","location","location_address","location_city","location_state","location_type","location_zip","longitude","open_data_channel_type","park_borough","park_facility_name","resolution_action_updated_date","resolution_description","road_ramp","status","street_name","taxi_company_borough","taxi_pick_up_location","unique_key","vehicle_type","x_coordinate_state_plane","y_coordinate_state_plane")

raw <- raw %>%
    rename(lat=latitude, lon=longitude) %>%
    mutate(created_date = as.Date(created_date, '%Y-%m-%dT%X')) %>%
    drop_na(lat, lon)







####

# Get tract from Census
raw$tract <- append_geoid(raw, geoid_type='tract')

# Save data
write.csv('./data/clean/311_calls.tsv', row.names=FALSE)





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