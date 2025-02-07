

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
threshold <- 0.5

# Step 1: Get 2010 values for each county
base_year_data <- panel_data %>%
  filter(year == 2010) %>%
  select(county, battery_electric_vehicle, total_subsidy_applications) %>%
  rename(base_ev = battery_electric_vehicle, base_subsidy = total_subsidy_applications)

# Step 2: Merge 2010 base values into panel_data
panel_data <- panel_data %>%
  left_join(base_year_data, by = "county") %>%
  mutate(
    ev_growth = (battery_electric_vehicle - base_ev) / (base_ev + 1),  # Avoid division by zero
    subsidy_growth = (total_subsidy_applications - base_subsidy) / (base_subsidy + 1),
    Treatment = ifelse(ev_growth > threshold | subsidy_growth > threshold, 1, 0)  # Assign treatment
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


# Load necessary libraries
library(dplyr)
library(fixest)  # For fixed effects regression


# Step 2: Create Treatment Variable (EV Presence)
# Assuming "EV Count" is a variable tracking the number of electric vehicles in a county
panel_data <- panel_data %>%
  group_by(county, year) %>%
  mutate(EV_Presence = ifelse(`EV Count` > median(`EV Count`, na.rm = TRUE), 1, 0)) %>%
  ungroup()

# Step 3: Create the DiD Interaction Term
panel_data <- panel_data %>%
  mutate(Post_Treatment = ifelse(year >= 2011, 1, 0),  # Assuming EV adoption increases post-2011
         DiD_Term = EV_Presence * Post_Treatment)

# Step 4: Run Difference-in-Differences Model
# Pollution is measured at the site level (daily), while controls are at the county level (yearly)
did_model <- feols(
  pollution_level ~ DiD_Term + EV_Presence + Post_Treatment + 
    income_per_capita + population + rebates_per_day + 
    `EV Count` + `PHEV Count` + `Gasoline Count` + `Diesel Count` | county + year + site_id,
  data = panel_data, cluster = "county"
)

# Step 5: Display Results
summary(did_model)
