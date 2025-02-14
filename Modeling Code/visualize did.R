

library(dplyr)
library(ggplot2)

library(dplyr)
library(lubridate)

# Fix the issue by ensuring `year` and `month` are numeric before formatting as date
did_plot_data <- panel_data_did %>%
  group_by(year, month, Treatment_zip) %>%
  summarise(avg_no2 = mean(no2_ppb, na.rm = TRUE), .groups = "drop") %>%
  mutate(
    year = as.numeric(year),  # Ensure year is numeric
    month = as.numeric(month),  # Ensure month is numeric
    YearMonth = as.Date(paste(year, sprintf("%02d", month), "01", sep = "-"))  # Format correctly
  )


# Plot parallel trends
ggplot(did_plot_data, aes(x = YearMonth, y = avg_no2, color = as.factor(Treatment_zip))) +
  geom_line(size = 1) +
  geom_vline(xintercept = as.Date("2011-01-01"), linetype = "dashed", color = "black") +  # Treatment date
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(
    title = "Parallel Trends in NO2 Levels (Treatment vs. Control)",
    x = "Year",
    y = "Average NO2 (ppb)",
    color = "Treatment Group"
  ) +
  theme_minimal() +
  theme(legend.position = "right")



###########
###########
########### Plot 2 #########
###########
###########


library(broom)  # For extracting regression coefficients
library(ggplot2)

# Extract coefficients and confidence intervals from the model
coef_df <- broom::tidy(did_model, conf.int = TRUE) %>%
  filter(term %in% c("Treatment_zip", "Post", "Treatment_zip:Post"))  # Keep only key terms

# Plot coefficient estimates
ggplot(coef_df, aes(x = term, y = estimate)) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.2) +
  labs(
    title = "Estimated Treatment Effects from DiD Model",
    x = "Variable",
    y = "Coefficient Estimate"
  ) +
  theme_minimal()


#########
#########
######### Plot 3 #########
#########
#########

library(fixest)
library(ggplot2)

# Estimate event study model
event_study_model <- feols(
  no2_ppb ~ i(year, Treatment_zip, ref = 2010) | cbsa_code + site_number + month,  # 2010 as reference year
  data = panel_data_did, cluster = "county"
)

# Extract coefficients
event_study_df <- broom::tidy(event_study_model, conf.int = TRUE)

# Plot event study results
ggplot(event_study_df, aes(x = as.numeric(term), y = estimate)) +
  geom_point(size = 3) +
  geom_line() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.2) +
  geom_vline(xintercept = 2011, linetype = "dashed", color = "black") +  # Treatment year
  labs(
    title = "Event Study: NO2 Changes Over Time",
    x = "Year",
    y = "Coefficient Estimate"
  ) +
  theme_minimal()


##########
##########
##########  Plot 4  ########
##########
##########

library(dplyr)
library(ggplot2)

# Ensure date is in proper format
panel_data_did <- panel_data_did %>%
  mutate(date = as.Date(date, format = "%Y-%m-%d"))

# Create scatter plot of daily NO2 before and after treatment
ggplot(panel_data_did, aes(x = date, y = no2_ppb, color = as.factor(Post))) +
  geom_point(alpha = 0.5, size = 1) +  
  scale_color_manual(values = c("0" = "blue", "1" = "red"), labels = c("Pre-Treatment", "Post-Treatment")) +
  labs(
    title = "Daily NO₂ Concentrations Before and After Treatment",
    x = "Date",
    y = "NO₂ (ppb)",
    color = "Period"
  ) +
  theme_minimal()
