# Start 

# Install necessary libraries
install.packages(c("readxl", "dplyr", "tidyverse", "dplyr", "wbstats", "WDI"))

# Load Libraries
library(c(readxl, tidyr, tidyverse, dplyr, wbstats, WDI))

# Set wtd
setwd("~/Desktop/working-sessions/cleaning_data")

# Download data from R packages on CRAN
worldbank_data <- wb_data(
  indicator = c("NY.GDP.PCAP.CD", # GDP per capita (current US$)
                "NY.GDP.MKTP.CD", # GDP (current US$)
                "NE.DAB.TOTL.ZS", # Gross national expenditure (% of GDP)
                "NY.ADJ.NNTY.PC.CD", # Adjusted net national income per capita (current US$)
                "NE.IMP.GNFS.ZS", # Imports of goods and services (% of GDP)
                "NE.EXP.GNFS.ZS"), # Exports of goods and services (% of GDP)
  start = 1996, end = 2019)

# Check
names(worldbank_data)

# Download regions and extra information 
wb_countries <- wb_countries()
names(wb_countries)

# Merge 
merged_wb_data <- merge(
  worldbank_data, 
  y = wb_countries[c("iso3c", "country", "region", "region_iso3c")], 
  by = "iso3c", all.x = TRUE)

merged_wb_data <- subset(merged_wb_data, region != "Aggregates") # removes NAs

# View colnames 
colnames(merged_wb_data)

# Rename columns
merged_wb_data <- merged_wb_data %>%
  rename(
    region = "region",
    region_iso3c = "region_iso3c",
    country = "country.x",
    code = "iso3c",
    year = "date",
    gdp_cap_dollar = "NY.GDP.PCAP.CD",
    gdp = "NY.GDP.MKTP.CD",
    gne_gdp = "NE.DAB.TOTL.ZS",
    exports_gdp = "NE.EXP.GNFS.ZS",
    imports_gdp = "NE.IMP.GNFS.ZS",
  ) %>%
  select(
    region, region_iso3c, country, code, year, gdp_cap_dollar, gdp, gne_gdp,
    exports_gdp, imports_gdp)

# Now, worldbank_data has the columns renamed 
colnames(merged_wb_data)

# Remove duplicates
unique_countries <- unique(merged_wb_data$country)

# Display the unique country names
print(unique_countries)

#
# Creating Trade Ratio Variable 
# 

# Add the new column trade_ratio
merged_wb_data$trade_ratio <- (
  merged_wb_data$exports_gdp + merged_wb_data$imports_gdp) / merged_wb_data$gdp_cap_dollar

# Look 
str(merged_wb_data)
head(merged_wb_data)

#
# US Deflator 
#

# Set the indicator code for GDP deflator
deflator_indicator_code <- "NY.GDP.DEFL.ZS.AD"

# Set the country code for the United States
country_code <- "USA"

# Fetch US GDP deflator data
us_deflator_data <- wbstats::wb(indicator = deflator_indicator_code, 
                                country = country_code)

# Check
colnames(us_deflator_data)

# Display the structure of us_deflator_data
print(head(us_deflator_data))

# Remove unwanted columns
us_deflator_data <- subset(
  us_deflator_data, 
  select = -c(iso3c, indicatorID, indicator, iso2c, country))

# Check
print(us_deflator_data)

# Find the deflator value for the year 2015
deflator_2015 <- us_deflator_data %>%
  filter(date == "2015") %>%
  pull(value)

# Check
print(deflator_2015)

#
# Apply the deflator
#

# Create a new column for the deflated GDP per capita
merged_wb_data_deflated <- merged_wb_data %>%
  mutate(adjusted_gdp_cap = gdp_cap_dollar / 100)

# Display the adjusted data
print(head(merged_wb_data_deflated$adjusted_gdp_cap))
str(merged_wb_data_deflated)

#
# Log transforming GDP Variables 
# 

# log transform gdp per capita 
merged_wb_data_deflated$log_adjusted_gdp_cap <- log(merged_wb_data_deflated$adjusted_gdp_cap)

# log transform gdp per capita 
merged_wb_data_deflated$log_gdp <- log(merged_wb_data_deflated$gdp)

# Look
str(merged_wb_data_deflated)
head(merged_wb_data_deflated)

# Reorder columns
wb_data <- merged_wb_data_deflated[, c("region", 
                                       "region_iso3c",
                                       "country", 
                                       "code", 
                                       "year", 
                                       "log_adjusted_gdp_cap", 
                                       "log_gdp",
                                       "trade_ratio",
                                       "exports_gdp", 
                                       "imports_gdp")]
str(wb_data)
summary(wb_data)

# Save as a .csv
write.csv(
  wb_data, 
  file = "~/Desktop/working-sessions/cleaning_data/government_data_updated.csv", 
  row.names = FALSE)

# Save as a .rds
saveRDS(wb_data, "~/Desktop/working-sessions/government_data_updated.csv.rds")

# End