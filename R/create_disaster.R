#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-21
# What: Read in raw data,
#       subset data,
#       convert to wide format
#-----------------------------------
library(here)
library(tidyverse)
 
rawdisaster <- read.csv(here("original", "disaster.csv"), header = TRUE)

# subset data

subdisaster <- filter(rawdisaster, Year %in% 2000:2019, Disaster.Type == "Earthquake" | Disaster.Type == "Drought")
subdisaster <- select(subdisaster, Year, ISO, Disaster.Type)
subdisaster <- subdisaster %>%
  mutate(drought = if_else(Disaster.Type == "Drought", 1, 0)) %>%
  mutate(earthquake = if_else(Disaster.Type == "Earthquake", 1, 0))

# convert to wide format

cleandisasterdata <- subdisaster %>%
  group_by(Year, ISO) %>%
  summarise(drought = max(drought), earthquake = max(earthquake))