

ev_subsidies_per_day_2010_2023 <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/ev_subsidies_per_day_2010_2023.xlsx")

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


# Install package if needed
install.packages("zipcodeR")

# Load the package
library(zipcodeR)


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
library(dplyr)
library(tidyr)

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
threshold <- 0.25  # Adjust as needed

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


library(ggplot2)
library(maps)

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


library(dplyr)

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
threshold <- 0.25  

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


library(ggplot2)
library(maps)

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
    title = "EV Adoption: Treatment vs. Control at the ZIP Level",
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


library(geosphere)

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

# Merge treatment assignments back into panel_data
panel_data <- panel_data %>%
  left_join(site_treatment_data, by = c("latitude", "longitude", "site_number"))

# View the dataset with assigned treatment status
head(panel_data)

colnames(panel_data)
panel_data <- panel_data %>%
  rename(Treatment_zip = Treatment.y, Treatment_county = Treatment.x)

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
    title = "Air Quality Monitoring Sites: Treatment vs. Control by ZIP",
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
