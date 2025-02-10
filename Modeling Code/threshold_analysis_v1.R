


#####
#####
##### Define pre and post based on EV adoption relative to all vehicles #####
#####
#####

library(dplyr)
library(lubridate)

# Ensure `date` is in Date format
panel_data_did <- panel_data_did %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"))


# Compute total cars and BEV share
panel_data_did <- panel_data_did %>%
  mutate(
    total_cars = num_bev_cars + num_diesel_cars + num_flex_fuel_cars +
      num_gasoline_cars + num_gasoline_hybrid_cars +
      num_natural_gas_cars + num_propane_cars +
      num_fuel_cell_cars + num_plug_in_hybrid,
    bev_share = num_bev_cars / total_cars  # BEV share as a percentage
  )

# Define the BEV adoption threshold (e.g., 5%)
bev_threshold <- 0.005  

# Find the first date when BEV share surpasses the threshold per county
bev_threshold_dates <- panel_data_did %>%
  filter(bev_share > bev_threshold) %>%
  group_by(county) %>%
  summarise(threshold_date = min(date, na.rm = TRUE), .groups = "drop")

# Merge this back into the main dataset
panel_data_did <- panel_data_did %>%
  left_join(bev_threshold_dates, by = "county")


# Assign 0 before the threshold date, 1 after
panel_data_did <- panel_data_did %>%
  mutate(bev_threshold_dummy = ifelse(date >= threshold_date, 1, 0))


# Save the new dataset with the threshold dummy
bev_threshold_df <- panel_data_did %>%
  select(county, date, bev_share, bev_threshold_dummy, threshold_date)

# View the dataset
head(bev_threshold_df)


library(ggplot2)
library(dplyr)

# Aggregate average BEV share by year and treatment status
bev_trends <- panel_data_did %>%
  group_by(date, county) %>%
  summarise(avg_bev_share = mean(bev_share, na.rm = TRUE),
            threshold_date = first(threshold_date),
            bev_threshold_dummy = first(bev_threshold_dummy),
            .groups = "drop")


# Plot BEV adoption trends for each county, highlighting threshold crossing
ggplot(bev_trends, aes(x = date, y = avg_bev_share, color = as.factor(bev_threshold_dummy))) +
  geom_line(size = 1) +  # Line plot for BEV share trends
  geom_vline(aes(xintercept = threshold_date), linetype = "dashed", color = "black", alpha = 0.6) +  # Vertical line for threshold
  scale_color_manual(values = c("0" = "blue", "1" = "red"), 
                     labels = c("Before Threshold", "After Threshold"),
                     name = "Threshold Status") +
  
  # Labels and styling
  labs(
    title = "BEV Adoption Trends and Threshold Crossing",
    x = "Date",
    y = "Average BEV Share",
    color = "Threshold Status"
  ) +
  
  theme_minimal()
