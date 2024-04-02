# Start 

# Install necessary libraries if not already installed
install.packages("readxl")
install.packages("tidyverse")
install.packages("countrycode")

# Load Libraries
library(readxl)
library(tidyverse)
library(countrycode)

# Set wtd
setwd("~/Desktop/working-sessions/cleaning_data")

# Read the data into R Studio
cow_statelist <- read_excel("COW_statelist.xlsx")
treaty <- read_excel("un_treaty.xlsx")

# add country code
treaty$code <- countrycode(
  sourcevar = treaty$country, 
  origin = "country.name", destination = "iso3c")
print(treaty)

# Join the data sets
statelist <- merge(cow_statelist, treaty, by = c("code", "id"), all.x = TRUE)
head(statelist)

# Remove unwanted columns
statelist <- subset(statelist, select = -country.y)
colnames(statelist)[colnames(statelist) == "country.x"] <- "country"
colnames(statelist)

# Replace NA with 0 in the specified columns
columns_to_replace <- c("UN1961", "UN1971", "UN1988")
statelist[columns_to_replace][is.na(statelist[columns_to_replace])] <- 0

# Convert non-zero values to 1
statelist[columns_to_replace] <- +(statelist[columns_to_replace] != 0)
print(statelist)

# Save as a .csv
write.csv(
  statelist, 
  file = "~/Desktop/working-sessions/cleaning_data/statelist.csv", 
  row.names = FALSE)

# Save as a .rds
saveRDS(statelist, "~/Desktop/working-sessions/statelist.rds")

# End