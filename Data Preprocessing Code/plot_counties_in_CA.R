


# Load necessary libraries
library(dplyr)
library(ggplot2)

# Define file path
boundary_path <- "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache/California_County_Boundaries_9101614255844818638.csv"

# Read in the CSV file
ca_counties <- read.csv(boundary_path, stringsAsFactors = FALSE)

# Preview the data
head(ca_counties)


# Load a built-in county dataset from maps package
library(maps)

# Get California county map data
county_map <- map_data("county") %>%
  filter(region == "california") %>%
  rename(county = subregion)

# Ensure county names are in the same format
ca_counties <- ca_counties %>%
  mutate(county = tolower(COUNTY_NAME))  # Make county names lowercase for joining

# Merge with map data
ca_county_map <- left_join(county_map, ca_counties, by = "county")

# Check merged data
head(ca_county_map)


####################
####################


# Check duplicate counties in ca_counties
ca_counties %>%
  count(county) %>%
  filter(n > 1)


# Ensure ca_counties has unique county names before merging
ca_counties_unique <- ca_counties %>%
  group_by(county) %>%
  summarise(across(everything(), first)) %>%  # Keep the first occurrence
  ungroup()


# Merge cleaned county data with map data
ca_county_map <- left_join(county_map, ca_counties_unique, by = "county")


# Plot county boundaries and overlay Treatment vs. Control points
ggplot() +
  geom_polygon(data = ca_county_map, aes(x = long, y = lat, group = group), 
               fill = "gray90", color = "black", alpha = 0.5) +  # County outlines
  
  # Overlay Treatment vs. Control points
  geom_point(data = panel_data, aes(x = longitude, y = latitude, color = factor(Treatment)), 
             alpha = 0.6, size = 2) +
  
  # Define colors
  scale_color_manual(values = c("0" = "blue", "1" = "red"), labels = c("Control", "Treatment")) +
  
  # Labels and styling
  labs(title = "EV Treatment vs. Control in California",
       x = "Longitude", y = "Latitude", color = "Group") +
  
  theme_minimal()

