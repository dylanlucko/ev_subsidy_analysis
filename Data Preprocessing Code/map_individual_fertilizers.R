



library(dplyr)
library(ggplot2)
library(maps)
library(scales)  # For comma formatting in legend


fertilizers_by_type_by_county_2016 <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/fertilizers_by_type_by_county_2016.csv")



# Load California county boundaries
county_map <- map_data("county") %>%
  filter(region == "california")

# Ensure county names match between datasets
fertilizers_by_type_by_county_2016 <- fertilizers_by_type_by_county_2016 %>%
  mutate(COUNTY = tolower(COUNTY))  # Convert county names to lowercase to match map data

county_map <- county_map %>%
  mutate(subregion = tolower(subregion))  # Ensure county names are in lowercase


plot_fertilizer_map <- function(fertilizer_column) {
  # Prepare data for merging
  fertilizer_data <- fertilizers_by_type_by_county_2016 %>%
    select(COUNTY, all_of(fertilizer_column)) %>%
    rename(total_acres = all_of(fertilizer_column))  # Standardize column name
  
  # Convert fertilizer values to numeric (handle missing values)
  fertilizer_data <- fertilizer_data %>%
    mutate(total_acres = as.numeric(gsub(",", "", total_acres)))
  
  # Merge with county map data
  map_data_fertilizer <- county_map %>%
    left_join(fertilizer_data, by = c("subregion" = "COUNTY"))
  
  # Create the map plot with a gradient color scale
  p <- ggplot(map_data_fertilizer, aes(x = long, y = lat, group = group, fill = total_acres)) +
    geom_polygon(color = "black", size = 0.2) +
    scale_fill_gradient(low = "lightyellow", high = "darkred", na.value = "white", 
                        name = "Tonnage", labels = comma_format()) +  # Format legend with commas
    labs(
      title = paste("Fertilizer Usage in California (2016) -", fertilizer_column),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal() +
    theme(legend.position = "right")
  
  # Save the plot as an image
  ggsave(filename = paste0("Fertilizer_Map_", gsub(" ", "_", fertilizer_column), ".png"),
         plot = p, width = 8, height = 6)
  
  # Return the plot to display it
  return(p)
}


# Get all fertilizer column names (excluding COUNTY)
fertilizer_columns <- colnames(fertilizers_by_type_by_county_2016)[-1]  # Exclude first column (COUNTY)

# Generate and save maps separately for each fertilizer type
for (fertilizer in fertilizer_columns) {
  print(plot_fertilizer_map(fertilizer))  # Print each plot to view
}
