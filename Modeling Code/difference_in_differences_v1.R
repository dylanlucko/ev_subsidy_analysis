#difference_in_differences

panel_data_did <- read.csv("~/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache/panel_data_2_9.csv")

colnames(panel_data_did)

panel_data_did <- panel_data_did %>%
  select(-c(X.1, X, X.y))


colnames(panel_data_did)

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
  (no2_ppb) ~ Treatment_zip * Post + (population) + (income_per_capita) + total_fertilizer  +  total_cars + num_bev_cars + chemical_insecticide  | cbsa_code  + year + month,  # Fixed effects
  data = panel_data_did, 
  cluster = "county"  # Cluster SEs at site level
)

# View results
summary(did_model)

summary(did_model, se = "hetero")
