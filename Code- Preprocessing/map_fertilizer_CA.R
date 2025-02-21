

ca_farmland_by_use <- read.csv("~/GitHub/ev_subsidy_analysis/Datasets Pre Panel Creation/ca_farmland_by_use.csv")


library(dplyr)
library(ggplot2)
library(maps)

# Ensure Value is numeric (handling any missing values)
ca_farmland_by_use <- ca_farmland_by_use %>%
  mutate(Value = as.numeric(gsub(",", "", Value)))  # Remove commas and convert to numeric

# Filter for 2012 and summarize acres by county and fertilizer type
fertilizer_summary <- ca_farmland_by_use %>%
  filter(Year == 2012) %>%
  group_by(County, Domain.Category) %>%
  summarise(total_acres = sum(Value, na.rm = TRUE), .groups = "drop")


# Load California county map data
county_map <- map_data("county") %>%
  filter(region == "california")

# Ensure county names match between datasets
fertilizer_summary <- fertilizer_summary %>%
  mutate(County = tolower(County))  # Convert county names to lowercase to match map data

county_map <- county_map %>%
  mutate(subregion = tolower(subregion))  # Ensure county names are in lowercase

# Function to Plot and Save Fertilizer Maps with Comma Formatting
plot_and_save_fertilizer_map <- function(fertilizer_type) {
  # Filter data for the selected fertilizer type
  data_filtered <- fertilizer_summary %>%
    filter(Domain.Category == fertilizer_type)
  
  # Merge with county map data
  map_data_fertilizer <- county_map %>%
    left_join(data_filtered, by = c("subregion" = "County"))
  
  # Create the map plot with formatted legend
  p <- ggplot(map_data_fertilizer, aes(x = long, y = lat, group = group, fill = total_acres)) +
    geom_polygon(color = "black", size = 0.2) +
    scale_fill_gradient(low = "lightyellow", high = "darkred", 
                        na.value = "white", name = "Acres",
                        labels = comma_format()) +  # Ensure commas in legend
    labs(
      title = paste("Fertilizer Usage in California (2012) -", fertilizer_type),
      x = "Longitude",
      y = "Latitude"
    ) +
    theme_minimal() +
    theme(legend.position = "right")
  
  # Save the plot as an image
  ggsave(filename = paste0("Fertilizer_Map_", gsub(" ", "_", fertilizer_type), ".png"),
         plot = p, width = 8, height = 6)
  
  # Return the plot so it can be viewed
  return(p)
}


# Get unique fertilizer types
fertilizer_types <- unique(fertilizer_summary$Domain.Category)

# Loop through each fertilizer type and create a separate map
for (fertilizer in fertilizer_types) {
  print(plot_and_save_fertilizer_map(fertilizer))  # Print to view each map
}
