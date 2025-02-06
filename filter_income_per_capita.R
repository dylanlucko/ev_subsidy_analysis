

# Load required libraries
library(dplyr)
library(tidyr)

# Assuming california_data_income is your dataframe
california_data_income <- california_data_income %>%
  # Separate 'GeoName' into 'County' and 'State' based on the comma
  separate(GeoName, into = c("County", "State"), sep = ", ") %>%
  # Filter for only California (CA) and Colorado (CO)
  filter(State %in% c("CA", "CO"))

# Print the updated dataframe
print(california_data_income)


library(dplyr)
library(tidyr)

california_data_income <- california_data %>%
  # Separate 'GeoName' into 'County' and 'State', keeping extra parts in 'County'
  separate(GeoName, into = c("County", "State"), sep = ", ", extra = "merge") %>%
  # Filter for only California (CA) and Colorado (CO)
  filter(State %in% c("CA", "CO"))

# Print to check results
print(california_data_income)

california_income_per_capita <- california_data_income %>%
  filter(State == "CA") %>%
  rename(Income_per_Capita = DataValue)
write.csv(california_income_per_capita, "california_income_per_capita.csv")


##

colorado_income_per_capita <- california_data_income %>%
  filter(State == "CO") %>%
  rename(Income_per_Capita = DataValue)
write.csv(colorado_income_per_capita, "colorado_income_per_capita.csv")
