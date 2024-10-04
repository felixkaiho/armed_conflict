#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-23
#-----------------------------------
# In-Class Assignment 3 (2024/9/23)

library(here)
library(tidyverse)

# conflictdata.csv has already been pre-processed and only contains relevant
# variables and years of observations to create the binary armed conflict
# variable.

# Derive the binary armed conflict variable that was used as the primary
# exposure in the paper. The binary armed conflict variable indicates the
# presence of conflict for each country-year observation (0 = no, < 25
# battle-related deaths; 1 = yes, >= 25 battle-related deaths). 

# Some countries have multiple conflicts per year, but we want the final data to
# only include the indicator of whether the country had a conflict that year.

# Add 1 to year because the armed conflict variable was lagged by a year in the
# analysis.

rawconflict <- read.csv(here("original", "conflictdata.csv"), header = TRUE)
subconflict <- select(rawconflict, ISO, year, best)

armedconflictdata <- subconflict %>%
  group_by(ISO, year) %>%
  summarise(totdeath = sum(best)) %>%
  mutate(armcon = if_else(totdeath < 25, 0, 1)) %>%
  mutate(year = year + 1)