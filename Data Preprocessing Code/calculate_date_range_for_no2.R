

df <- California_Data_Combined

df <- A_42602_California_Data_Combined
# Load required library
library(dplyr)

# Assuming your dataframe is called 'df'

# Calculate the date range per county_code
county_date_range <- df %>%
  group_by(county_code) %>%
  summarise(
    start_date = min(as.Date(date_local, format = "%Y-%m-%d")), # earliest date
    end_date = max(as.Date(date_local, format = "%Y-%m-%d"))    # latest date
  )

# View the result
print(county_date_range)


unique(df$county_code)
length(df$county_code)
length(unique(df$county_code))
