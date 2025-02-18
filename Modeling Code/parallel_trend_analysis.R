#parallel_trend_analysis
# Source the preamble script to load necessary functions and libraries
source("C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/Data Preprocessing Code/preamble.R")
panel_data_did <- read.csv("~/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/panel_data_did_2_13.csv")


# Convert year to factor for proper event study estimation
panel_data_did <- panel_data_did %>%
  mutate(year = as.factor(year)) 

# Run the event study model (leads and lags of Treatment)
event_study_model <- feols(
  no2_ppb ~ i(year, Treatment_zip, ref = 2010) | cbsa_code + site_number + month,  
  data = panel_data_did, cluster = "county"
)

# Extract coefficients for pre-trends test
event_study_df <- broom::tidy(event_study_model, conf.int = TRUE) %>%
  filter(as.numeric(gsub("year::", "", term)) < 2011)  # Keep only pre-treatment years

# Plot pre-treatment coefficients
ggplot(event_study_df, aes(x = as.numeric(gsub("year::", "", term)), y = estimate)) +
  geom_point(size = 3) +
  geom_line() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  # Reference line at 0
  labs(
    title = "Parallel Trends Test: Event Study Coefficients (Pre-Treatment)",
    x = "Year (Lead)",
    y = "Coefficient Estimate",
    caption = "Dashed line represents expected parallel trends."
  ) +
  theme_minimal()

panel_data_did <- panel_data_did %>%
  mutate(year = as.numeric(as.character(year)))

# Create a placebo treatment variable for 2009
panel_data_did_test <- panel_data_did %>%
  mutate(Post_Placebo = ifelse(year >= 2010, 1, 0))

# Run the placebo DiD model (assuming treatment started in 2009 instead of 2011)
placebo_did_model <- feols(
  no2_ppb ~ Treatment_zip * Post_Placebo + population + income_per_capita | cbsa_code + site_number + year + month,  
  data = panel_data_did_test, cluster = "county"
)

# View results
summary(placebo_did_model)



#######
#######
#######  3 ######
#######
#######


# Generate pre-treatment time interactions
panel_data_did_test <- panel_data_did %>%
  mutate(pre_trend_2011 = ifelse(year == 2009 & Treatment_zip == 1, 1, 0),
         pre_trend_2010 = ifelse(year == 2010 & Treatment_zip == 1, 1, 0))

# Run DiD with pre-trend interactions
pre_trend_model <- feols(
  no2_ppb ~ pre_trend_2011 + pre_trend_2010 + Treatment_zip * Post + population + income_per_capita | cbsa_code + site_number + year + month,  
  data = panel_data_did_test, cluster = "county"
)

# View results
summary(pre_trend_model)


write.csv(panel_data_did, "panel_data_did_2_15.csv")





#################
#################
#################



# Run DiD with pre-trend interactions
pre_trend_model <- feols(
  no2_ppb ~ pre_trend_2011 + pre_trend_2010 + Treatment_zip * Post + population + income_per_capita + total_cars+ num_bev_cars  + fertiizer_manure + fertilizer_organic + total_fertilizer + ANHYDROUS_AMMONIA  + AMMONIUM_NITRATE_1 + NITRATE_SOLUTION + UREA |   year + month,  
  data = panel_data_did_test, cluster = "county"
)

# View results
summary(pre_trend_model)
