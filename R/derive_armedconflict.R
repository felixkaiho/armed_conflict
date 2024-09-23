#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-23
#-----------------------------------
# In-Class Assignment 3 (2024/9/23)

library(here)
library(tidyverse)

# Add 1 to year because the armed conflict variable was lagged by a year in the analysis

rawconflict <- read.csv(here("original", "conflictdata.csv"), header = TRUE)
subconflict <- select(rawconflict, ISO, year, best)

armedconflictdata <- subconflict %>%
  group_by(ISO, year) %>%
  summarise(deaths = sum(best)) %>%
  mutate(Armed_conflict = if_else(deaths < 25, 0, 1)) %>%
  mutate(year = year + 1) %>%
  rename(Year = year) %>%
  subset(select = -deaths)
