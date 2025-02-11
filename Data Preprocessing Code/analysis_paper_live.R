
library(dplyr)

# Count unique latitude-longitude site locations
unique_sites_count <- panel_data_did %>%
  distinct(latitude, longitude, site_number) %>%
  nrow()

# Print result
print(paste("Number of unique site locations:", unique_sites_count))

