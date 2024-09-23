#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-23
#-----------------------------------
# In-Class Assignment 3 (2024/9/23)

library(here)
library(tidyverse)

covariatesdata <- read.csv(here("original", "covariates.csv"), header = TRUE) %>% 
  rename(Year = year)

source(here("R", "create_maternalmortality.R"))
source(here("R", "create_disaster.R"))
source(here("R", "derive_armedconflict.R"))

data_list <- list(worldbankdata, cleandisasterdata, armedconflictdata, covariatesdata)

mergealldata <- Reduce(function(x, y) merge(x, y, by = c("ISO", "Year"), all = TRUE), data_list)

# Delete all rows that have NA for ISO.

mergealldata_clean <- mergealldata[!is.na(mergealldata$ISO),]

write.csv(mergealldata_clean, here("data", "mergealldata.csv"), row.names = FALSE)
