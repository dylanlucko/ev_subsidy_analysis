

Vehicle_Population_Last_updated_04_30_2024_ada <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/Vehicle_Population_Last_updated_04-30-2024_ada.xlsx", sheet = "County")

colnames(Vehicle_Population_Last_updated_04_30_2024_ada)


library(dplyr)
library(ggplot2)
library(maps)
library(scales)

vehicle_data <- Vehicle_Population_Last_updated_04_30_2024_ada

# Rename columns for consistency
vehicle_data <- vehicle_data %>%
  rename(
    year = `Data Year`,
    county = `County`,
    fuel_type = `Fuel Type`,
    num_vehicles = `Number of Vehicles`
  ) %>%
  mutate(
    county = tolower(county),  # Convert county names to lowercase for matching
    num_vehicles = as.numeric(num_vehicles)  # Ensure numeric values
  )

# Filter for 2010 and summarize total vehicles per county
vehicle_county_2010 <- vehicle_data %>%
  filter(year == 2010) %>%
  group_by(county) %>%
  summarise(total_vehicles = sum(num_vehicles, na.rm = TRUE), .groups = "drop")


# Load California county map data
county_map <- map_data("county") %>%
  filter(region == "california") %>%
  mutate(subregion = tolower(subregion))  # Convert county names to lowercase for matching

# Merge county map with vehicle count data
county_map_vehicles <- county_map %>%
  left_join(vehicle_county_2010, by = c("subregion" = "county"))



# Plot the county-level vehicle distribution
ggplot(county_map_vehicles, aes(x = long, y = lat, group = group, fill = total_vehicles)) +
  geom_polygon(color = "black", size = 0.2) +  # County boundaries
  scale_fill_gradient(low = "lightyellow", high = "#107a2c", na.value = "white", 
                      name = "Total Vehicles", labels = comma_format()) +  # Format legend with commas
  labs(
    title = "Total Vehicles by County in California (2010)",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal() +
  theme(legend.position = "right")
