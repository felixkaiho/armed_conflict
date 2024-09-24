#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-23
# What: Read in raw data,
#       subset data,
#       convert to wide format
#-----------------------------------
library(here)
library(tidyverse)
 
rawdisaster <- read.csv(here("original", "disaster.csv"), header = TRUE)

# Subset data.

subdisaster <- filter(rawdisaster, Year >= 2000 & Year <= 2019, 
                      Disaster.Type == "Earthquake" | 
                        Disaster.Type == "Drought") %>%
  select(Year, ISO, Disaster.Type) %>%
  rename(year = Year) %>%
  mutate(drought = if_else(Disaster.Type == "Drought", 1, 0)) %>%
  mutate(earthquake = if_else(Disaster.Type == "Earthquake", 1, 0))

# Convert to wide format.

cleandisasterdata <- subdisaster %>%
  group_by(year, ISO) %>%
  summarise(drought = max(drought), earthquake = max(earthquake))