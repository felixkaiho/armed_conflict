#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-23
#-----------------------------------
# In-Class Assignment 2 (2024/9/16)

library(here)
library(tidyverse)
library(stringr) 

rawmaternal <- read.csv(here("original", "maternalmortality.csv"), 
                        header = TRUE)

# Subset data.

submaternal <- select(rawmaternal, Country.Name, X2000:X2019)

# Convert to long format.

#rename_with() is a function from dplyr that allows you to modify column names
#based on a function. str_remove(., "^X") from stringr removes the X at the
#beginning of each column name (^ indicates the start of the string).
#starts_with("X") specifies that only columns with names starting with "X" will
#be renamed.

submaternal <- submaternal %>%
  rename_with(~ str_remove(., "^X"), starts_with("X")) 
longdat <- submaternal %>%
  pivot_longer(c(`2000`:`2019`), names_to = "year", values_to = "matmor")
longdat$Year <- as.numeric(longdat$year)

#----------------------------------
# In-Class Assignment 3 (2024/9/23)

# Create a function that performs the same procedure on the maternal mortality,
# infant mortality, neonatal mortality, and under 5 mortality data.

makelong <- function(x, y){
  rawdat <- read.csv(here("original", x), header = TRUE) %>%
    select(Country.Name, X2000:X2019) %>%
    rename_with(~ str_remove(., "^X"), starts_with("X")) %>%
    pivot_longer(c(`2000`:`2019`), names_to = "year", values_to = y) %>%
    mutate(year = as.numeric(year))
}

# Apply the function to the four data sets and create four new data sets. 

maternalmortality <- makelong(x = "maternalmortality.csv", 
                              y = "matmor")
infantmortality <- makelong(x = "infantmortality.csv", 
                            y = "infmor")
neonatalmortality <- makelong(x = "neonatalmortality.csv", 
                              y =  "neomor")
under5mortality <- makelong(x = "under5mortality.csv", 
                            y = "un5mor")

# Merge the four data sets into one new data set.

worldbankdata <- list(maternalmortality, infantmortality, neonatalmortality, 
                      under5mortality) %>%
  reduce(full_join, by = c("Country.Name", "year")) 

# Add the ISO-3 country code variable to the new data set, call the new variable
# ISO, and remove the Country.Name variable. Some countries do not have ISO-3
# country codes if we use the countrycode() function. That is fine because these
# countries will be removed in the final analysis.

library(countrycode)
worldbankdata$ISO <- countrycode(worldbankdata$Country.Name, 
                                 origin = "country.name", destination = "iso3c")
worldbankdata <- subset(worldbankdata, select = -Country.Name)