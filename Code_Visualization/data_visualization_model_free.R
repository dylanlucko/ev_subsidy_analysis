

# Load required libraries
library(dplyr)
library(ggplot2)

# Summarize data by Data Year and Dashboard Fuel Type Group
vehicle_summary <- Vehicle_Population_Last_updated_04_30_2024_ada %>%
  group_by(`Data Year`, `Dashboard Fuel Type Group`) %>%
  summarise(Total_Vehicles = sum(`Number of Vehicles`), .groups = "drop")

# Create a separate graph for each Fuel Type
ggplot(vehicle_summary, aes(x = `Data Year`, y = Total_Vehicles, color = `Dashboard Fuel Type Group`)) +
  geom_line() +
  geom_point() +
  facet_wrap(~ `Dashboard Fuel Type Group`, scales = "free_y") +
  labs(title = "Number of Vehicles Over Time by Fuel Type",
       x = "Year",
       y = "Total Vehicles",
       color = "Fuel Type Group") +
  theme_minimal()
