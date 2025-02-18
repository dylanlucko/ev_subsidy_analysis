

panel_data_did <- read.csv("~/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_4_35_pct/panel_data_2_9.csv")


colnames(panel_data_did)
colnames(fertilizers_by_type_by_county_2016)


library(dplyr)

# Rename columns: Replace "." with "_" and rename COUNTY to county
fertilizers_by_type_by_county_2016 <- fertilizers_by_type_by_county_2016 %>%
  rename_with(~ gsub("\\.", "_", .x)) %>%
  rename(county = COUNTY)

unique(fertilizers_by_type_by_county_2016$county)

library(dplyr)
library(stringr)

# Capitalize the first letter of each county name
fertilizers_by_type_by_county_2016 <- fertilizers_by_type_by_county_2016 %>%
  mutate(county = str_to_title(county))  # Capitalizes first letter of each word



library(dplyr)
library(stringr)

# Create a named vector for correcting county names
county_corrections <- c(
  "San Bernardi" = "San Bernardino",
  "San Francisc" = "San Francisco",
  "San Luis Obisp" = "San Luis Obispo",
  "Santa Barbar" = "Santa Barbara"
)


# Replace truncated county names with correct ones
fertilizers_by_type_by_county_2016 <- fertilizers_by_type_by_county_2016 %>%
  mutate(county = recode(county, !!!county_corrections))


# Check which counties are still mismatched
mismatched_counties <- setdiff(fertilizers_by_type_by_county_2016$county, panel_data_did$county)

print("Counties in fertilizer data that do NOT match panel_data_did:")
print(mismatched_counties)
unique(panel_data_did$county)





# Merge fertilizer data into panel_data_did by county
panel_data_did <- panel_data_did %>%
  left_join(fertilizers_by_type_by_county_2016, by = "county")

colnames(panel_data_did)

unique(panel_data_did$UREA)

write.csv(panel_data_did, "panel_data_did_2_13.csv")
