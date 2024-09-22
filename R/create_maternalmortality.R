#-----------------------------------
# Author: Felix Ho
# Last updated: 2024-9-21
#-----------------------------------
# In-Class Assignment 2 (2024/9/16)

library(here)
library(tidyverse)
library(stringr) 

rawmaternal <- read.csv(here("original", "maternalmortality.csv"), header = TRUE)

# subset data

submaternal <- select(rawmaternal, Country.Name, X2000:X2019)

#convert to long format

#rename_with() is a function from dplyr that allows you to modify column names
#based on a function. str_remove(., "^X") from stringr removes the X at the
#beginning of each column name (^ indicates the start of the string).
#starts_with("X") specifies that only columns with names starting with "X" will
#be renamed.

submaternal <- submaternal %>%
  rename_with(~ str_remove(., "^X"), starts_with("X")) 
longdat <- submaternal %>%
  pivot_longer(c(`2000`:`2019`), names_to = "Year", values_to = "MatMor")
longdat$Year <- as.numeric(longdat$Year)

#----------------------------------
# In-Class Assignment 3 (2024/9/23)

makelong_old <- function(x){
  rawdat_old <- read.csv(here("original", x), header = TRUE) %>%
    select(Country.Name, X2000:X2019) %>%
    rename_with(~ str_remove(., "^X"), starts_with("X")) %>%
    pivot_longer(c(`2000`:`2019`), names_to = "Year", values_to = x) %>%
    rename(Country_name = Country.Name) %>% 
    mutate(Year = as.numeric(Year))
}

maternalmortality_old <- makelong_old("maternalmortality.csv")
infantmortality_old <- makelong_old("infantmortality.csv")
neonatalmortality_old <- makelong_old("neonatalmortality.csv")
under5mortality_old <- makelong_old("under5mortality.csv")

worldbankdata_old <- list(maternalmortality_old, infantmortality_old, neonatalmortality_old, under5mortality_old) %>%
  reduce(full_join) %>%
  rename(Maternal_mortality_rate = maternalmortality.csv, 
         Infant_mortality_rate = infantmortality.csv,
         Neonatal_mortality_rate = neonatalmortality.csv,
         Under_5_mortality_rate = under5mortality.csv)

# Add the ISO-3 country code variable to the new data set, call the new variable
# ISO, and remove the Country_name variable.

library(countrycode)
worldbankdata_old$ISO <- countrycode(worldbankdata_old$Country_name, origin = "country.name", destination = "iso3c")

# Note: Some countries do not have ISO-3 country codes if we use the countrycode() function.

# New code that does not follow the instructions on ISO-3 country codes:

makelong <- function(x){
  rawdat <- read.csv(here("original", x), header = TRUE) %>%
    select(Country.Code, X2000:X2019) %>%
    rename_with(~ str_remove(., "^X"), starts_with("X")) %>%
    pivot_longer(c(`2000`:`2019`), names_to = "Year", values_to = x) %>%
    rename(ISO = Country.Code) %>% 
    mutate(Year = as.numeric(Year))
}

maternalmortality <- makelong("maternalmortality.csv")
infantmortality <- makelong("infantmortality.csv")
neonatalmortality <- makelong("neonatalmortality.csv")
under5mortality <- makelong("under5mortality.csv")

worldbankdata <- list(maternalmortality, infantmortality, neonatalmortality, under5mortality) %>%
  reduce(full_join) %>%
  rename(Maternal_mortality_rate = maternalmortality.csv, 
         Infant_mortality_rate = infantmortality.csv,
         Neonatal_mortality_rate = neonatalmortality.csv,
         Under_5_mortality_rate = under5mortality.csv)
