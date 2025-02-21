
library(dplyr)
library(tidyr)

california_data_population <- california_data %>%
  # Separate 'GeoName' into 'County' and 'State', keeping extra parts in 'County'
  separate(GeoName, into = c("County", "State"), sep = ", ", extra = "merge") %>%
  # Filter for only California (CA) and Colorado (CO)
  filter(State %in% c("CA", "CO"))

# Print to check results
print(california_data_population)

california_population <- california_data_population %>%
  filter(State == "CA") %>%
  rename(Population = DataValue)
write.csv(california_population, "california_population.csv")


##

colorado_population <- california_data_population %>%
  filter(State == "CO") %>%
  rename(Population = DataValue)
write.csv(colorado_population, "colorado_population.csv")
