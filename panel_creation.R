
# Load necessary library
library(dplyr)

library(readxl)

ca_no2 <- read.csv("C:/Users/dlucko/Desktop/2025/EV Paper/42602_04_18_California_Data_Combined.csv")

california_income_per_capita <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/california_income_per_capita.csv")

california_population <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/california_population.csv")

ev_subsidies_per_day_2010_2023 <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/ev_subsidies_per_day_2010_2023.xlsx")

Vehicle_Population_Last_updated_04_30_2024_ada <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/Vehicle_Population_Last_updated_04-30-2024_ada.xlsx", 
sheet = "County")

###################
###################


# Load necessary library
library(dplyr)

# Convert data types for merging
ca_no2 <- ca_no2 %>%
  mutate(county_code = as.character(county_code), 
         date_local_year = as.integer(substr(date_local, 1, 4)))  # Extracting year as integer

# Perform the left join
merged_data <- ca_no2 %>%
  left_join(california_income_per_capita, 
            by = c("county" = "County", "date_local_year" = "Year"))

# View the merged dataframe
head(merged_data)



# Merge the result with california_population
merged_data <- merged_data %>%
  left_join(california_population, 
            by = c("county" = "County", "date_local_year" = "Year"))

# View the merged dataframe
head(merged_data)


merged_data <- merged_data %>%
  mutate(date_local = as.Date(date_local))

##############
##############
# Handle EV Subsidy Per Day ###
##############
###############


# Load necessary library
library(dplyr)
library(tidyr)

# Convert Application Date to proper date format if not already
ev_subsidies_per_day_2010_2023 <- ev_subsidies_per_day_2010_2023 %>%
  mutate(`Application Date` = as.Date(`Application Date`))

# Aggregate data to have one daily record per county
ev_subsidies_daily <- ev_subsidies_per_day_2010_2023 %>%
  group_by(County, `Application Date`) %>%
  summarise(
    `Total Rebate Dollars` = sum(`Rebate Dollars`, na.rm = TRUE),  # Total sum of rebate dollars
    `Min Rebate Amount` = min(`Rebate Dollars`, na.rm = TRUE),  # Minimum subsidy amount per day
    `Mean Rebate Amount` = mean(`Rebate Dollars`, na.rm = TRUE),  # Average subsidy amount per day
    `Median Rebate Amount` = median(`Rebate Dollars`, na.rm = TRUE),  # Median subsidy amount per day
    `Max Rebate Amount` = max(`Rebate Dollars`, na.rm = TRUE),  # Maximum subsidy amount per day
    `Total Applications` = n(),  # Counting total applications per day
    `Total Low-Income Count` = sum(`Low-/Moderate-Income Increased Rebate`, na.rm = TRUE),  # Counting low-income rebates
    `Vehicle Categories` = paste(unique(`Vehicle Category`), collapse = ", "),  # Concatenating unique categories
    `Vehicle Makes` = paste(unique(`Vehicle Make`), collapse = ", "),  # Concatenating unique vehicle makes
    `Electric Utilities` = paste(unique(`Electric Utility`), collapse = ", "),  # Concatenating unique utilities
    `Funding Sources` = paste(unique(`Funding Source`), collapse = ", ")  # Concatenating funding sources
  ) %>%
  ungroup()

# Add separate count columns for each vehicle category
ev_subsidies_daily <- ev_subsidies_per_day_2010_2023 %>%
  group_by(County, `Application Date`, `Vehicle Category`) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  pivot_wider(names_from = `Vehicle Category`, values_from = Count, values_fill = 0) %>%  # Convert categories to separate columns
  right_join(ev_subsidies_daily, by = c("County", "Application Date"))

# View the first few rows of the cleaned dataset
head(ev_subsidies_daily)


ev_subsidies_daily <- ev_subsidies_daily %>%
  rename(date = `Application Date`) %>%
  rename(county = County)


merged_data <- merged_data %>%
  rename(date = date_local)
