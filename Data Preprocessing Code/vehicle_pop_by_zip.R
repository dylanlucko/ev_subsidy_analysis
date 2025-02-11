
library(dplyr)
library(ggplot2)
library(scales)

vehicle_data <- Vehicle_Population_Last_updated_04_30_2024_ada


library(dplyr)
library(ggplot2)

# Rename columns for consistency
vehicle_data <- vehicle_data %>%
  rename(
    year = `Data Year`,
    fuel_type = `Fuel Type`,
    zip_code = `ZIP`,
    num_vehicles = `Number of Vehicles`
  )


# Summarize total vehicles per ZIP in 2010
zip_vehicles_2010 <- vehicle_data %>%
  filter(year == 2010) %>%
  group_by(zip_code) %>%
  summarise(total_vehicles = sum(num_vehicles, na.rm = TRUE), .groups = "drop")

# Summarize total vehicles per ZIP in 2016
zip_vehicles_2016 <- vehicle_data %>%
  filter(year == 2016) %>%
  group_by(zip_code) %>%
  summarise(total_vehicles = sum(num_vehicles, na.rm = TRUE), .groups = "drop")


install.packages("zipcodeR")  # Install if not already installed
library(zipcodeR)

vehicle_data <- vehicle_data %>%
  rename(ZIP = zip_code)

# Extract unique ZIP codes from the dataset
zip_list <- unique(vehicle_data$ZIP)

# Retrieve latitude and longitude for each ZIP
zip_latlong_data <- zipcodeR::reverse_zipcode(zip_list)

# Check the structure of the retrieved data
head(zip_latlong_data)


library(dplyr)

# Convert ZIP codes to character in both datasets
zip_vehicles_2010 <- zip_vehicles_2010 %>%
  mutate(zip_code = as.character(zip_code))

zip_latlong_data <- zip_latlong_data %>%
  mutate(zip_code = as.character(zip_code))

# Merge ZIP coordinates with vehicle data for 2010
zip_vehicles_2010 <- zip_vehicles_2010 %>%
  left_join(zip_latlong_data, by = "zip_code")


# Convert ZIP codes to character
zip_vehicles_2016 <- zip_vehicles_2016 %>%
  mutate(zip_code = as.character(zip_code))

# Merge ZIP coordinates with vehicle data for 2016
zip_vehicles_2016 <- zip_vehicles_2016 %>%
  left_join(zip_latlong_data, by = "zip_code")


library(ggplot2)

# Plot for 2010
ggplot(zip_vehicles_2010, aes(x = zip_long, y = zip_lat, color = total_vehicles)) +
  geom_point(alpha = 0.7, size = 2) +
  scale_color_gradient(low = "lightblue", high = "darkblue", name = "Total Vehicles") +
  labs(
    title = "Total Vehicles by ZIP in 2010",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal()

# Plot for 2016
ggplot(zip_vehicles_2016, aes(x = zip_long, y = zip_lat, color = total_vehicles)) +
  geom_point(alpha = 0.7, size = 2) +
  scale_color_gradient(low = "lightblue", high = "darkblue", name = "Total Vehicles") +
  labs(
    title = "Total Vehicles by ZIP in 2016",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal()

#####
##### BEV BEV BEV BEV
#####
#####


library(dplyr)
library(ggplot2)
library(scales)


vehicle_data <- Vehicle_Population_Last_updated_04_30_2024_ada


# Rename columns for consistency
vehicle_data <- vehicle_data %>%
  rename(
    year = `Data Year`,
    fuel_type = `Fuel Type`,
    zip_code = `ZIP`,
    num_vehicles = `Number of Vehicles`
  )


# Summarize total vehicles per ZIP in 2010
zip_vehicles_2010 <- vehicle_data %>%
  filter(year == 2010) %>%
  group_by(zip_code, fuel_type) %>%
  summarise(total_vehicles = sum(num_vehicles, na.rm = TRUE), .groups = "drop")

# Summarize total vehicles per ZIP in 2016
zip_vehicles_2016 <- vehicle_data %>%
  filter(year == 2016) %>%
  group_by(zip_code, fuel_type) %>%
  summarise(total_vehicles = sum(num_vehicles, na.rm = TRUE), .groups = "drop")



# Ensure ZIP codes are characters for merging
zip_vehicles_2010 <- zip_vehicles_2010 %>%
  mutate(zip_code = as.character(zip_code))

zip_vehicles_2016 <- zip_vehicles_2016 %>%
  mutate(zip_code = as.character(zip_code))

zip_latlong_data <- zip_latlong_data %>%
  mutate(zip_code = as.character(zip_code))

# Merge ZIP coordinates with vehicle data for BEV in 2010 and 2016
bev_2010 <- zip_vehicles_2010 %>%
  filter(fuel_type == "Battery Electric (BEV)") %>%
  left_join(zip_latlong_data, by = "zip_code")

bev_2016 <- zip_vehicles_2016 %>%
  filter(fuel_type == "Battery Electric (BEV)") %>%
  left_join(zip_latlong_data, by = "zip_code")

# Load California county map
county_map <- map_data("county") %>%
  filter(region == "california")
# Ensure the scale is the same by finding global min/max BEV values across both years
bev_min <- min(c(bev_2010$total_vehicles, bev_2016$total_vehicles), na.rm = TRUE)
bev_max <- max(c(bev_2010$total_vehicles, bev_2016$total_vehicles), na.rm = TRUE)

# Define function to plot BEV distribution using color scale
plot_bev_distribution <- function(data, year) {
  ggplot() +
    geom_polygon(data = county_map, aes(x = long, y = lat, group = group), 
                 fill = "gray90", color = "black", alpha = 0.5) +
    geom_point(data = data, aes(x = zip_long, y = zip_lat, color = total_vehicles), 
               alpha = 0.7, size = 2) +  # Fixed dot size
    scale_color_gradient(low = "lightblue", high = "red", name = "BEV Count",
                         limits = c(bev_min, bev_max)) +  # Ensure same scale for both years
    labs(
      title = paste("BEV by ZIP in", year),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal()
}

# Plot BEV distribution for 2010 and 2016
plot_2010 <- plot_bev_distribution(bev_2010, 2010)
plot_2016 <- plot_bev_distribution(bev_2016, 2016)

# Arrange both plots side by side
grid.arrange(plot_2010, plot_2016, ncol = 2)

