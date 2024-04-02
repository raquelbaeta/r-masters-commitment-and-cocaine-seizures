# Start

# Install necessary libraries
install.packages(c("readxl", "tidyverse", "dplyr", "countrycode"))

# Load Libraries
library(c(readxl, tidyverse, dplyr, countrycode))

# Set wtd
setwd("~/Desktop/working-sessions/cleaning_data")

# Read the data into R Studio
cocaine_data <- read_excel("seizures_unodc.xlsx")
print(cocaine_data)

# Specify the columns to be filled
columns_to_fill <- c("region",
                     "subregion",
                     "drug_group",
                     "country")

# Fill missing values using a top-down approach
cocaine_data_filled <- cocaine_data %>%
  fill(!!columns_to_fill, .direction = "down")
print(cocaine_data_filled) # Show the filled data
summary(cocaine_data_filled)

# Select rows with "cocaine-type" in drug_group
cocaine_only <- cocaine_data_filled %>%
  filter(str_to_lower(drug_group) == "cocaine-type")

# Print the filtered data
print(cocaine_only)

# Remove unwanted columns
cocaine_only <- subset(cocaine_only, select = -drug)

# add country code
cocaine_only$code <- countrycode(
  sourcevar = cocaine_only$country, 
  origin = "country.name", 
  destination = "iso3c")
print(cocaine_only)
str(cocaine_only)

# Pivot
cocaine_longer <- pivot_longer(
  data = cocaine_only, 
  names_to = 'year', 
  values_to = 'seizures',
  "1990":"2019")
print(cocaine_longer)

# Replace NAs in "seizures" column with 0
cocaine_longer <- cocaine_longer %>%
  mutate(seizures = ifelse(is.na(seizures), 0, seizures))
print(cocaine_longer)

# binary variables 
cocaine_longer <- cocaine_longer %>%
  mutate(
    seizures = ifelse(is.na(seizures), 0, seizures),
    seizures_binary = as.numeric(seizures > 0)
  )

# Display the modified dataframe
summary(cocaine_longer)

# Remove unwanted columns
cocaine_longer <- subset(cocaine_longer, 
                         select = -c(region, subregion, drug_group))
colnames(cocaine_longer)

# Filter rows where the year is 1996 or later
cocaine_longer <- cocaine_longer[cocaine_longer$year >= 1996, ]

# Convert the "year" column to numeric
cocaine_longer$year <- as.numeric(cocaine_longer$year)

# Print the cleaned data
print(cocaine_longer)

# Save as a .csv
write.csv(
  cocaine_longer, 
  file = "~/Desktop/working-sessions/cleaning_data/cocaine_data_long.csv", 
  row.names = FALSE)

# Save as a .rds
saveRDS(cocaine_longer, "~/Desktop/working-sessions/cleaning_data.rds")

# End