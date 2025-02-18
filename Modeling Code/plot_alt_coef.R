

##############
##############

library(ggplot2)
library(dplyr)

# Create a dataframe for EV adoption thresholds and NO2 reductions
ev_adoption_df <- data.frame(
  Threshold = rep(c("15% EV Adoption", "25% EV Adoption", "35% EV Adoption"), each = 100),
  Time = rep(seq(0, 10, length.out = 100), 3),  # X-axis simulating time progression
  Coefficient = rep(c(-0.61747566, -0.68864040, -0.62164765), each = 100)  # Regression coefficients
)

# Create parabolic NO2 trajectories: Start at 15 and dip down by coefficient
ev_adoption_df <- ev_adoption_df %>%
  mutate(Mean_NO2_ppb = 15 - Coefficient * (Time - 5)^2 / 25)  # Quadratic shape to simulate gradual dip

# Plot NO2 changes over time for each threshold
ggplot(ev_adoption_df, aes(x = Time, y = Mean_NO2_ppb, color = Threshold, group = Threshold)) +
  geom_line(size = 1.2) +
  geom_point(data = ev_adoption_df %>% filter(Time == 5), aes(x = Time, y = Mean_NO2_ppb), size = 4) +  
  labs(
    title = "Effect of EV Adoption on NO₂ Concentrations Over Time",
    x = "Time (Arbitrary Units)",
    y = "Mean NO₂ (ppb)",
    color = "EV Adoption Threshold"
  ) +
  theme_minimal()
