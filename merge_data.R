# Start 

# Install necessary libraries if not already installed
install.packages(c("readxl", "dplyr", "tidyverse", "countrycode"))

# Load Libraries
library(c(readxl, readr, tidyr, tidyverse, dplyr, countrycode))

# Set working directory
setwd("~/Desktop/working-sessions/cleaning_data")

# Datasets
cocaine_data <- clean_cocaine_data("csv/cocaine_data_long.csv")
government_data <- clean_government_data("government_data_updated.csv")
statelist_data <- clean_statelist_data("csv/statelist.csv")
wgi_data <- clean_wgi_data("csv/wgi_data.csv")
milex_data <- clean_milex_data("csv/milex_data.csv")

# Merge cocaine data with government data using fuzzy join
coca_gov <- fuzzyjoin::stringdist_left_join(
  cocaine_data, government_data,
  by = c("code", "year"),
  method = "jw",  # Jaro-Winkler distance for fuzzy matching
  max_dist = 0.1  # Adjust the threshold for similarity
)

# Remove unwanted columns and rename others
coca_gov_cleaned <- coca_gov %>% 
  select(-c(country.y, code.y, year.x)) %>%
  rename(year = year.y, code = code.x, country = country.x)

# Reorder columns
coca_gov_cleaned <- coca_gov_cleaned[, c(
  "region", "region_iso3c", 
  "country", "code", "year", 
  "seizures", "seizures_binary", 
  "log_adjusted_gdp_cap", "log_gdp",
  "trade_ratio", "exports_gdp", "imports_gdp")]
colnames(coca_gov_cleaned)

# Merge cleaned coca_gov data with statelist data using fuzzy join
coca_state <- fuzzyjoin::stringdist_left_join(
  coca_gov_cleaned, statelist_data,
  by = c("code", "country"),
  method = "jw",  # Jaro-Winkler distance for fuzzy matching
  max_dist = 0.1  # Adjust the threshold for similarity
)

# Remove duplicates and keep only unique rows
coca_state <- coca_state %>% distinct()
nrow(coca_state) # Count the number of unique rows

# Remove unwanted columns and rename others
coca_state_cleaned <- coca_state %>% 
  select(-c(code.y, country.y, id)) %>%
  rename(country = country.x, code = code.x)

# Replace NAs in specified columns with 0
cols_to_replace_na <- c("UN1961", "UN1971", "UN1988")
coca_state_cleaned[cols_to_replace_na][is.na(coca_state_cleaned[cols_to_replace_na])] <- 0

# Reorder columns
coca_state_cleaned <- coca_state_cleaned[, c(
  "region", "region_iso3c", 
  "country", "code", "year", 
  "seizures", "seizures_binary",
  "UN1961", "UN1971", "UN1988",
  "log_adjusted_gdp_cap", "log_gdp",
  "trade_ratio", "exports_gdp", "imports_gdp")]

str(coca_state_cleaned)

# Merge cleaned coca_state data with WGI data
coca_gov_wgi <- merge(wgi_data, coca_state_cleaned, by = c("code", "year"))

# Remove and rename columns
coca_gov_wgi <- coca_gov_wgi %>%
  select(-country.x) %>%
  rename(country = country.y)

# Remove duplicates and keep only unique rows
coca_gov_wgi <- coca_gov_wgi %>% distinct()
nrow(coca_gov_wgi) # Count the number of unique rows

# Check the structure of the merged data
head(coca_gov_wgi)
tail(coca_gov_wgi)

# Reorder columns
coca_gov_wgi <- coca_gov_wgi[, c(
  "region", "region_iso3c",
  "country", "code", "year",
  "UN1961", "UN1971", "UN1988",  
  "seizures", "seizures_binary",
  "log_adjusted_gdp_cap", "log_gdp",  
  "trade_ratio",  "exports_gdp", "imports_gdp",  
  "CC.EST", "GE.EST", "RQ.EST", "RL.EST", "VA.EST", "PV.EST")]

str(coca_gov_wgi)

# Merge with MILEX data
data <- merge(coca_gov_wgi, milex_data, by = c("code", "year"))

# Remove unwanted columns and rename others
data <- data %>%
  select(-country.x) %>%
  rename(country = country.y)

# Reorder columns
data <- data[, c(
  "region", "region_iso3c", "country", "code", 
  "year", "UN1961", "UN1971", "UN1988",
  "seizures", "seizures_binary",
  "log_adjusted_gdp_cap", "log_gdp", "milex_gdp",
  "trade_ratio", "exports_gdp", "imports_gdp", 
  "CC.EST", "GE.EST", "RQ.EST", "RL.EST", "VA.EST", "PV.EST")]

# Filter rows where the year is 1996 or later
data <- data[data$year >= 1996, , drop = FALSE]

# Remove rows with missing values
cleaned_data <- data[complete.cases(data), ]

# Create "any" variable indicating if any UN resolutions are present
cleaned_data <- cleaned_data %>%
  mutate(any_UN = ifelse(UN1961 == 1 | UN1971 == 1 | UN1988 == 1, 1, 0))

# Ensure unique rows
cleaned_data_unique <- cleaned_data %>%
  distinct(region, region_iso3c, country, code, year, any_UN, .keep_all = TRUE)

# Reorder columns
clean_data <- cleaned_data_unique[, c(
  "region", "region_iso3c", "country", "code", 
  "year", "any_UN", "UN1961", "UN1971", "UN1988",
  "seizures", "seizures_binary",
  "log_adjusted_gdp_cap", "log_gdp", "milex_gdp",
  "trade_ratio", "exports_gdp", "imports_gdp", 
  "CC.EST", "GE.EST", "RQ.EST", "RL.EST", "VA.EST", "PV.EST")]

# Save the cleaned data as .csv and .rds files
write.csv(clean_data, 
          file = "~/Desktop/working-sessions/cleaning_data/cleaned_data.csv", 
          row.names = FALSE)
saveRDS(clean_data, file = "~/Desktop/working-sessions/cleaning_data/cleaned_data.rds")

# End