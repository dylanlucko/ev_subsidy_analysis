
library(ggplot2)
library(maps)
library(dplyr)

# Load California county map
county_map <- map_data("county") %>%
  filter(region == "california")

# Ensure `low_income_rebates` and ZIP lat/long are numeric
ev_subsidies_per_zip <- ev_subsidies_per_zip %>%
  mutate(
    zip_lat = as.numeric(zip_lat),
    zip_long = as.numeric(zip_long),
    low_income_rebates = as.numeric(low_income_rebates),  # Ensure numeric for gradient
    opacity = scales::rescale(low_income_rebates, to = c(0.3, 1))  # Normalize opacity (0.3 - 1)
  )

# Plot ZIP locations with gradient color representing low-income rebates and opacity for visibility
ggplot() +
  # Add California county boundaries
  geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
               fill = "gray90", color = "black", alpha = 0.5) +
  
  # Overlay ZIP points with color and opacity mapped to `low_income_rebates`
  geom_point(data = ev_subsidies_per_zip, aes(x = zip_long, y = zip_lat, 
                                              color = low_income_rebates, alpha = opacity), 
             size = 2) +
  
  # Define gradient color scale for low-income rebates
  scale_color_gradient(low = "lightblue", high = "red", name = "Low-Income Rebates") +
  
  # Ensure opacity values are properly applied
  scale_alpha(range = c(0.1, 1), guide = "none") +  # Lower amounts are more transparent
  
  # Labels and styling
  labs(
    title = "Low-Income EV Rebates Across ZIP Codes in California",
    x = "Longitude", 
    y = "Latitude"
  ) +
  
  theme_minimal()


#####
#####
##### Zoom in on LA, San Diego, San Francisco, and Sacramento #####
#####



# Define boundaries for each city
city_bounds <- list(
  "Los Angeles" = list(lat_min = 33.5, lat_max = 34.4, long_min = -119, long_max = -117.5),
  "San Diego" = list(lat_min = 32.5, lat_max = 33.2, long_min = -117.5, long_max = -116.5),
  "San Francisco" = list(lat_min = 37.6, lat_max = 37.9, long_min = -123, long_max = -122),
  "Sacramento" = list(lat_min = 38.4, lat_max = 38.7, long_min = -121.7, long_max = -121.2)
)


library(ggplot2)
library(maps)
library(dplyr)

# Load California county map
county_map <- map_data("county") %>%
  filter(region == "california")

# Function to create a zoomed-in plot for a specific city
plot_city <- function(city_name, bounds) {
  # Filter data within city boundaries
  city_data <- ev_subsidies_per_zip %>%
    filter(zip_lat >= bounds$lat_min, zip_lat <= bounds$lat_max,
           zip_long >= bounds$long_min, zip_long <= bounds$long_max)
  
  # Create plot
  ggplot() +
    # Add county boundaries
    geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
                 fill = "gray90", color = "black", alpha = 0.5) +
    
    # Overlay ZIP points with color gradient for low-income rebates
    geom_point(data = city_data, aes(x = zip_long, y = zip_lat, 
                                     color = low_income_rebates, alpha = opacity), 
               size = 2) +
    
    # Define color gradient and opacity scale
    scale_color_gradient(low = "lightblue", high = "red", name = "Low-Income Rebates") +
    scale_alpha(range = c(0.3, 1), guide = "none") +
    
    # Labels and title
    labs(
      title = paste("Low-Income EV Rebates in", city_name),
      x = "Longitude", 
      y = "Latitude"
    ) +
    
    # Set zoom limits
    coord_cartesian(xlim = c(bounds$long_min, bounds$long_max), 
                    ylim = c(bounds$lat_min, bounds$lat_max)) +
    
    theme_minimal()
}

# Generate plots for each city
plot_LA <- plot_city("Los Angeles", city_bounds$"Los Angeles")
plot_SD <- plot_city("San Diego", city_bounds$"San Diego")
plot_SF <- plot_city("San Francisco", city_bounds$"San Francisco")
plot_Sac <- plot_city("Sacramento", city_bounds$"Sacramento")


library(gridExtra)

# Arrange all plots in a 2x2 grid
grid.arrange(plot_LA, plot_SD, plot_SF, plot_Sac, ncol = 2)

# Data above are for the entire data range ... please note. 
