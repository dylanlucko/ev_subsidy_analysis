#difference_in_differences

panel_data_did <- read.csv("~/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_4_35_pct/panel_data_did_2_13.csv")

colnames(panel_data_did)

panel_data_did <- panel_data_did %>%
  select(-c(X.1, X, X.y))

panel_data_did <- panel_data_did %>%
  select(-X.2)

colnames(panel_data_did)


# Compute total cars and BEV share
panel_data_did <- panel_data_did %>%
  mutate(
    total_cars = num_bev_cars + num_diesel_cars + num_flex_fuel_cars +
      num_gasoline_cars + num_gasoline_hybrid_cars +
      num_natural_gas_cars + num_propane_cars +
      num_fuel_cell_cars + num_plug_in_hybrid,
    bev_share = num_bev_cars / total_cars  # BEV share as a percentage
  )

#####
#####
##### Create Post var #####
#####
#####


# Ensure `date` is in Date format
panel_data_did <- panel_data_did %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"))


# Create Post column based on date
panel_data_did <- panel_data_did %>%
  mutate(Post = ifelse(year(date) >= 2011, 1, 0))


#####
#####
##### DiD Model #####
#####
#####

library(fixest)  # For fixed effects regression

# Ensure `date` is in Date format
panel_data_did <- panel_data_did %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d")) %>%
  filter(year(date) >= 2010)  # Keep only data from 2010 onwards

panel_data_did <- panel_data_did %>%
  mutate(month = month(date, label = TRUE, abbr = TRUE))


library(dplyr)

# Define the columns to convert
fertilizer_columns <- c("ANHYDROUS_AMMONIA", "AQUA_AMMONIA", "AMMONIUM_NITRATE",
                        "NITRATE_SOLUTION", "AMMONIUM_POLYSULFIDE", "AMMONIUM_SULFATE",
                        "AMMONIUM_THIOSULFATE", "BLOOD_MEAL", "AMMONIUM_NITRATE_1",
                        "CALCIUM_NITRATE", "SOLUTION_28_", "SOLUTION_32_", "SODIUM_NITRATE",
                        "COATED_UREA", "UREA", "UREA_SOLUTION", "MATERIALS___ALL_OTHER",
                        "DIAMMONIUM_PHOSPHATE", "PHOSPHATE_SULFATE", "MONOAMMONIUM_PHOSPHATE",
                        "PHOSPHORIC_ACID", "AMMONIUM_POLYPHOSPHATE", "NORMAL_SUPERPHOSPHATE",
                        "TRIPLE_SUPERPHOSPHATE", "ALL_OTHER", "OF_POTASH", "POTASH_MAGNESIA",
                        "POTASSIUM_NITRATE", "POTASSIUM_SULFATE", "MATERIALS___ALL_OTHER_1")

# Convert specified columns to numeric, handling non-numeric values
panel_data_did <- panel_data_did %>%
  mutate(across(all_of(fertilizer_columns), 
                ~ as.numeric(gsub("[^0-9.-]", "", .)),  # Remove all non-numeric characters
                .names = "{.col}"))

# Verify conversion
str(panel_data_did[fertilizer_columns])

# Run the Difference-in-Differences (DiD) model
did_model <- feols(
  no2_ppb ~ Treatment_zip * Post + log(population) + log(income_per_capita) + total_fertilizer +  chemical_insecticide + num_gasoline_cars | cbsa_code + year + month,  # Fixed effects
  data = panel_data_did, 
  cluster = "county"  # Cluster SEs at site level
)

# View results
summary(did_model)

summary(did_model, se = "hetero")  # Heteroskedasticity-robust


# Count NA values per column
colSums(is.na(panel_data_did))


#####
#####
##### Model 2 #####
#####
#####


# Run the Difference-in-Differences (DiD) model
did_model <- feols(
  (no2_ppb) ~ Treatment_zip * Post + (population) + (income_per_capita) + total_fertilizer  +  total_cars + num_bev_cars + fertiizer_manure + fertilizer_organic + ANHYDROUS_AMMONIA  + AMMONIUM_NITRATE_1 + NITRATE_SOLUTION + UREA | cbsa_code + site_number  + year + month,  # Fixed effects
  data = panel_data_did, 
  cluster = "county"  # Cluster SEs at site level
)

# View results
summary(did_model)

summary(did_model, se = "hetero")



#####
#####
##### Model 1 #####
#####
#####


# Run the Difference-in-Differences (DiD) model
did_model <- feols(
  (no2_ppb) ~ Treatment_zip * Post  + population + income_per_capita| cbsa_code + site_number  + year + month,  # Fixed effects
  data = panel_data_did, 
  cluster = "county"  # Cluster SEs at site level
)

# View results
summary(did_model)

summary(did_model, se = "hetero")



#####
#####
##### Model 3 #####
#####
#####


# Run the Difference-in-Differences (DiD) model
did_model <- feols(
  (no2_ppb) ~ Treatment_zip * Post  + population + income_per_capita + total_cars + num_bev_cars| cbsa_code + site_number  + year + month,  # Fixed effects
  data = panel_data_did, 
  cluster = "county"  # Cluster SEs at site level
)

# View results
summary(did_model)

summary(did_model, se = "hetero")


#####
#####
##### Model 4 #####
#####
#####

# Check for any problematic values
summary(panel_data_did$no2_ppb)  # Look for negative values, Inf, or extreme values

# Ensure all values are non-negative before taking log
panel_data_did$no2_ppb_clean <- ifelse(panel_data_did$no2_ppb < 0 | is.na(panel_data_did$no2_ppb), 0, panel_data_did$no2_ppb)

# Now apply log1p safely
panel_data_did$log_no2_ppb <- log1p(panel_data_did$no2_ppb_clean)

# Run the Difference-in-Differences (DiD) model
did_model <- feols(
  (no2_ppb) ~ Treatment_zip * Post  + (population) + (income_per_capita) + total_cars + num_bev_cars + fertiizer_manure + fertilizer_organic + total_fertilizer + ANHYDROUS_AMMONIA  + AMMONIUM_NITRATE_1 + NITRATE_SOLUTION + UREA| cbsa_code + site_number  + year + month,  # Fixed effects
  data = panel_data_did, 
  cluster = "county"  # Cluster SEs at site levelt
)

# View results
summary(did_model)

summary(did_model, se = "hetero")
