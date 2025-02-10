

library(dplyr)
library(lubridate)
library(ggplot2)

#####
#####
##### Pretrends at Monthly Level #####
#####
#####




# Ensure `date` is properly formatted as Date type
panel_data <- panel_data %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"),  # Convert to Date
         month_year = floor_date(date, "month"))  # Extract month-year


# Aggregate `no2_ppb` by month and Treatment status
no2_trends <- panel_data %>%
  group_by(month_year, Treatment_zip) %>%
  summarise(avg_no2_ppb = mean(no2_ppb, na.rm = TRUE), .groups = "drop")


# Plot NO2 trends over time by Treatment group
ggplot(no2_trends, aes(x = month_year, y = avg_no2_ppb, color = as.factor(Treatment_zip))) +
  geom_line(size = 1) +  # Line plot for NO2 trends
  scale_color_manual(
    values = c("0" = "blue", "1" = "red"),
    labels = c("Control", "Treatment"),
    name = "Treatment Status"
  ) +
  
  # Labels and styling
  labs(
    title = "Trends in NO2 Levels Over Time (Monthly)",
    x = "Date (Monthly)",
    y = "Average NO2 (ppb)",
    color = "Treatment Group"
  ) +
  
  theme_minimal()



#####
#####
##### Pretrends at Yearly Level #####
#####
#####


library(dplyr)
library(lubridate)
library(ggplot2)

# Ensure `date` is properly formatted and extract the year
panel_data <- panel_data %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"),  # Convert to Date
         year = year(date))  # Extract Year


# Aggregate `no2_ppb` by year and Treatment status
no2_trends_yearly <- panel_data %>%
  group_by(year, Treatment_zip) %>%
  summarise(avg_no2_ppb = mean(no2_ppb, na.rm = TRUE), .groups = "drop")



# Plot NO2 trends over time by Treatment group (yearly)
ggplot(no2_trends_yearly, aes(x = year, y = avg_no2_ppb, color = as.factor(Treatment_zip))) +
  geom_line(size = 1) +  # Line plot for NO2 trends
  geom_point(size = 2) +  # Add points for clarity
  scale_color_manual(
    values = c("0" = "blue", "1" = "red"),
    labels = c("Control", "Treatment"),
    name = "Treatment Status"
  ) +
  
  # Labels and styling
  labs(
    title = "Yearly Trends in NO2 Levels (ppb)",
    x = "Year",
    y = "Average NO2 (ppb)",
    color = "Treatment Group"
  ) +
  
  theme_minimal()
