

New_ZEV_Sales_Last_updated_01_31_2025_ada <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/New_ZEV_Sales_Last_updated_01-31-2025_ada.xlsx", sheet = "ZIP")

colnames(New_ZEV_Sales_Last_updated_01_31_2025_ada)


library(dplyr)
library(ggplot2)
library(scales)
library(zipcodeR)  # For ZIP coordinate mapping
library(maps)
library(gridExtra)

# Ensure ZIP is a character
New_ZEV_Sales_Last_updated_01_31_2025_ada <- New_ZEV_Sales_Last_updated_01_31_2025_ada %>%
  mutate(ZIP = as.character(ZIP))

# Summarize total vehicles per Data Year, ZIP, and Fuel Type
vehicle_summary <- New_ZEV_Sales_Last_updated_01_31_2025_ada %>%
  group_by(Data_Year, ZIP, FUEL_TYPE) %>%
  summarise(total_vehicles = sum(`Number of Vehicles`, na.rm = TRUE), .groups = "drop")


# Summarize total vehicles per year across all ZIPs
total_vehicles_yearly <- vehicle_summary %>%
  group_by(Data_Year, FUEL_TYPE) %>%
  summarise(total_vehicles = sum(total_vehicles, na.rm = TRUE), .groups = "drop")

# Plot total vehicles over time
ggplot(total_vehicles_yearly, aes(x = Data_Year, y = total_vehicles, color = FUEL_TYPE)) +
  geom_line(size = 1) +
  scale_x_continuous(breaks = seq(min(total_vehicles_yearly$Data_Year), max(total_vehicles_yearly$Data_Year), by = 1)) +
  scale_y_continuous(labels = comma) +  # Format y-axis with commas
  labs(
    title = "Total Vehicles Over Time by Fuel Type",
    x = "Year",
    y = "Total Vehicles",
    color = "Fuel Type"
  ) +
  theme_minimal()


# Extract unique ZIP codes
zip_list <- unique(vehicle_summary$ZIP)

# Retrieve latitude and longitude for each ZIP
zip_latlong_data <- zipcodeR::reverse_zipcode(zip_list)

# Merge ZIP coordinates with vehicle data
vehicle_summary <- vehicle_summary %>%
  left_join(zip_latlong_data %>% rename(ZIP = zipcode, zip_lat = lat, zip_long = lng), by = "ZIP")


# Load California county map
county_map <- map_data("county") %>%
  filter(region == "california")

# Find global min and max vehicle counts for scale consistency
global_min <- min(vehicle_summary$total_vehicles, na.rm = TRUE)
global_max <- max(vehicle_summary$total_vehicles, na.rm = TRUE)

# Define a function to plot vehicle distribution by ZIP
plot_vehicle_map <- function(data, year) {
  ggplot() +
    geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
                 fill = "gray90", color = "black", alpha = 0.5) +
    geom_point(data = data, aes(x = zip_long, y = zip_lat, color = total_vehicles), 
               alpha = 0.7, size = 2) +  
    scale_color_gradient(low = "lightblue", high = "darkblue", name = "Total Vehicles",
                         limits = c(global_min, global_max)) +  # Use common scale
    labs(
      title = paste("New EV Sales by ZIP in", year),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
}


# Filter data for the years of interest
vehicle_2010 <- vehicle_summary %>% filter(Data_Year == 2010)
#vehicle_2012 <- vehicle_summary %>% filter(Data_Year == 2012)
vehicle_2015 <- vehicle_summary %>% filter(Data_Year == 2016)

# Generate plots
plot_2010 <- plot_vehicle_map(vehicle_2010, 2010)
#plot_2012 <- plot_vehicle_map(vehicle_2012, 2012)
plot_2015 <- plot_vehicle_map(vehicle_2015, 2016)

# Arrange plots side by side
grid.arrange(plot_2010, plot_2015, ncol = 2)
