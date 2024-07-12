# Start 

# Install necessary libraries if not already installed
install.packages(c("readxl", "dplyr", "tidyverse", "countrycode"))

# Load Libraries
library(c(readxl, readr, tidyr, tidyverse, dplyr, countrycode))

# Set working directory
setwd("~/Desktop/working-sessions/cleaning_data")

# Function to load and clean cocaine data
clean_cocaine_data <- function() {
  cocaine_data <- read_csv("csv/cocaine_data_long.csv")
  
  # Display unique country names
  print(unique(cocaine_data$country))
  
  # Rename "United States of America" to "United States"
  cocaine_data$country[
    cocaine_data$country == "United States of America"] <- "United States"
  print(unique(cocaine_data$country))
  
  # Display summary
  summary(cocaine_data)
  
  return(cocaine_data)
}


# Function to load and clean government data 
clean_government_data <- function() {
  government_data <- read_csv(csv/cocaine_data_long.csv)
  
  # Display summary and unique country names
  summary(government_data)
  print(unique(government_data$country))
  
  # Rename "United States of America" to "United States"
  government_data$country[
    government_data$country == "United States of America"] <- "United States"
  print(unique(government_data$country))
  
  # Display summary
  summary(government_data)
  
  return(government_data)
}


# Function to load and clean state list data
clean_statelist_data <- function() {
  statelist <- read_csv("csv/statelist.csv")
  
  # Rename "United States of America" to "United States"
  statelist$country[statelist$country == "United States of America"] <- "United States"
  print(unique(statelist$country))
  
  return(statelist)
}

# Function to load and clean WGI data
clean_wgi_data <- function() {
  wgi_data <- read_csv("csv/wgi_data.csv")
  
  # Display unique country names
  print(unique(wgi_data$country))
  
  return(wgi_data)
}

# Function to load and clean MILEX data
clean_milex_data <- function(file_path) {
  milex_data <- read_csv(file_path)
  
  return(milex_data)
}