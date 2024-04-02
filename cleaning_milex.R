# Start 

# title: "Cleaining military spending data"
# author: "Raquel Baeta"
# date: "2024-03-04"

# Install libraries
install.packages(c("readxl", "dplyr", "tidyverse", "dplyr"))

# Load Libraries
library(c(readxl, tidyr, tidyverse, dplyr, countrycode))

# Set wtd
setwd("~/Desktop/working-sessions/cleaning_data")

# file path
file_path <- "~/Desktop/working-sessions/cleaning_data/milex_sipri.xlsx"

###
# US dollar 
###

# Read the "Current US$" sheet, skipping the first 5 rows and selecting columns from the 6th row
milex_dollar <- read_excel(file_path, 
                           sheet = "Current US$", 
                           skip = 5, 
                           range = "A6:AE199")

# Check
milex_dollar

# Pivot
milex_dollar_longer <- milex_dollar %>%
  pivot_longer(cols = "1990":"2019", 
               names_to = "year", 
               values_to = "milex_dollar")

# Print the first few rows of the resulting data frame
print(milex_dollar_longer)

# List of values to exclude
excluded_values <- c("Africa", "North Africa", "Americas",
                     "Central America and the Caribbean", "South America", 
                     "Asia & Oceania", "Oceania", "South Asia", "East Asia",
                     "South East Asia", "Central Asia", "Europe", 
                     "Central Europe", "Eastern Europe", "Western Europe", 
                     "European Union", "Middle East")

# Filter out rows with values in the 'Country' column that are in the exclusion list
filtered_milex_dollar <- milex_dollar_longer %>%
  filter(!country %in% excluded_values)

# Use countrycode
filtered_milex_dollar$code <- countrycode(
  sourcevar = filtered_milex_dollar$country,
  origin = "country.name", 
  destination = "iso3c"
 )

# Print the resulting data frame
print(filtered_milex_dollar) 

# Convert one variable to numeric
filtered_milex_dollar$milex_dollar <- as.numeric(as.character(filtered_milex_dollar$milex_dollar)) 

filtered_milex_dollar$year <- as.numeric(as.character(filtered_milex_dollar$year)) 

# Print the resulting data frame
print(filtered_milex_dollar)

###
# GDP
###

# Read the "Share of GDP" sheet, skipping the first 5 rows and selecting columns from the 6th row
milex_gdp <- read_excel(file_path, 
                        sheet = "Share of GDP", 
                        skip = 5, 
                        range = "A6:AE199")

# Check
milex_gdp

# Pivot
milex_gdp_longer <- milex_gdp %>%
  pivot_longer(cols = "1990":"2019", 
               names_to = "year", 
               values_to = "milex_gdp")

# List of values to exclude
excluded_values <- c("Africa", "North Africa", "Americas",
                     "Central America and the Caribbean", "South America", 
                     "Asia & Oceania", "Oceania", "South Asia", "East Asia",
                     "South East Asia", "Central Asia", "Europe", 
                     "Central Europe", "Eastern Europe", "Western Europe", 
                     "European Union", "Middle East")

# Filter out rows with values in the 'country' column that are in the exclusion list
filtered_milex_gdp <- milex_gdp_longer %>%
  filter(!country %in% excluded_values)

# Use countrycode
filtered_milex_gdp$code <- countrycode(
  sourcevar = filtered_milex_gdp$country,
  origin = "country.name", 
  destination = "iso3c"
 )

# Print the resulting data frame
print(filtered_milex_gdp) 

# Convert one variable to numeric
filtered_milex_gdp$milex_gdp <- as.numeric(as.character(filtered_milex_gdp$milex_gdp)) 

filtered_milex_gdp$year <- as.numeric(as.character(filtered_milex_gdp$year)) 

# Print the resulting data frame
print(filtered_milex_gdp)

###
# Merge
###

# find out which column names are common between the two dataframes
common_col_names <- intersect(names(filtered_milex_gdp), 
                              names(filtered_milex_dollar))

# character vector as y parameters in the merge()
milex_data <- merge(filtered_milex_gdp, 
                    filtered_milex_dollar, 
                    by = common_col_names, 
                    all.x = TRUE)

# Filter rows where the year is 1996 or later
milex_data <- milex_data[milex_data$year >= 1996, , drop = FALSE]
print(milex_data)

# Save as a .csv
write.csv(
  milex_data, 
  file = "~/Desktop/working-sessions/cleaning_data/milex_data.csv", 
  row.names = FALSE)

# Save as a .rds
saveRDS(milex_data, "~/Desktop/working-sessions/milex_data.csv.rds")

# End
