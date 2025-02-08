
# Load necessary libraries
library(ggplot2)
library(maps)
library(dplyr)

# Step 1: Get California County Map Data
county_map <- map_data("county") %>%
  filter(region == "california")

# Step 2: Ensure latitude and longitude in `panel_data` are numeric
panel_data <- panel_data %>%
  mutate(latitude = as.numeric(latitude),
         longitude = as.numeric(longitude))

# Step 3: Plot the California county boundaries and overlay points
ggplot() +
  # Plot county boundaries
  geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
               fill = "gray90", color = "black", alpha = 0.5) +
  
  # Overlay latitude/longitude points from panel_data
  geom_point(data = panel_data, aes(x = longitude, y = latitude), 
             color = "red", alpha = 0.6, size = 1) +
  
  # Labels and styling
  labs(title = "Panel Data Points Overlaid on California Map",
       x = "Longitude", y = "Latitude") +
  
  theme_minimal()
