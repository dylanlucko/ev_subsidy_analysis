

california_population <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/california_population.csv")

colnames(california_population)


library(dplyr)
library(ggplot2)
library(maps)
library(scales)

# Filter for 2012 and ensure Population is numeric
california_population_2012 <- california_population %>%
  filter(Year == 2010) %>%
  mutate(Population = as.numeric(gsub(",", "", Population)))  # Ensure numeric population values


# Load California county map data
county_map <- map_data("county") %>%
  filter(region == "california")

# Ensure county names match between datasets
california_population_2012 <- california_population_2012 %>%
  mutate(County = tolower(County))  # Convert county names to lowercase

county_map <- county_map %>%
  mutate(subregion = tolower(subregion))  # Ensure county names are in lowercase


# Merge county map with population data
county_map_population <- county_map %>%
  left_join(california_population_2012, by = c("subregion" = "County"))


# Plot population gradient across California counties
ggplot(county_map_population, aes(x = long, y = lat, group = group, fill = Population)) +
  geom_polygon(color = "black", size = 0.2) +  # County boundaries
  scale_fill_gradient(low = "lightyellow", high = "darkblue", na.value = "white", 
                      name = "Population", labels = comma_format()) +  # Ensure commas in legend
  labs(
    title = "California Population by County (2010)",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


######
######
######
######

library(dplyr)
library(ggplot2)
library(maps)
library(scales)
library(gridExtra)

# Filter for 2010 and 2016 and ensure Population is numeric
california_population_filtered <- california_population %>%
  filter(Year %in% c(2010, 2015)) %>%
  mutate(Population = as.numeric(gsub(",", "", Population)))  # Ensure numeric population values

# Load California county map data
county_map <- map_data("county") %>%
  filter(region == "california")

# Ensure county names match between datasets
california_population_filtered <- california_population_filtered %>%
  mutate(County = tolower(County))  # Convert county names to lowercase

county_map <- county_map %>%
  mutate(subregion = tolower(subregion))  # Ensure county names are in lowercase

# Merge county map with population data
county_map_population <- county_map %>%
  left_join(california_population_filtered, by = c("subregion" = "County"))

# Find global min and max population values for consistent color scaling
pop_min <- min(county_map_population$Population, na.rm = TRUE)
pop_max <- max(county_map_population$Population, na.rm = TRUE)

# Function to create a population map for a given year
plot_population_map <- function(year) {
  ggplot(county_map_population %>% filter(Year == year), aes(x = long, y = lat, group = group, fill = Population)) +
    geom_polygon(color = "black", size = 0.2) +  # County boundaries
    scale_fill_gradient(low = "lightyellow", high = "darkblue", na.value = "white", 
                        name = "Population", labels = comma_format(), limits = c(pop_min, pop_max)) +  # Common scale
    labs(
      title = paste("California Population by County (", year, ")", sep = ""),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal() +
    theme(legend.position = "right")
}

# Generate plots for 2010 and 2016
plot_2010 <- plot_population_map(2010)
plot_2016 <- plot_population_map(2015)

# Arrange plots side by side
grid.arrange(plot_2010, plot_2016, ncol = 2)
