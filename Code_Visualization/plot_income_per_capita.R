

california_income_per_capita <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/california_income_per_capita.csv")

colnames(california_income_per_capita)

library(dplyr)
library(ggplot2)
library(maps)
library(scales)
library(gridExtra)

# Filter for 2010 and 2016 and ensure Income per Capita is numeric
california_income_filtered <- california_income_per_capita %>%
  filter(Year %in% c(2010)) %>%
  mutate(
    Income_per_Capita = as.numeric(gsub(",", "", Income_per_Capita)),  # Ensure numeric values
    County = tolower(County)  # Convert county names to lowercase for matching
  )

# Load California county map data
county_map <- map_data("county") %>%
  filter(region == "california") %>%
  mutate(subregion = tolower(subregion))  # Convert county names to lowercase

# Merge county map with income data
county_map_income <- county_map %>%
  left_join(california_income_filtered, by = c("subregion" = "County"))

# Check for missing counties
missing_counties <- county_map_income %>%
  filter(is.na(Income_per_Capita)) %>%
  distinct(subregion)

if (nrow(missing_counties) > 0) {
  print("Warning: The following counties have missing income data:")
  print(missing_counties)
}

# Find global min and max income values for a consistent scale
income_min <- min(county_map_income$Income_per_Capita, na.rm = TRUE)
income_max <- max(county_map_income$Income_per_Capita, na.rm = TRUE)

# Function to create an income per capita map for a given year
plot_income_map <- function(year) {
  data_filtered <- county_map_income %>%
    filter(Year == year)
  
  if (nrow(data_filtered) == 0) {
    print(paste("Warning: No data found for year", year))
    return(NULL)  # Return NULL to avoid plotting errors
  }
  
  ggplot(data_filtered, aes(x = long, y = lat, group = group, fill = Income_per_Capita)) +
    geom_polygon(color = "black", size = 0.2) +  # County boundaries
    scale_fill_gradient(low = "lightyellow", high = "navyblue", na.value = "white", 
                        name = "Income per Capita", labels = comma_format(), 
                        limits = c(income_min, income_max)) +  # Use common scale
    labs(
      title = paste("California Income Per Capita by County (", year, ")", sep = ""),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal() +
    theme(legend.position = "right")
}

# Generate plots for 2010 and 2016
plot_2010 <- plot_income_map(2010)
plot_2016 <- plot_income_map(2016)

# Arrange plots side by side if both exist
if (!is.null(plot_2010) & !is.null(plot_2016)) {
  grid.arrange(plot_2010, plot_2016, ncol = 2)
} else if (!is.null(plot_2010)) {
  print("Only the 2010 plot is available")
  print(plot_2010)
} else if (!is.null(plot_2016)) {
  print("Only the 2016 plot is available")
  print(plot_2016)
} else {
  print("No valid plots could be generated")
}
