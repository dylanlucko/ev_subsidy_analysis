

library(dplyr)
library(lubridate)

# Ensure `Application Date` is in Date format
ev_subsidy_daily <- ev_subsidies_per_day_2010_2023 %>%
  mutate(Application_Date = as.Date(`Application Date`, format = "%Y-%m-%d")) %>%
  group_by(Application_Date, `Vehicle Category`) %>%
  summarise(Total_Applications = n(), .groups = "drop")  # Count applications per category per day


library(ggplot2)

# Plot trends in applications over time by Vehicle Category
ggplot(ev_subsidy_daily, aes(x = Application_Date, y = Total_Applications, color = `Vehicle Category`)) +
  geom_line(size = 1) +  
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +  # Yearly labels
  labs(
    title = "Total EV Subsidy Applications Over Time by Vehicle Category",
    x = "Date",
    y = "Total Applications",
    color = "Vehicle Type"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


#####
#####
##### By Month #####
#####
#####

library(dplyr)
library(lubridate)

# Ensure `Application Date` is in Date format and extract Year-Month
ev_subsidy_monthly <- ev_subsidies_per_day_2010_2023 %>%
  mutate(Application_Date = as.Date(`Application Date`, format = "%Y-%m-%d"),
         YearMonth = floor_date(Application_Date, "month")) %>%  # Extract month-year
  group_by(YearMonth, `Vehicle Category`) %>%
  summarise(Total_Applications = n(), .groups = "drop")  # Count applications per category per month


library(ggplot2)

# Plot trends in applications over time by Vehicle Category (monthly)
ggplot(ev_subsidy_monthly, aes(x = YearMonth, y = Total_Applications, color = `Vehicle Category`)) +
  geom_line(size = 1) +  
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +  # Yearly labels
  labs(
    title = "Total EV Subsidy Applications Over Time by Vehicle Category (Monthly Aggregated)",
    x = "Date (Monthly)",
    y = "Total Applications",
    color = "Vehicle Type"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


#####
#####
#####
#####

library(ggplot2)
library(dplyr)
library(lubridate)

# Ensure `Application Date` is in Date format and extract Year-Month
ev_subsidy_monthly <- ev_subsidies_per_day_2010_2023 %>%
  mutate(Application_Date = as.Date(`Application Date`, format = "%Y-%m-%d"),
         YearMonth = floor_date(Application_Date, "month")) %>%  # Extract month-year
  group_by(YearMonth, `Vehicle Category`) %>%
  summarise(Total_Applications = n(), .groups = "drop")  # Count applications per category per month

# Filter data to include only observations up to 2017
ev_subsidy_monthly <- ev_subsidy_monthly %>%
  filter(YearMonth <= as.Date("2017-12-31"))

# Plot using ggplot with x-axis limit set to 2017
ggplot(ev_subsidy_monthly, aes(x = YearMonth, y = Total_Applications, color = `Vehicle Category`)) +
  geom_line(size = 1) +  
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", limits = c(min(ev_subsidy_monthly$YearMonth), as.Date("2017-12-31"))) +  # Ensure x-axis ends in 2017
  labs(
    title = "Total EV Subsidy Applications Over Time by Vehicle Category (Monthly)",
    x = "Date (Monthly)",
    y = "Total Applications",
    color = "Vehicle Type"
  ) +
  theme_minimal() +
  theme(legend.position = "right")
