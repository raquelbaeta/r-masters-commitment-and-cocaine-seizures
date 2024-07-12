## Project: Data Cleaning and Merging for Master Research Report

This project involves cleaning and merging multiple datasets to create a comprehensive dataset for a master research report. The scripts provided in this repository perform data cleaning, transformation, and merging operations on various datasets, including cocaine data, government data, state list data, World Governance Indicators (WGI) data, and military expenditure (MILEX) data.

To run the scripts in this repository, you need to have R installed on your system. 

Additionally, you need to install the following R packages:
install.packages(c("readxl", "dplyr", "tidyverse", "countrycode", "fuzzyjoin"))

### Set the Working Directory
Update the working directory in the script to the location where you have placed your datasets:
setwd("~/path-to-your-directory/cleaning_data")

The script will perform the following operations:
Install necessary libraries
Load and clean individual datasets
Merge the cleaned datasets
Save the final merged dataset as .csv and .rds files

### Datasets

The following datasets are used in this project:

cocaine_data_long.csv: Contains data on cocaine seizures.
government_data.csv: Contains government-related data.
statelist.csv: Contains data on various states.
wgi_data.csv: Contains World Governance Indicators data.
milex_data.csv: Contains military expenditure data.

### Scripts
data_cleaning_and_merging.R: Main script that performs data cleaning and merging operations.

The cleaned and merged dataset will be saved in the following files:
cleaned_data.csv: CSV format of the final dataset.
cleaned_data.rds: RDS format of the final dataset.

### Contributing
If you would like to contribute to this project, please follow these steps:

Fork the repository.
Create a new branch (git checkout -b feature-branch).
Make your changes.
Commit your changes (git commit -m 'Add some feature').
Push to the branch (git push origin feature-branch).
Create a new Pull Request.


If you have any questions or need further assistance, please open an issue or contact the repository maintainer.

### Contact
For any inquiries, please contact raquel@aside.co.za.
