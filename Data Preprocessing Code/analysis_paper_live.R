
library(dplyr)

# Count unique latitude-longitude site locations
unique_sites_count <- panel_data_did %>%
  distinct(latitude, longitude, site_number) %>%
  nrow()

# Print result
print(paste("Number of unique site locations:", unique_sites_count))


###############
###############

library(dplyr)
library(lubridate)
library(ggplot2)
library(tidyr)

Vehicle_Population_Last_updated_04_30_2024_ada <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/Vehicle_Population_Last_updated_04-30-2024_ada.xlsx", sheet = "County")

colnames(Vehicle_Population_Last_updated_04_30_2024_ada)


library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
vehicle_data <- Vehicle_Population_Last_updated_04_30_2024_ada

# Rename columns
vehicle_data <- vehicle_data %>%
  rename(
    year = `Data Year`,
    county = `County`,
    fuel_group = `Dashboard Fuel Type Group`,
    fuel_type = `Fuel Type`,
    make = `Make`,
    model = `Model`,
    num_vehicles = `Number of Vehicles`
  )

# Summarize total vehicles per year, county, and fuel type
vehicle_summary <- vehicle_data %>%
  group_by(year, county, fuel_type) %>%
  summarise(total_vehicles = sum(num_vehicles, na.rm = TRUE), .groups = "drop")

# Filter for gasoline vehicles in 2010 and sum across all counties
total_gasoline_2010 <- vehicle_summary %>%
  filter(year == 2017, fuel_type == "Gasoline") %>%
  summarise(total_gasoline = sum(total_vehicles, na.rm = TRUE))

# Print result
print(total_gasoline_2010)


# Reshape to long format for plotting
vehicle_trends_long <- vehicle_summary %>%
  pivot_wider(names_from = fuel_type, values_from = total_vehicles, values_fill = 0) %>%
  pivot_longer(cols = -c(year, county), names_to = "fuel_type", values_to = "total_vehicles")


# Convert year to Date format (YYYY-01-01)
vehicle_trends_long <- vehicle_trends_long %>%
  mutate(year = as.Date(paste0(year, "-01-01")))

library(dplyr)
library(ggplot2)
library(lubridate)

# Ensure year is treated as a date (YYYY-01-01)
vehicle_trends_yearly <- vehicle_data %>%
  group_by(year, fuel_type) %>%
  summarise(total_vehicles = sum(num_vehicles, na.rm = TRUE), .groups = "drop") %>%
  mutate(year = as.Date(paste0(year, "-01-01")))  # Convert year to Date format


library(scales)  # For comma formatting on the y-axis


# Plot all fuel types with a continuous x-axis and formatted y-axis
ggplot(vehicle_trends_yearly, aes(x = year, y = total_vehicles, color = fuel_type)) +
  geom_line(size = 1) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +  # Yearly labels
  scale_y_continuous(labels = comma) +  # Add commas to y-axis
  labs(
    title = "Trends in Vehicle Types Over Time (Yearly Aggregated)",
    x = "Year",
    y = "Total Vehicles",
    color = "Fuel Type"
  ) +
  theme_minimal()


# Filter out gasoline vehicles
non_gasoline_trends <- vehicle_trends_yearly %>%
  filter(fuel_type != "Gasoline")

# Plot all other fuel types with formatted y-axis
ggplot(non_gasoline_trends, aes(x = year, y = total_vehicles, color = fuel_type)) +
  geom_line(size = 1) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +  # Yearly labels
  scale_y_continuous(labels = comma) +  # Add commas to y-axis
  labs(
    title = "Trends in Non-Gasoline Vehicle Types Over Time (Yearly Aggregated)",
    x = "Year",
    y = "Total Vehicles",
    color = "Fuel Type"
  ) +
  theme_minimal()


library(ggplot2)
library(scales)  # For comma formatting on the y-axis

# Filter only gasoline vehicles
gasoline_trends_yearly <- vehicle_trends_yearly %>%
  filter(fuel_type == "Gasoline")

# Plot gasoline vehicles with formatted y-axis
ggplot(gasoline_trends_yearly, aes(x = year, y = total_vehicles)) +
  geom_line(color = "red", size = 1) +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +  # Yearly labels
  scale_y_continuous(labels = comma) +  # Add commas to y-axis
  labs(
    title = "Trends in Gasoline Vehicles Over Time (Yearly Aggregated)",
    x = "Year",
    y = "Total Gasoline Vehicles"
  ) +
  theme_minimal()



library(ggplot2)
library(scales)

# Add a dummy column for legend assignment
gasoline_trends_yearly <- gasoline_trends_yearly %>%
  mutate(fuel_category = "Gasoline")  # Assign category for legend

# Plot gasoline vehicles with a manually added legend
ggplot(gasoline_trends_yearly, aes(x = year, y = total_vehicles, color = fuel_category)) +
  geom_line(size = 1) +  # Line for gasoline vehicles
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +  # Yearly labels
  scale_y_continuous(labels = comma) +  # Format y-axis with commas
  scale_color_manual(values = c("Gasoline" = "red"), name = "Fuel Type") +  # Manually add legend
  labs(
    title = "Trends in Gasoline Vehicles Over Time (Yearly Aggregated)",
    x = "Year",
    y = "Total Gasoline Vehicles"
  ) +
  theme_minimal() +
  theme(legend.position = "right")  # Ensure legend is displayed



library(ggplot2)
library(scales)

# Add a dummy column for legend assignment
gasoline_trends_yearly <- gasoline_trends_yearly %>%
  mutate(fuel_category = "Gasoline") %>%  # Assign category for legend
  filter(year <= as.Date("2016-01-01"))  # Ensure the plot ends in 2016

# Plot gasoline vehicles with a manually added legend
ggplot(gasoline_trends_yearly, aes(x = year, y = total_vehicles, color = fuel_category)) +
  geom_line(size = 1) +  # Line for gasoline vehicles
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", limits = c(min(gasoline_trends_yearly$year), as.Date("2016-01-01"))) +  
  scale_y_continuous(labels = comma) +  # Format y-axis with commas
  scale_color_manual(values = c("Gasoline" = "red"), name = "Fuel Type") +  # Manually add legend
  labs(
    title = "Trends in Gasoline Vehicles Over Time (Through 2016)",
    x = "Year",
    y = "Total Gasoline Vehicles"
  ) +
  theme_minimal() +
  theme(legend.position = "right")  # Ensure legend is displayed








library(ggplot2)
library(scales)

# Filter out gasoline and ensure the plot only includes years up to 2016
non_gasoline_trends_yearly <- vehicle_trends_yearly %>%
  filter(fuel_type != "Gasoline", year <= as.Date("2016-01-01"))

# Plot all non-Gasoline fuel types with a continuous x-axis and formatted y-axis
ggplot(non_gasoline_trends_yearly, aes(x = year, y = total_vehicles, color = fuel_type)) +
  geom_line(size = 1) +  # Line plot for all fuel types
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", 
               limits = c(min(non_gasoline_trends_yearly$year), as.Date("2016-01-01"))) +  # Set x-axis limit
  scale_y_continuous(labels = comma) +  # Format y-axis with commas
  labs(
    title = "Trends in Non-Gasoline Vehicle Types Over Time (Through 2016)",
    x = "Year",
    y = "Total Vehicles",
    color = "Fuel Type"
  ) +
  theme_minimal() +
  theme(legend.position = "right")  # Ensure legend is displayed
