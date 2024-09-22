#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-21
#-----------------------------------
# In-Class Assignment 3 (2024/9/23)

library(here)
library(tidyverse)

covariatesdata <- read.csv(here("original", "covariates.csv"), header = TRUE) %>% 
  rename(Year = year)

source(here("R", "create_maternalmortality.R"))
source(here("R", "create_disaster.R"))
source(here("R", "derive_armedconflict.R"))

mergealldata <- merge(merge(merge(worldbankdata, cleandisasterdata, by = c("ISO", "Year"), all = TRUE), 
                         armedconflictdata, by = c("ISO", "Year"), all = TRUE), 
                   covariatesdata, by = c("ISO", "Year"), all = TRUE)

write.csv(mergealldata, here("data", "mergealldata.csv"), row.names = FALSE)