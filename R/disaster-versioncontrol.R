#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-14
# What: Read in raw data,
#       subset data,
#       convert to wide format
#-----------------------------------
library(here)
library(tidyverse)
 
rawdat <- read.csv(here("original", "disaster.csv"), header = TRUE)

# subset data

subdat <- filter(rawdat, Year %in% 2000:2019, Disaster.Type == "Earthquake" | Disaster.Type == "Drought")
subdat <- select(subdat, Year, ISO, Disaster.Type)
subdat <- subdat %>%
  mutate(drought = if_else(Disaster.Type == "Drought", 1, 0)) %>%
  mutate(earthquake = if_else(Disaster.Type == "Earthquake", 1, 0))

# convert to wide format

widedat <- subdat %>%
  group_by(Year, ISO) %>%
  summarise(drought = sum(drought), earthquake = sum(earthquake))
