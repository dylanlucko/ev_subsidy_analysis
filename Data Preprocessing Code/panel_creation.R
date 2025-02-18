

# This script loads multiple datasets, processes them, merges them into a single panel dataset, 
# and writes the final cleaned dataset to a CSV file for further analysis. 
# The script integrates data on NO₂ levels, population, income, EV subsidies, vehicle population, and farmland usage.

# Source the preamble script to load necessary functions and libraries
source("C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/Data Preprocessing Code/preamble.R")


ca_no2 <- read.csv("C:/Users/dlucko/Desktop/2025/EV Paper/42602_04_18_California_Data_Combined.csv")

california_income_per_capita <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/california_income_per_capita.csv")

california_population <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/california_population.csv")

ev_subsidies_per_day_2010_2023 <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/ev_subsidies_per_day_2010_2023.xlsx")

Vehicle_Population_Last_updated_04_30_2024_ada <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/Vehicle_Population_Last_updated_04-30-2024_ada.xlsx", 
sheet = "County")

ca_farmland_by_use <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/ca_farmland_by_use.csv")


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



####
####
#### Merge in EV Subsidy Data ####
####
####




# Ensure 'date' column is in Date format in both datasets
ev_subsidies_daily <- ev_subsidies_daily %>%
  mutate(date = as.Date(date))

merged_data <- merged_data %>%
  mutate(date = as.Date(date))

# Merge ev_subsidies_daily into merged_data based on county and date
final_merged_data <- merged_data %>%
  left_join(ev_subsidies_daily, by = c("county", "date"))

# View first few rows of the merged dataset
head(final_merged_data)


####
####
#### Vehicles on the Road ####
####
####

Vehicle_Population_Last_updated_04_30_2024_ada <- Vehicle_Population_Last_updated_04_30_2024_ada %>%
  rename(year = `Data Year`) %>%
  rename(county = County)

final_merged_data <- final_merged_data %>%
  mutate(year = date_local_year)



# Ensure 'Data Year' and 'date_local_year' are numeric for merging
Vehicle_Population_Last_updated_04_30_2024_ada <- Vehicle_Population_Last_updated_04_30_2024_ada %>%
  mutate(year = as.integer(year))

final_merged_data <- final_merged_data %>%
  mutate(year = as.integer(year))

# Convert `Number of Vehicles` to numeric if needed
Vehicle_Population_Last_updated_04_30_2024_ada <- Vehicle_Population_Last_updated_04_30_2024_ada %>%
  mutate(`Number of Vehicles` = as.numeric(`Number of Vehicles`))  # Ensure it's numeric


Vehicle_Population_Last_updated_04_30_2024_ada <- Vehicle_Population_Last_updated_04_30_2024_ada %>%
  rename(fuel_type = `Fuel Type`, number_of_vehicles = `Number of Vehicles`) %>%
  select(year, county, fuel_type, number_of_vehicles)



# Handle NAs and ensure 'number_of_vehicles' is numeric
Vehicle_Population_Last_updated_04_30_2024_ada <- Vehicle_Population_Last_updated_04_30_2024_ada %>%
  mutate(
    fuel_type = replace_na(fuel_type, "Unknown"),  # Replace NA fuel types with "Unknown"
    number_of_vehicles = as.numeric(replace_na(number_of_vehicles, 0))  # Ensure numeric and replace NA with 0
  )

# First, group by year, county, and fuel_type to aggregate total vehicles
vehicle_population_grouped <- Vehicle_Population_Last_updated_04_30_2024_ada %>%
  group_by(year, county, fuel_type) %>%
  summarise(number_of_vehicles = sum(number_of_vehicles, na.rm = TRUE), .groups = 'drop')

# Now pivot to create separate columns for each fuel type
vehicle_population_wide <- vehicle_population_grouped %>%
  pivot_wider(
    names_from = fuel_type,   # Unique fuel types become new columns
    values_from = number_of_vehicles,   # Values to fill these columns
    values_fill = list(number_of_vehicles = 0)  # Fill missing values with 0
  )

# View the transformed data
head(vehicle_population_wide)


####
####
#### Merge vehicle population into dataset ####
####
####


# Ensure both datasets have matching data types for merging
vehicle_population_wide <- vehicle_population_wide %>%
  mutate(year = as.integer(year), county = as.character(county))

final_merged_data <- final_merged_data %>%
  mutate(year = as.integer(date_local_year), county = as.character(county))

# Merge vehicle population data into final_merged_data
final_merged_data <- final_merged_data %>%
  left_join(vehicle_population_wide, by = c("county", "year"))

# View first few rows of the merged dataset
head(final_merged_data)


write.csv(final_merged_data, "main_df_2_6.csv")


####
####
#### Farmland ####
####
####

ca_farmland_by_use <- ca_farmland_by_use %>%
  rename(county = County) %>%
  rename(acres = Value, category = Domain.Category, year = Year)




# Convert the 'county' column to title case
ca_farmland_by_use$county <- str_to_title(ca_farmland_by_use$county)


ca_farmland_by_use <- ca_farmland_by_use %>%
  select(year, county, category, acres)


# Convert 'acres' to numeric, remove commas, and replace NAs with 0
ca_farmland_by_use <- ca_farmland_by_use %>%
  mutate(acres = as.numeric(gsub(",", "", acres)),  # Remove commas and convert to numeric
         acres = ifelse(is.na(acres), 0, acres))  



# Step 1: Aggregate duplicate county-year-category rows by summing acres
ca_farmland_grouped <- ca_farmland_by_use %>%
  group_by(county, year, category) %>%
  summarise(acres = sum(acres, na.rm = TRUE), .groups = "drop")

# Step 2: Pivot to wide format: 'category' becomes columns, 'acres' fills values
ca_farmland_wide <- ca_farmland_grouped %>%
  pivot_wider(
    names_from = category,  # Column names from 'category'
    values_from = acres,    # Values from 'acres'
    values_fill = list(acres = 0)  # Fill missing values with 0
  )

# View the transformed dataset
head(ca_farmland_wide)


#####
#####
##### Merge farmland #####
#####
#####



# Convert 'year' to numeric in both datasets
final_merged_data <- final_merged_data %>%
  mutate(year = as.integer(date_local_year), county = as.character(county))

ca_farmland_wide <- ca_farmland_wide %>%
  mutate(year = as.integer(year), county = as.character(county))


ca_farmland_wide <- ca_farmland_wide %>%
  rename(Year_farmland = year)


# Ensure 'year' and 'Year_farmland' are integers
final_merged_data <- final_merged_data %>%
  mutate(year = as.integer(year), county = as.character(county))

ca_farmland_wide <- ca_farmland_wide %>%
  mutate(Year_farmland = as.integer(Year_farmland), county = as.character(county))

# Define the available farmland years
available_years <- c(2002, 2007, 2012, 2017, 2022)

# Function to find the closest year in available_years
find_closest_year <- function(year) {
  available_years[which.min(abs(available_years - year))]
}

# Apply the function to assign the closest Year_farmland for each year in final_merged_data
final_merged_data <- final_merged_data %>%
  mutate(Year_farmland = sapply(year, find_closest_year))  # Find the closest match

# Merge the datasets on county and matched Year_farmland
final_merged_data_2 <- final_merged_data %>%
  left_join(ca_farmland_wide, by = c("county", "Year_farmland"))

# View the merged dataset
head(merged_data)


#########
#########
######### Clean up panel dataset #########
#########
#########


panel_data <- final_merged_data_2 %>%
  select(-c(X.x, State.x, State.y, Unit.x, Unit.y, Multiplier.x, Multiplier.y))


# Remove rows where pollutant_standard is "NO2 Annual 1971"
panel_data <- panel_data %>%
  filter(pollutant_standard != "NO2 Annual 1971")

# View the updated dataset
head(panel_data)

write.csv(panel_data, "panel_data.csv")
