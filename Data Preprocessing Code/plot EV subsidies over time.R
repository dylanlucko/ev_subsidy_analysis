# Load necessary libraries
library(ggplot2)
library(dplyr)
library(lubridate)
library(tidyr)

# Convert Application Date to Date format if necessary
ev_subsidies_per_day_2010_2023 <- ev_subsidies_per_day_2010_2023 %>%
  mutate(`Application Date` = as.Date(`Application Date`))

# Aggregate data at a monthly level for each vehicle category
vehicle_type_over_time <- ev_subsidies_per_day_2010_2023 %>%
  mutate(YearMonth = floor_date(`Application Date`, "month")) %>%  # Extract Year-Month
  group_by(YearMonth, `Vehicle Category`) %>%
  summarise(`Total Applications` = n(), .groups = 'drop')

# Compute overall monthly total across all vehicle types
total_over_time <- ev_subsidies_per_day_2010_2023 %>%
  mutate(YearMonth = floor_date(`Application Date`, "month")) %>%
  group_by(YearMonth) %>%
  summarise(`Total Applications` = n(), .groups = 'drop') %>%
  mutate(`Vehicle Category` = "Total")  # Add a category for overall total

# Combine both datasets
plot_data <- bind_rows(vehicle_type_over_time, total_over_time)

# Plot using ggplot
ggplot(plot_data, aes(x = YearMonth, y = `Total Applications`, color = `Vehicle Category`)) +
  geom_line(size = 1) +  # Line plot for trends over time
  labs(
    title = "Total EV Subsidy Applications Over Time by Vehicle Type (Monthly Aggregated)",
    x = "Date (Monthly)",
    y = "Total Applications",
    color = "Vehicle Type"
  ) +
  theme_minimal() +  # Clean theme
  theme(legend.position = "right")
