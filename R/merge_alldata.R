#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-23
#-----------------------------------
# In-Class Assignment 3 (2024/9/23)

library(here)
library(tidyverse)

covariatesdata <- read.csv(here("original", "covariates.csv"), header = TRUE) 

# Use source() to call the R scripts that create the individual data sets.

source(here("R", "create_maternalmortality.R"))
source(here("R", "create_disaster.R"))
source(here("R", "derive_armedconflict.R"))

# Put all data frames into a list.

data_list <- list(worldbankdata, cleandisasterdata, armedconflictdata)

# Merge all data frames in the list using reduce() and full_join(). Usage:
# left_join(x, y, by = NULL). A left_join() keeps all observations in x. Use the
# variables "ISO" and "year" as keys to join the data.

mergedata <- data_list %>%
  reduce(full_join, by = c("ISO", "year"))
mergealldata <- covariatesdata %>%
  left_join(mergedata, by = c("ISO", "year"))

# Fill in NAs with 0's for armcon, drought, earthquake, and totdeath.

mergealldata <- mergealldata %>%
  mutate(armcon = replace_na(armcon, 0),
         drought = replace_na(drought, 0),
         earthquake = replace_na(earthquake, 0),
         totdeath = replace_na(totdeath, 0))

write.csv(mergealldata, here("data", "mergealldata.csv"), row.names = FALSE)
