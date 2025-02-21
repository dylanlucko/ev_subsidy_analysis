
source("C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/Data Preprocessing Code/preamble.R")

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


#####
#####
##### End in 2017 #####
#####
#####


library(ggplot2)
library(scales)

# Filter data to include only observations up to 2017
plot_data_filtered <- plot_data %>%
  filter(YearMonth <= as.Date("2017-12-31"))

# Plot using ggplot with x-axis limit set to 2017
ggplot(plot_data_filtered, aes(x = YearMonth, y = `Total Applications`, color = `Vehicle Category`)) +
  geom_line(size = 1) +  # Line plot for trends over time
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", 
               limits = c(min(plot_data_filtered$YearMonth), as.Date("2017-12-31"))) +  # Ensure the x-axis ends in 2017
  labs(
    title = "Total EV Subsidy Applications Over Time by Vehicle Type (Monthly)",
    x = "Date (Monthly)",
    y = "Total Applications",
    color = "Vehicle Type"
  ) +
  theme_minimal() +  # Clean theme
  theme(legend.position = "right")


#############
#############
############# Plot so differentiable in BW ##########
#############
#############


library(ggplot2)
library(dplyr)

# Filter data: Exclude "Total" category and limit to 2017
plot_data_filtered <- plot_data %>%
  filter(YearMonth <= as.Date("2017-12-31"), `Vehicle Category` != "Total")

# Plot using ggplot
ggplot(plot_data_filtered, aes(x = YearMonth, y = `Total Applications`, 
                               linetype = `Vehicle Category`, shape = `Vehicle Category`)) +
  geom_line(size = 1) +  # Line plot
  geom_point(size = 2) +  # Add points for BW differentiation
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", 
               limits = c(min(plot_data_filtered$YearMonth), as.Date("2017-12-31"))) +  
  scale_linetype_manual(values = c("solid", "solid", "solid", "solid", "solid")) +  # BW-friendly line types
  scale_shape_manual(values = c(16, 17, 18, 15, 8)) +  # Different shapes for BW printing
  labs(
    title = "Total EV Subsidy Applications Over Time by Vehicle Type (Monthly)",
    x = "Date (Monthly)",
    y = "Total Applications",
    linetype = "Vehicle Type",
    shape = "Vehicle Type"
  ) +
  theme_minimal() +  
  theme(legend.position = "right")
