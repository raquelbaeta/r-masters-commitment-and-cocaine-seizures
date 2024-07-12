# Start 

# title: "Cleaning economic indicators datasets"
# author: "Raquel Baeta"
# date: "2024-07-12"

# Install necessary libraries
install.packages(c("readxl", "tidyr", "tidyverse", "dplyr"))

# Load libraries
library(c(readxl, tidyr, tidyverse, dplyr)

# Set working directory
setwd("~/Desktop/working-sessions/cleaning_data")

# Read the data from Excel file
wgi <- read_excel("wgi_world_bank.xlsx", sheet = "Data")

# Filter rows where 'series_name' contains 'Estimate'
wgi_filtered <- wgi %>% filter(str_detect(series_name, "Estimate"))

# Convert columns 1996 to 2019 to numeric
wgi_numeric <- wgi_filtered %>% mutate(across(`1996`:`2019`, as.numeric))

# Select relevant columns
wgi_transformed <- wgi_numeric %>%
  select(series_code, country, code, `1996`:`2019`) %>%
  pivot_longer(cols = `1996`:`2019`, names_to = "year", values_to = "value") %>%
  filter(series_code %in% c("CC.EST", "GE.EST", "RQ.EST", "RL.EST", "VA.EST", "PV.EST")) %>%
  rename(estimate = value) %>%
  pivot_wider(names_from = series_code, values_from = estimate)

# Save the transformed data as a .csv file
write.csv(wgi_transformed, file = "~/Desktop/working-sessions/cleaning_data/wgi_data.csv", row.names = FALSE)

# Save the transformed data as a .rds file
saveRDS(wgi_transformed, file = "~/Desktop/working-sessions/cleaning_data/wgi_data.rds")

# End
