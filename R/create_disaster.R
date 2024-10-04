#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-23
# What: Read in raw data,
#       subset data,
#       convert to wide format
#-----------------------------------
# In-Class Assignment 2 (2024/9/16)

library(here)
library(tidyverse)
 
rawdisaster <- read.csv(here("original", "disaster.csv"), header = TRUE)

# Use the filter() function to subset the data set to only include years
# 2000–2019 and the disaster types “Earthquake” and “Drought”. filter() reduces
# the number of rows or observations but does NOT reduce the number of columns
# or variables in the dataset.

# Use select() to subset the data set to only include the following variables:
# "Year", "ISO", "Disaster.Type". select() reduces the number of columns or
# variables in the dataset.

# Create dummy variables "drought" and "earthquake" which are binary (absence
# or presence of drought or earthquake).

subdisaster <- filter(rawdisaster, Year >= 2000 & Year <= 2019, 
                      Disaster.Type == "Earthquake" | 
                        Disaster.Type == "Drought") %>%
  select(Year, ISO, Disaster.Type) %>%
  rename(year = Year) %>%
  mutate(drought = if_else(Disaster.Type == "Drought", 1, 0)) %>%
  mutate(earthquake = if_else(Disaster.Type == "Earthquake", 1, 0))

# Convert to wide format. Use group_by() and summarize() to create a data set
# where only one row of observation exists for each country and each year.

cleandisasterdata <- subdisaster %>%
  group_by(year, ISO) %>%
  summarise(drought = max(drought), earthquake = max(earthquake))