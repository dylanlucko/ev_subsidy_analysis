# Load necessary libraries
# Uncomment and run the lines below if packages are not installed
# install.packages(c("dplyr", "tidyr", "readxl", "fuzzyjoin", "stringr", 
#                    "zipcodeR", "ggplot2", "maps", "geosphere", "fixest", 
#                    "broom", "lubridate"))

library(dplyr)
library(tidyr)
library(readxl)
library(fuzzyjoin)
library(stringr)
library(zipcodeR)
library(ggplot2)
library(maps)
library(geosphere)
library(fixest)
library(broom)
library(lubridate)

# Load datasets
ca_no2 <- read.csv("C:/Users/dlucko/Desktop/2025/EV Paper/42602_04_18_California_Data_Combined.csv")
california_income_per_capita <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/california_income_per_capita.csv")
california_population <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/california_population.csv")
ev_subsidies_per_day_2010_2023 <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/ev_subsidies_per_day_2010_2023.xlsx")
Vehicle_Population_Last_updated_04_30_2024_ada <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/Vehicle_Population_Last_updated_04-30-2024_ada.xlsx",sheet = "County")
ca_farmland_by_use <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/ca_farmland_by_use.csv")
