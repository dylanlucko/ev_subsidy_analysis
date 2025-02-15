

library(dplyr)
library(ggplot2)

library(dplyr)
library(lubridate)

# Fix the issue by ensuring `year` and `month` are numeric before formatting as date

did_plot_data <- panel_data_did %>%
  mutate(year = as.numeric(as.character(year)))

did_plot_data <- did_plot_data %>%
  mutate(month = as.numeric(as.character(month)))

did_plot_data <- panel_data_did %>%
  group_by(month_year, Treatment_zip) %>%
  summarise(avg_no2 = mean(no2_ppb, na.rm = TRUE), .groups = "drop")

did_plot_data <- did_plot_data %>%
  mutate(month_year = as.Date(month_year))

# Plot parallel trends
ggplot(did_plot_data, aes(x = month_year, y = avg_no2, color = as.factor(Treatment_zip))) +
  geom_line(size = 1) +
  geom_vline(xintercept = as.Date("2011-01-01"), linetype = "dashed", color = "black") +  # Treatment date
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  labs(
    title = "Parallel Trends in Monthly NO2 Levels (Treatment vs. Control)",
    x = "Year",
    y = "Average NO2 (ppb)",
    color = "Treatment Group"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


###########
###########
########### Plot 1B ###########
###########
###########

# Plot parallel trends with different line types and point shapes
ggplot(did_plot_data, aes(x = month_year, y = avg_no2, 
                          color = as.factor(Treatment_zip), 
                          linetype = as.factor(Treatment_zip),
                          shape = as.factor(Treatment_zip))) +
  geom_line(size = 1) +  
  geom_point(size = 2) +  # Add point markers for further differentiation
  geom_vline(xintercept = as.Date("2011-01-01"), linetype = "dashed", color = "black") +  # Treatment date
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_linetype_manual(values = c("solid", "solid")) +  # Different line types
  scale_shape_manual(values = c(16, 17)) +  # Different shapes (circle and triangle)
  labs(
    title = "Parallel Trends in Monthly NO2 Levels (Treatment vs. Control)",
    x = "Year",
    y = "Average NO2 (ppb)",
    color = "Treatment Group",
    linetype = "Treatment Group",
    shape = "Treatment Group"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


###########
###########
########### Plot 1C #########
###########
###########

library(ggplot2)
library(dplyr)

# Filter data to only include observations up to March 2011
did_plot_data_filtered <- did_plot_data %>%
  filter(month_year <= as.Date("2011-03-31"))

# Plot parallel trends with different line types and point shapes
ggplot(did_plot_data_filtered, aes(x = month_year, y = avg_no2, 
                                   color = as.factor(Treatment_zip), 
                                   linetype = as.factor(Treatment_zip),
                                   shape = as.factor(Treatment_zip))) +
  geom_line(size = 1) +  
  geom_point(size = 2) +  # Add point markers for further differentiation
  geom_vline(xintercept = as.Date("2011-01-01"), linetype = "dashed", color = "black") +  # Treatment date
  scale_x_date(date_breaks = "1 month", date_labels = "%b %Y", 
               limits = c(min(did_plot_data_filtered$month_year), as.Date("2011-03-31"))) +  # Limit x-axis
  scale_linetype_manual(values = c("solid", "dashed")) +  # Different line types
  scale_shape_manual(values = c(16, 17)) +  # Different shapes (circle and triangle)
  labs(
    title = "Parallel Trends in Monthly NO2 Levels (Ending in March 2011)",
    x = "Year",
    y = "Average NO2 (ppb)",
    color = "Treatment Group",
    linetype = "Treatment Group",
    shape = "Treatment Group"
  ) +
  theme_minimal() +
  theme(legend.position = "right")



###########
###########
########### Plot 1D #########
###########
###########

library(ggplot2)
library(lubridate)

# Define major x-axis breaks (January of each year)
breaks_x <- seq(from = as.Date("2010-01-01"), to = as.Date("2016-12-31"), by = "1 year")

# Plot parallel trends with cleaned X-axis
ggplot(did_plot_data_filtered, aes(x = month_year, y = avg_no2, 
                          color = as.factor(Treatment_zip), 
                          linetype = as.factor(Treatment_zip),
                          shape = as.factor(Treatment_zip))) +
  geom_line(size = 1) +  
  geom_point(size = 2) +  # Add point markers for differentiation
  geom_vline(xintercept = as.Date("2011-01-01"), linetype = "dashed", color = "black") +  # Treatment date
  scale_x_date(breaks = breaks_x, date_labels = "%b %Y") +  # Only show January of each year
  scale_linetype_manual(values = c("solid", "dashed")) +  # Different line types
  scale_shape_manual(values = c(16, 17)) +  # Different shapes (circle and triangle)
  labs(
    title = "Parallel Trends in Monthly NO2 Levels (Treatment vs. Control)",
    x = "Year",
    y = "Average NO2 (ppb)",
    color = "Treatment Group",
    linetype = "Treatment Group",
    shape = "Treatment Group"
  ) +
  theme_minimal() +
  theme(legend.position = "right", axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate labels for readability


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


#############
#############
############# Lead Lags #######
#############
#############

library(fixest)
library(ggplot2)
library(dplyr)
library(broom)

# Ensure date is in proper format and extract year
panel_data_did <- panel_data_did %>%
  mutate(
    date = as.Date(date, format = "%Y-%m-%d"),
    year = as.numeric(format(date, "%Y")),  # Extract year
    year = factor(year)  # Convert to factor
  )

# Run the event study model
event_study_model <- feols(
  no2_ppb ~ i(year, Treatment_zip*Post , ref = "2010") | cbsa_code + site_number + month,  
  data = panel_data_did, cluster = "county"
)

# Extract coefficients for plotting
event_study_df <- broom::tidy(event_study_model, conf.int = TRUE)

# Convert year column for plotting
event_study_df <- event_study_df %>%
  mutate(term = as.numeric(gsub("year::", "", term)))  # Extract numeric year from term

# Verify that term values are correctly extracted
print(event_study_df)


# Manually extract year numbers from term column
event_study_df <- event_study_df %>%
  mutate(term = row_number() + 2009)  # Assuming the first row is 2010, incrementing accordingly

# Verify if `term` now has valid years
print(event_study_df)


# Plot event study results
ggplot(event_study_df, aes(x = term, y = estimate)) +
  geom_point(size = 3) +
  geom_line() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high), width = 0.2) +
  geom_vline(xintercept = 2011, linetype = "dashed", color = "black") +  # Treatment year
  labs(
    title = "Lead-Lag Analysis: NO_2 Changes Over Time",
    x = "Year (Lead/Lag)",
    y = "Coefficient Estimate",
    caption = "Dashed line represents treatment year (2011)."
  ) +
  theme_minimal()

