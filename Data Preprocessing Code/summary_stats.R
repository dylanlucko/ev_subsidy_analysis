

# Source the preamble script to load necessary functions and libraries
source("C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/Data Preprocessing Code/preamble.R")


panel_data_did <- read.csv("~/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache/panel_data_did_2_15.csv")

colnames(panel_data_did)


library(dplyr)

# Summarize NO2 at the daily-site level (already correct)
no2_summary <- panel_data_did %>%
  summarise(
    NO2_Mean = mean(no2_ppb, na.rm = TRUE),
    NO2_SD = sd(no2_ppb, na.rm = TRUE),
    NO2_Min = min(no2_ppb, na.rm = TRUE),
    NO2_Max = max(no2_ppb, na.rm = TRUE),
    NO2_P25 = quantile(no2_ppb, 0.25, na.rm = TRUE),
    NO2_P50 = quantile(no2_ppb, 0.50, na.rm = TRUE),
    NO2_P75 = quantile(no2_ppb, 0.75, na.rm = TRUE)
  )

# Summarize Population at the yearly-county level
population_summary <- panel_data_did %>%
  group_by(year, county) %>%  # Collapse to the correct level
  summarise(Population = first(population), .groups = "drop") %>%  # Take only one value per year-county
  summarise(
    Population_Mean = mean(Population, na.rm = TRUE),
    Population_SD = sd(Population, na.rm = TRUE),
    Population_Min = min(Population, na.rm = TRUE),
    Population_Max = max(Population, na.rm = TRUE),
    Population_P25 = quantile(Population, 0.25, na.rm = TRUE),
    Population_P50 = quantile(Population, 0.50, na.rm = TRUE),
    Population_P75 = quantile(Population, 0.75, na.rm = TRUE)
  )

# Summarize Income per Capita at the yearly-county level
income_summary <- panel_data_did %>%
  group_by(year, county) %>%  # Collapse to the correct level
  summarise(Income = first(income_per_capita), .groups = "drop") %>%  # Take only one value per year-county
  summarise(
    Income_Mean = mean(Income, na.rm = TRUE),
    Income_SD = sd(Income, na.rm = TRUE),
    Income_Min = min(Income, na.rm = TRUE),
    Income_Max = max(Income, na.rm = TRUE),
    Income_P25 = quantile(Income, 0.25, na.rm = TRUE),
    Income_P50 = quantile(Income, 0.50, na.rm = TRUE),
    Income_P75 = quantile(Income, 0.75, na.rm = TRUE)
  )

# Summarize Total Cars at the monthly-county level
total_cars_summary <- panel_data_did %>%
  group_by(year, month, county) %>%  # Collapse to the correct level
  summarise(TotalCars = first(total_cars), .groups = "drop") %>%  # Take only one value per month-county
  summarise(
    TotalCars_Mean = mean(TotalCars, na.rm = TRUE),
    TotalCars_SD = sd(TotalCars, na.rm = TRUE),
    TotalCars_Min = min(TotalCars, na.rm = TRUE),
    TotalCars_Max = max(TotalCars, na.rm = TRUE),
    TotalCars_P25 = quantile(TotalCars, 0.25, na.rm = TRUE),
    TotalCars_P50 = quantile(TotalCars, 0.50, na.rm = TRUE),
    TotalCars_P75 = quantile(TotalCars, 0.75, na.rm = TRUE)
  )

# Print the summary tables
print(no2_summary)
print(population_summary)
print(income_summary)
print(total_cars_summary)



##############


library(dplyr)

# Summarize NO2 at the yearly-site level
no2_summary <- panel_data_did %>%
  group_by(year) %>%  # Aggregate per year
  summarise(
    NO2_Mean = mean(no2_ppb, na.rm = TRUE),
    NO2_SD = sd(no2_ppb, na.rm = TRUE),
    NO2_Min = min(no2_ppb, na.rm = TRUE),
    NO2_Max = max(no2_ppb, na.rm = TRUE),
    NO2_P25 = quantile(no2_ppb, 0.25, na.rm = TRUE),
    NO2_P50 = quantile(no2_ppb, 0.50, na.rm = TRUE),
    NO2_P75 = quantile(no2_ppb, 0.75, na.rm = TRUE)
  )

# Summarize Population at the yearly-county level
population_summary <- panel_data_did %>%
  group_by(year, county) %>%  # Collapse to the correct level
  summarise(Population = first(population), .groups = "drop") %>%  # Take only one value per year-county
  group_by(year) %>%  # Aggregate per year
  summarise(
    Population_Mean = mean(Population, na.rm = TRUE),
    Population_SD = sd(Population, na.rm = TRUE),
    Population_Min = min(Population, na.rm = TRUE),
    Population_Max = max(Population, na.rm = TRUE),
    Population_P25 = quantile(Population, 0.25, na.rm = TRUE),
    Population_P50 = quantile(Population, 0.50, na.rm = TRUE),
    Population_P75 = quantile(Population, 0.75, na.rm = TRUE)
  )

# Summarize Income per Capita at the yearly-county level
income_summary <- panel_data_did %>%
  group_by(year, county) %>%  # Collapse to the correct level
  summarise(Income = first(income_per_capita), .groups = "drop") %>%  # Take only one value per year-county
  group_by(year) %>%  # Aggregate per year
  summarise(
    Income_Mean = mean(Income, na.rm = TRUE),
    Income_SD = sd(Income, na.rm = TRUE),
    Income_Min = min(Income, na.rm = TRUE),
    Income_Max = max(Income, na.rm = TRUE),
    Income_P25 = quantile(Income, 0.25, na.rm = TRUE),
    Income_P50 = quantile(Income, 0.50, na.rm = TRUE),
    Income_P75 = quantile(Income, 0.75, na.rm = TRUE)
  )

# Summarize Total Cars at the yearly-county level
total_cars_summary <- panel_data_did %>%
  group_by(year, county) %>%  # Collapse to yearly-county level
  summarise(TotalCars = mean(total_cars, na.rm = TRUE), .groups = "drop") %>%  # Compute yearly mean per county
  group_by(year) %>%  # Aggregate per year
  summarise(
    TotalCars_Mean = mean(TotalCars, na.rm = TRUE),
    TotalCars_SD = sd(TotalCars, na.rm = TRUE),
    TotalCars_Min = min(TotalCars, na.rm = TRUE),
    TotalCars_Max = max(TotalCars, na.rm = TRUE),
    TotalCars_P25 = quantile(TotalCars, 0.25, na.rm = TRUE),
    TotalCars_P50 = quantile(TotalCars, 0.50, na.rm = TRUE),
    TotalCars_P75 = quantile(TotalCars, 0.75, na.rm = TRUE)
  )

# Print the summary tables
print(no2_summary)
print(population_summary)
print(income_summary)
print(total_cars_summary)
