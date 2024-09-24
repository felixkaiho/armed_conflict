#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-23
#-----------------------------------
# In-Class Assignment 3 (2024/9/23)

library(here)
library(tidyverse)

# The binary armed conflict variable indicates the presence of conflict for each
# country-year observation (0 = no, < 25 battle-related deaths; 1 = yes, >= 25
# battle-related deaths). Add 1 to year because the armed conflict variable was
# lagged by a year in the analysis.

rawconflict <- read.csv(here("original", "conflictdata.csv"), header = TRUE)
subconflict <- select(rawconflict, ISO, year, best)

armedconflictdata <- subconflict %>%
  group_by(ISO, year) %>%
  summarise(totdeath = sum(best)) %>%
  mutate(armcon = if_else(totdeath < 25, 0, 1)) %>%
  mutate(year = year + 1)