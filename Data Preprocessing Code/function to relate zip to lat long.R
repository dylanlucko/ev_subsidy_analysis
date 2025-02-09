

ev_subsidies_per_day_2010_2023 <- read_excel("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/ev_subsidies_per_day_2010_2023.xlsx")

length(unique(ev_subsidies_per_day_2010_2023$County))
#58

length(unique(ev_subsidies_per_day_2010_2023$ZIP))
#1873

# not the same granularity. 

colnames(ev_subsidies_per_day_2010_2023)


#####
#####
##### Relate Zip code to range of lat long for comparison with lat-long-site metric
#####
#####


# Install package if needed
install.packages("zipcodeR")

# Load the package
library(zipcodeR)


# Get unique ZIP codes from ev_subsidies_per_day_2010_2023
zip_list <- unique(ev_subsidies_per_day_2010_2023$ZIP)

# Retrieve lat/long for all ZIPs
zip_data <- lapply(zip_list, reverse_zipcode) %>% bind_rows()

head(zip_data)  # Now we have ZIP, lat, and long


##### Merge back into ev subsidy data

# Ensure ZIP codes are formatted as characters
ev_subsidies_per_day_2010_2023 <- ev_subsidies_per_day_2010_2023 %>%
  mutate(ZIP = as.character(ZIP))

zip_data <- zip_data %>%
  select(zipcode, lat, lng) %>%
  rename(zip_lat = lat, zip_long = lng, ZIP = zipcode)

# Merge ZIP lat/long into the EV subsidies dataset
ev_subsidies_per_day_2010_2023 <- ev_subsidies_per_day_2010_2023 %>%
  left_join(zip_data, by = "ZIP")


#####
#####
##### Assign treatment and control at the zip level #####
#####
#####
