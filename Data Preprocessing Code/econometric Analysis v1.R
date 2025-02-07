

esc_esc <- panel_data

panel_data <- esc_esc

panel_data  <- panel_data %>%
  rename(no2_ppb = arithmetic_mean, population = Population, income_per_capita = Income_per_Capita, mean_rebate_amount = `Mean.Rebate.Amount`, total_low_income_count = `Total.Low.Income.Count`,  battery_electric_vehicle = BEV, total_rebate_dollars = `Total.Rebate.Dollars`, min_rebate_amount = `Min.Rebate.Amount`, median_rebate_amount = `Median.Rebate.Amount`, max_rebate_amount = `Max.Rebate.Amount`, total_subsidy_applications = `Total.Applications`, num_bev_cars = Battery.Electric..BEV., num_diesel_cars = Diesel, num_flex_fuel_cars = `Flex.Fuel`, num_gasoline_cars = Gasoline, num_gasoline_hybrid_cars = `Gasoline.Hybrid`, num_natural_gas_cars = `Natural.Gas`, num_propane_cars = Propane, num_fuel_cell_cars = `Fuel.Cell..FCEV.`, num_plug_in_hybrid = `Plug.in.Hybrid..PHEV.`, total_chemical_fungicide = `CHEMICAL..FUNGICIDE...TOTAL.`, total_chemical_herbicide = `CHEMICAL..HERBICIDE...TOTAL.`, chemical_insecticide_excl_nema = `CHEMICAL..INSECTICIDE...EXCL.NEMATICIDES.`, total_chemical_other = `CHEMICAL..OTHER...TOTAL.`, fertiizer_manure = `FERTILIZER...MANURE.`, total_fertilizer = `FERTILIZER...TOTAL.`, chemical_insecticide = `CHEMICAL..INSECTICIDE...NEMATICIDES.`, fertilizer_organic = `FERTILIZER...ORGANIC.`, )


# Step 1: Filter Data for 2009-2016
panel_data <- panel_data %>%
  filter(year >= 2009 & year <= 2016)

write.csv(panel_data, "panel_data_clean_09_16.csv")


########
########
########


# Load necessary libraries
library(dplyr)
library(ggplot2)

# Define a threshold for significant increase (e.g., 50% increase)
threshold <- 0.3

# Step 1: Get 2010 values for each county (Ensure uniqueness)
base_year_data <- panel_data %>%
  filter(year == 2010) %>%
  group_by(county) %>%
  summarise(
    base_ev = mean(battery_electric_vehicle, na.rm = TRUE),  # Use mean if duplicates exist
    base_subsidy = mean(total_subsidy_applications, na.rm = TRUE)
  ) %>%
  ungroup()

panel_data <- panel_data %>%
  mutate(
    ev_growth = (battery_electric_vehicle - base_ev) / (base_ev + 1),
    subsidy_growth = (total_subsidy_applications - base_subsidy) / (base_subsidy + 1),
    Treatment = ifelse(ev_growth > threshold | subsidy_growth > threshold, 1, 0),
    Treatment = replace_na(Treatment, 0)  # Convert NA to Control (0)
  )

# Step 3: Plot treatment vs. control on a map
ggplot(panel_data, aes(x = longitude, y = latitude, color = factor(Treatment))) +
  geom_point(alpha = 0.6, size = 2) +
  scale_color_manual(values = c("0" = "blue", "1" = "red"), labels = c("Control", "Treatment")) +
  labs(title = "EV Treatment vs. Control Counties (Based on Growth Since 2010)",
       x = "Longitude", y = "Latitude", color = "Group") +
  theme_minimal()



########
########
########

####
####
#### DiD prelim ####
####
####
