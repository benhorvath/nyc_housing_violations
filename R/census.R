setwd("~/Dropbox/Documents/school/grad/607/nyc_housing_violations")

library(dplyr)
library(lubridate)
library(tidycensus)
library(tidyr)
library(tigris)

# The counties New York City are:
#     
#     005 - Bronx
# 047 - Kings (Brooklyn)
# 061 - New York (Manhattan)
# 081 - Queens
# 085 - Richmond (Staten Island)

source('./R/config.R')

df <- read.csv('./data/clean/housing_dv.csv', stringsAsFactors=FALSE) %>%
    arrange(censustract, year, month)

census_api_key(CENSUS_API_KEY)

census_vars <- load_variables(2016, "acs5", cache = TRUE)

census_df <- get_acs(geography = 'tract', 
                    variables = c(total_pop ='B00001_001',
                                  total_male = 'B01001_002',
                                  pop_white = 'B01001H_001',  # not hispanic
                                  pop_black = 'B01001B_001',
                                  pop_asian = 'B01001D_001',
                                  pop_hispanic = 'B01001I_001',
                                  median_age = 'B01002_001',
                                  natural_us_citizens = 'B05001_002',
                                  naturalized_citizens = 'B05001_005',
                                  non_citizens = 'B05001_006',
                                  below_poverty = 'B05010_002',
                                  poverty_1_2 = 'B05010_010',
                                  poverty_2 = 'B05010_018',
                                  speak_english = 'B06007_002',
                                  speak_spanish = 'B06007_003',
                                  bachelors = 'B06008_002',
                                  married = 'B06008_003',
                                  divorced = 'B06008_004',
                                  widowed = 'B06008_006',
                                  no_hs = 'B06009_002',
                                  hs = 'B06009_003',
                                  bach_degree = 'B06009_005',
                                  grad_degree = 'B06009_006',
                                  income1 = 'B06010_004',  # 1 - 9999
                                  income2 = 'B06010_005',
                                  income3 = 'B06010_006',
                                  income4 = 'B06010_007',
                                  income5 = 'B06010_008',
                                  income6 = 'B06010_009',
                                  income7 = 'B06010_010',
                                  income8 = 'B06010_011',  # 75k+
                                  same_house_year = 'B07001PR_017'), 
                    state = 'NY')
# stopped at 5000

x <- get_acs(geography = 'tract', 
             variables = c(x = 'B05010_002'), 
             state = 'NY')


# New York City counties only
census_df <- census_df %>%
    filter(str_detect(GEOID, '36005.*') == TRUE |
               str_detect(GEOID, '36047.*') == TRUE |
               str_detect(GEOID, '36061.*') == TRUE |
               str_detect(GEOID, '36081.*') == TRUE |
               str_detect(GEOID, '36085.*') == TRUE) %>%
    mutate(censustract = as.numeric(substr(GEOID, 6, 9)))
