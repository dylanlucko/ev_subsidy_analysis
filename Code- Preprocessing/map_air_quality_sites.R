

library(dplyr)
library(ggplot2)
library(maps)

# Extract unique site locations
site_locations <- panel_data_did %>%
  select(latitude, longitude, site_number) %>%
  distinct()


# Load California county map data
county_map <- map_data("county") %>%
  filter(region == "california")


# Plot all unique air quality monitoring sites with county overlay
ggplot() +
  geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
               fill = "gray90", color = "black", alpha = 0.5) +  # County boundaries
  
  geom_point(data = site_locations, aes(x = longitude, y = latitude), 
             color = "red", alpha = 0.7, size = 2) +  # Site locations
  
  labs(
    title = "Air Quality Monitoring Sites Across California",
    x = "Longitude",
    y = "Latitude"
  ) +
  
  theme_minimal()
