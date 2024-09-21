#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-14
# What: Read in raw data,
#       subset data,
#       convert to long format
#-----------------------------------
library(here)
library(tidyverse)
library(stringr) 
rawdat <- read.csv(here("original", "maternalmortality.csv"), header = TRUE)

# subset data

subdat <- select(rawdat, Country.Name, X2000:X2019)

#convert to long format

#rename_with() is a function from dplyr that allows you to modify column names
#based on a function. str_remove(., "^X") from stringr removes the X at the
#beginning of each column name (^ indicates the start of the string).
#starts_with("X") specifies that only columns with names starting with "X" will
#be renamed.

subdat <- subdat %>%
  rename_with(~ str_remove(., "^X"), starts_with("X")) 
longdat <- subdat %>%
  pivot_longer(c(`2000`:`2019`), names_to = "Year", values_to = "MatMor")
longdat$Year <- as.numeric(longdat$Year)

# Output results to a different sub-folder
write.csv(longdat,here("data", "clean-maternalmortality.csv"), row.names = FALSE)
