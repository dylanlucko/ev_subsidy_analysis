

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


###############
###############
############### Include Lat Long Analysis for Zip Level EV Adoption ########
###############
###############



# Source the preamble script to load necessary functions and libraries
source("C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/Data Preprocessing Code/preamble.R")


length(unique(ev_subsidies_per_day_2010_2023$County))
#58

length(unique(ev_subsidies_per_day_2010_2023$ZIP))
#1873

# not the same granularity. 

colnames(ev_subsidies_per_day_2010_2023)


#####
#####
##### Relate Zip code to range of lat long for comparison with lat-long-site metric
#####
#####


# Get unique ZIP codes from ev_subsidies_per_day_2010_2023
zip_list <- unique(ev_subsidies_per_day_2010_2023$ZIP)

# Retrieve lat/long for all ZIPs
zip_data <- lapply(zip_list, reverse_zipcode) %>% bind_rows()

head(zip_data)  # Now we have ZIP, lat, and long


##### Merge back into ev subsidy data

# Ensure ZIP codes are formatted as characters
ev_subsidies_per_day_2010_2023 <- ev_subsidies_per_day_2010_2023 %>%
  mutate(ZIP = as.character(ZIP))

zip_data <- zip_data %>%
  select(zipcode, lat, lng) %>%
  rename(zip_lat = lat, zip_long = lng, ZIP = zipcode)

# Merge ZIP lat/long into the EV subsidies dataset
ev_subsidies_per_day_2010_2023 <- ev_subsidies_per_day_2010_2023 %>%
  left_join(zip_data, by = "ZIP")


#####
#####
##### Assign treatment and control at the zip level #####
#####
#####


ev_subsidies_per_day_2010_2023 <- ev_subsidies_per_day_2010_2023 %>%
  rename(Application.Date = `Application Date`, Rebate.Dollars = `Rebate Dollars`, Vehicle.Make = `Vehicle Make`, Vehicle.Category = `Vehicle Category`, Low.Income.Community = `Low-Income Community`)


# Extract Year from Date & Aggregate at (zip_lat, zip_long) level
ev_subsidies_per_location <- ev_subsidies_per_day_2010_2023 %>%
  mutate(year = as.integer(format(as.Date(Application.Date, format="%Y-%m-%d"), "%Y"))) %>%
  group_by(zip_lat, zip_long, year) %>%
  summarise(
    total_rebates = n(),  # Total EV rebates per ZIP coordinate per year
    total_dollars = sum(Rebate.Dollars, na.rm = TRUE),  # Total rebate amount
    low_income_rebates = sum(`Low-/Moderate-Income Increased Rebate`, na.rm = TRUE),
    public_fleet_rebates = sum(`Increased Rebates for Public Fleets in DACs`, na.rm = TRUE),
    .groups = "drop"
  )

#


# Define treatment threshold (e.g., 50% increase)
threshold <- 0.5  # Adjust as needed

# Get 2010 & 2011 data
baseline_2010 <- ev_subsidies_per_location %>%
  filter(year == 2011) %>%
  select(zip_lat, zip_long, total_rebates, total_dollars) %>%
  rename(base_rebates = total_rebates, base_dollars = total_dollars)

comparison_2011 <- ev_subsidies_per_location %>%
  filter(year == 2015) %>%
  select(zip_lat, zip_long, total_rebates, total_dollars) %>%
  rename(rebates_2011 = total_rebates, dollars_2011 = total_dollars)

# Merge 2010 and 2011 data
ev_growth <- baseline_2010 %>%
  left_join(comparison_2011, by = c("zip_lat", "zip_long")) %>%
  mutate(
    rebate_growth = (rebates_2011 - base_rebates) / (base_rebates + 1),  # Avoid division by zero
    dollar_growth = (dollars_2011 - base_dollars) / (base_dollars + 1),
    Treatment = ifelse(rebate_growth > threshold | dollar_growth > threshold, 1, 0)  # Define Treatment
  )


# Merge treatment status back into ev_subsidies_per_location
ev_subsidies_per_location <- ev_subsidies_per_location %>%
  left_join(ev_growth %>% select(zip_lat, zip_long, Treatment), by = c("zip_lat", "zip_long"))




# Load California county map
county_map <- map_data("county") %>%
  filter(region == "california")

# Ensure `zip_lat`, `zip_long`, and `Treatment` are formatted correctly
ev_subsidies_per_location <- ev_subsidies_per_location %>%
  mutate(zip_lat = as.numeric(zip_lat),
         zip_long = as.numeric(zip_long),
         Treatment = as.factor(Treatment))  # Convert to factor for color mapping

# Plot California counties with ZIP coordinate-level treatment vs. control
ggplot() +
  # Add county boundaries
  geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
               fill = "gray90", color = "black", alpha = 0.5) +
  
  # Overlay ZIP lat-long points, colored by Treatment
  geom_point(data = ev_subsidies_per_location, aes(x = zip_long, y = zip_lat, color = Treatment), 
             alpha = 0.7, size = 2) +
  
  # Define Treatment vs. Control colors
  scale_color_manual(values = c("0" = "blue", "1" = "red"), labels = c("Control", "Treatment")) +
  
  # Labels and styling
  labs(title = "EV Adoption: Treatment vs. Control at the ZIP Coordinate Level (2010-2011 Growth)",
       x = "Longitude", y = "Latitude", color = "Group") +
  theme_minimal()



##### 
#####
##### Attempt 2 #####
#####
#####



# Extract Year from Date & Aggregate at ZIP level
ev_subsidies_per_zip <- ev_subsidies_per_day_2010_2023 %>%
  mutate(year = as.integer(format(as.Date(Application.Date, format="%Y-%m-%d"), "%Y"))) %>%
  group_by(ZIP, year) %>%
  summarise(
    total_rebates = n(),  # Total EV rebates per ZIP per year
    total_dollars = sum(Rebate.Dollars, na.rm = TRUE),  # Total rebate amount
    low_income_rebates = sum(`Low-/Moderate-Income Increased Rebate`, na.rm = TRUE),
    public_fleet_rebates = sum(`Increased Rebates for Public Fleets in DACs`, na.rm = TRUE),
    zip_lat = first(zip_lat),  # Retain ZIP centroid lat/long
    zip_long = first(zip_long),
    .groups = "drop"
  )


#

# Define treatment threshold (e.g., 20% increase)
threshold <- 0.5  

# Get 2011 baseline values per ZIP
baseline_2011 <- ev_subsidies_per_zip %>%
  filter(year == 2011) %>%
  select(ZIP, total_rebates, total_dollars) %>%
  rename(base_rebates = total_rebates, base_dollars = total_dollars)

# Get 2015 comparison values per ZIP
comparison_2015 <- ev_subsidies_per_zip %>%
  filter(year == 2012) %>%
  select(ZIP, total_rebates, total_dollars) %>%
  rename(rebates_2015 = total_rebates, dollars_2015 = total_dollars)

# Merge 2011 and 2015 data
ev_growth <- baseline_2011 %>%
  full_join(comparison_2015, by = "ZIP") %>%  # Include all ZIPs
  mutate(
    base_rebates = replace_na(base_rebates, 0),  # Handle missing 2011 values
    base_dollars = replace_na(base_dollars, 0),
    rebates_2015 = replace_na(rebates_2015, 0),  # Handle missing 2015 values
    dollars_2015 = replace_na(dollars_2015, 0),
    rebate_growth = (rebates_2015 - base_rebates) / (base_rebates + 1),  # Avoid division by zero
    dollar_growth = (dollars_2015 - base_dollars) / (base_dollars + 1),
    Treatment = ifelse(rebate_growth > threshold | dollar_growth > threshold, 1, 0)  # Define Treatment
  )


#

# Merge treatment status back into ev_subsidies_per_zip
ev_subsidies_per_zip <- ev_subsidies_per_zip %>%
  left_join(ev_growth %>% select(ZIP, Treatment), by = "ZIP") %>%
  mutate(Treatment = replace_na(Treatment, 0))  # Ensure no NA values



# Load California county map
county_map <- map_data("county") %>%
  filter(region == "california")

# Ensure `zip_lat`, `zip_long`, and `Treatment` are formatted correctly
ev_subsidies_per_zip <- ev_subsidies_per_zip %>%
  mutate(Treatment = as.factor(Treatment))

# Plot with explicit legend settings
ggplot() +
  # Add California county boundaries
  geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
               fill = "gray90", color = "black", alpha = 0.5) +
  
  # Overlay ZIP-level treatment vs. control points
  geom_point(data = ev_subsidies_per_zip, aes(x = zip_long, y = zip_lat, color = Treatment), 
             alpha = 0.7, size = 2) +
  
  # Define Treatment vs. Control colors & ensure legend appears
  scale_color_manual(
    values = c("0" = "blue", "1" = "red"), 
    labels = c("Control", "Treatment"), 
    name = "Treatment Group"  # Legend title
  ) +
  
  # Labels and styling
  labs(
    title = "EV Adoption: Treatment vs. Control at the ZIP Level (50%)",
    x = "Longitude", 
    y = "Latitude"
  ) +
  
  # Ensure the legend is displayed
  theme_minimal() +
  theme(legend.position = "right")  # Ensures legend is visible


#####
#####
##### Attempt 3: Use Ratio of EVs to ICE #####
#####
#####


#####
#####
##### Relate Zip treatment and control to no2 sites #####
#####
##### 

# Convert ZIP codes to character format to ensure compatibility
ev_subsidies_per_zip <- ev_subsidies_per_zip %>%
  mutate(ZIP = as.character(ZIP))

zip_latlong_data <- zip_latlong_data %>%
  rename(ZIP = zipcode)

zip_latlong_data <- zip_latlong_data %>%
  mutate(ZIP = as.character(ZIP))


convert_zip_to_latlong <- function(zip_list) {
  zip_data <- lapply(zip_list, function(zip) {
    tryCatch({
      reverse_zipcode(zip)  # Fetch ZIP lat/long
    }, error = function(e) {
      return(data.frame(ZIP = zip, lat = NA, lng = NA))  # Handle errors
    })
  }) %>% bind_rows()
  return(zip_data)
}

# Fetch lat-long for ZIPs again
zip_latlong_data <- convert_zip_to_latlong(zip_list)

zip_latlong_data <- zip_latlong_data %>%
  rename(ZIP = zipcode)

colnames(ev_subsidies_per_zip)  # Check existing column names
colnames(zip_latlong_data)  # Check ZIP coordinate data


# Remove existing zip_lat and zip_long columns before merging to avoid conflicts
ev_subsidies_per_zip <- ev_subsidies_per_zip %>%
  select(-zip_lat, -zip_long)  # Remove duplicates if they exist


# Rename ZIP column in zip_latlong_data
zip_latlong_data <- zip_latlong_data %>%
  rename(ZIP = zipcode)

# Perform the merge
ev_subsidies_per_zip <- ev_subsidies_per_zip %>%
  left_join(zip_latlong_data, by = "ZIP") %>%
  rename(zip_lat = lat, zip_long = lng)


##
##

# Extract unique air quality monitoring site locations
site_locations <- panel_data %>%
  select(latitude, longitude, site_number) %>%
  distinct()



panel_data <- panel_data %>%
  select(-c(nearest_zip.x, nearest_zip.y, Treatment_zip))
colnames(panel_data)

# Function to find the nearest ZIP for each air quality site
find_nearest_zip <- function(site_lat, site_long, zip_df) {
  distances <- distHaversine(matrix(c(site_long, site_lat), ncol = 2), 
                             matrix(c(zip_df$zip_long, zip_df$zip_lat), ncol = 2))
  closest_zip_idx <- which.min(distances)  # Find index of closest ZIP
  return(zip_df[closest_zip_idx, c("ZIP", "Treatment")])  # Return closest ZIP & its treatment status
}

# Assign each air quality site the closest ZIP and its Treatment status
site_treatment_data <- site_locations %>%
  rowwise() %>%
  mutate(closest_zip_info = list(find_nearest_zip(latitude, longitude, ev_subsidies_per_zip))) %>%
  unnest_wider(closest_zip_info) %>%
  rename(nearest_zip = ZIP, Treatment = Treatment) %>%
  ungroup()


panel_data <- panel_data %>%
  select(-c(nearest_zip.x, nearest_zip.y, nearest_zip, Treatment.x, Treatment.y, Treatment_zip))

panel_data <- panel_data %>%
  select(-c(Treatment_county, Treatment_zip, Treatment))

colnames(panel_data)

panel_data <- panel_data %>%
  select(-c(Treatment_zip))

panel_data <- panel_data %>%
  select(-c(Treatment.x, Treatment.y))


# Merge treatment assignments back into panel_data
panel_data <- panel_data %>%
  left_join(site_treatment_data, by = c("latitude", "longitude", "site_number"))

# View the dataset with assigned treatment status
head(panel_data)
# .y, Treatment_county = Treatment
colnames(panel_data)
panel_data <- panel_data %>%
  rename(Treatment_zip = Treatment)

##
##
## Plot ##
##
##


# Load California county map data
county_map <- map_data("county") %>%
  filter(region == "california")

# Ensure Treatment_zip and latitude/longitude are numeric and properly formatted
panel_data <- panel_data %>%
  mutate(
    latitude = as.numeric(latitude),
    longitude = as.numeric(longitude),
    Treatment_zip = as.factor(Treatment_zip)  # Convert to factor for coloring
  )


# Plot California counties with air quality sites colored by Treatment status
ggplot() +
  # Add county boundaries
  geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
               fill = "gray90", color = "black", alpha = 0.5) +
  
  # Overlay air quality monitoring sites with treatment vs. control colors
  geom_point(data = panel_data, aes(x = longitude, y = latitude, color = Treatment_zip), 
             alpha = 0.7, size = 2) +
  
  # Define Treatment vs. Control colors
  scale_color_manual(
    values = c("0" = "blue", "1" = "red"),
    labels = c("Control", "Treatment"),
    name = "Treatment Status"
  ) +
  
  # Labels and styling
  labs(
    title = "Air Quality Monitoring Sites: Treatment vs. Control by ZIP (50%)",
    x = "Longitude", 
    y = "Latitude",
    color = "Treatment Status"
  ) +
  
  theme_minimal()


# Ensure Treatment_zip is numeric or factor
panel_data <- panel_data %>%
  mutate(Treatment_zip = as.factor(Treatment_zip))  # Convert to factor if needed

# Count the number of treatment and control points
treatment_counts <- panel_data %>%
  group_by(Treatment_zip) %>%
  summarise(count = n())

# Print the counts
print(treatment_counts)



# Count unique (latitude, longitude, site_number) locations
unique_sites <- panel_data %>%
  distinct(latitude, longitude, site_number, Treatment_zip) %>%
  group_by(Treatment_zip) %>%
  summarise(count = n())

# Print the counts
print(unique_sites)


write.csv(panel_data, "panel_data_2_9.csv")

###############
###############
############### Update Panel Data ##########
###############
###############

# Source the preamble script to load necessary functions and libraries
source("C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/Data Preprocessing Code/preamble.R")


panel_data_did <- read.csv("~/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/panel_data_2_9.csv")


colnames(panel_data_did)
colnames(fertilizers_by_type_by_county_2016)


# Rename columns: Replace "." with "_" and rename COUNTY to county
fertilizers_by_type_by_county_2016 <- fertilizers_by_type_by_county_2016 %>%
  rename_with(~ gsub("\\.", "_", .x)) %>%
  rename(county = COUNTY)

unique(fertilizers_by_type_by_county_2016$county)


# Capitalize the first letter of each county name
fertilizers_by_type_by_county_2016 <- fertilizers_by_type_by_county_2016 %>%
  mutate(county = str_to_title(county))  # Capitalizes first letter of each word


# Create a named vector for correcting county names
county_corrections <- c(
  "San Bernardi" = "San Bernardino",
  "San Francisc" = "San Francisco",
  "San Luis Obisp" = "San Luis Obispo",
  "Santa Barbar" = "Santa Barbara"
)


# Replace truncated county names with correct ones
fertilizers_by_type_by_county_2016 <- fertilizers_by_type_by_county_2016 %>%
  mutate(county = recode(county, !!!county_corrections))


# Check which counties are still mismatched
mismatched_counties <- setdiff(fertilizers_by_type_by_county_2016$county, panel_data_did$county)

print("Counties in fertilizer data that do NOT match panel_data_did:")
print(mismatched_counties)
unique(panel_data_did$county)


# Merge fertilizer data into panel_data_did by county
panel_data_did <- panel_data_did %>%
  left_join(fertilizers_by_type_by_county_2016, by = "county")

colnames(panel_data_did)

unique(panel_data_did$UREA)

write.csv(panel_data_did, "panel_data_did_2_13.csv")
