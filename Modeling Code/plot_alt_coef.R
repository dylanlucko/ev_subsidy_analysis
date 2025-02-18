

##############
##############

library(ggplot2)
library(dplyr)


library(ggplot2)

ev_adoption_df <- data.frame(
  Threshold = c("15% EV Adoption", "25% EV Adoption", "35% EV Adoption"),
  Reduction = c(-0.61747566, -0.68864040, -0.62164765),  # Coefficients (NO2 decrease)
  SE = c(0.25714653, 0.25004344, 0.25083377)  # Standard errors
)

# Compute NO2 levels after reduction
ev_adoption_df <- ev_adoption_df %>%
  mutate(Final_NO2 = 10.31522 + Reduction) 

# Plot NO2 reductions at each EV adoption threshold
ggplot(ev_adoption_df, aes(x = Threshold, y = Final_NO2, color = Threshold)) +
  geom_point(size = 4) +
  geom_segment(aes(xend = Threshold, y = 10.31522, yend = Final_NO2), linetype = "dashed") +
  labs(
    title = "Effect of EV Adoption on NO₂ Levels",
    x = "EV Adoption Threshold",
    y = "Final NO₂ (ppb)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")  # Remove legend for clarity



################


ggplot(ev_adoption_df, aes(x = Threshold, y = Final_NO2, fill = Threshold)) +
  geom_bar(stat = "identity", color = "black") +
  labs(
    title = "Effect of EV Adoption on NO₂ Levels",
    x = "EV Adoption Threshold",
    y = "Final NO₂ (ppb)"
  ) +
  scale_fill_manual(values = c("lightblue", "blue", "darkblue")) +
  theme_minimal() +
  theme(legend.position = "none")



ggplot(ev_adoption_df, aes(x = Threshold, y = Final_NO2, color = Threshold)) +
  geom_segment(aes(xend = Threshold, y = 10.31522, yend = Final_NO2), linetype = "dashed") +
  geom_point(size = 5) +
  labs(
    title = "NO₂ Reduction by EV Adoption Threshold",
    x = "EV Adoption Threshold",
    y = "Final NO₂ (ppb)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")



ggplot(ev_adoption_df, aes(x = Threshold, y = Final_NO2, color = Threshold)) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymin = Final_NO2 - SE, ymax = Final_NO2 + SE), width = 0.2, color = "black") +
  labs(
    title = "Effect of EV Adoption on NO₂ Levels with Uncertainty",
    x = "EV Adoption Threshold",
    y = "Final NO₂ (ppb)"
  ) +
  theme_minimal() +
  theme(legend.position = "none")



# Create long-format data to show slope
ev_slope_df <- data.frame(
  Threshold = rep(ev_adoption_df$Threshold, each = 2),
  Stage = rep(c("Pre", "Post"), times = nrow(ev_adoption_df)),
  NO2_Level = c(rep(10.31522, nrow(ev_adoption_df)), ev_adoption_df$Final_NO2)
)

ggplot(ev_slope_df, aes(x = Stage, y = NO2_Level, group = Threshold, color = Threshold)) +
  geom_line(size = 1.2) +
  geom_point(size = 4) +
  labs(
    title = "Change in NO₂ Levels Pre- and Post- EV Adoption",
    x = "Stage",
    y = "NO₂ (ppb)"
  ) +
  theme_minimal() +
  theme(legend.position = "right")



###################
###################
###################



library(ggplot2)
library(dplyr)

# Create a dataframe for NO2 levels over time for different EV adoption thresholds
ev_adoption_df <- data.frame(
  Time = rep(seq(0, 1, length.out = 100), 3),  # Time progression (scaled to 0-1 for smooth curve)
  Threshold = rep(c("15% EV Adoption", "25% EV Adoption", "35% EV Adoption"), each = 100),
  Reduction = rep(c(-0.61747566, -0.68864040, -0.62164765), each = 100),  # Regression coefficients
  SE = rep(c(0.25714653, 0.25004344, 0.25083377), each = 100)  # Standard errors
)

# Compute NO2 levels over time
ev_adoption_df <- ev_adoption_df %>%
  mutate(
    NO2_Level = 10.31522 + Reduction * Time^2,  # Quadratic decrease (parabolic shape)
    X_Axis = ifelse(Time == 1, as.numeric(factor(Threshold, levels = c("15% EV Adoption", "25% EV Adoption", "35% EV Adoption"))), NA)  # X position for SE markers
  )

# Plot NO2 reductions over time for each EV adoption threshold
ggplot(ev_adoption_df, aes(x = Time, y = NO2_Level, group = Threshold, linetype = Threshold, shape = Threshold)) +
  geom_line(size = 1.2) +  # Plot curved lines
  geom_point(data = ev_adoption_df %>% filter(Time == 1), aes(x = X_Axis, y = NO2_Level), size = 4) +  # Add endpoint markers
  geom_errorbar(data = ev_adoption_df %>% filter(Time == 1), 
                aes(x = X_Axis, ymin = NO2_Level - SE, ymax = NO2_Level + SE), 
                width = 0.1, color = "black") +  # Error bars at endpoints
  scale_x_continuous(breaks = c(0, 1), labels = c("Pre", "Post")) +  # Label x-axis as "Pre" and "Post"
  scale_linetype_manual(values = c("solid", "dashed", "dotted")) +  # Different line types for BW printing
  scale_shape_manual(values = c(16, 17, 18)) +  # Different point shapes for BW printing
  labs(
    title = "Effect of EV Adoption on NO₂ Levels",
    x = "",
    y = "NO₂ Levels (ppb)",
    linetype = "EV Adoption Threshold",
    shape = "EV Adoption Threshold"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


###################
###################
###################


library(ggplot2)
library(dplyr)

# Define the initial NO2 level (pre-treatment mean)
initial_NO2 <- 10.31522

# Create a dataframe with NO2 levels over time for different EV adoption thresholds
ev_adoption_df <- data.frame(
  Time = rep(seq(0, 1, length.out = 100), 3),  # Simulated time progression
  Threshold = rep(c("15% EV Adoption", "25% EV Adoption", "35% EV Adoption"), each = 100),
  Reduction = rep(c(-0.61747566, -0.68864040, -0.62164765), each = 100),  # Regression coefficients
  SE = rep(c(0.25714653, 0.25004344, 0.25083377), each = 100)  # Standard errors
)

# Compute NO2 levels over time, ensuring each line reaches its own final NO2 level
ev_adoption_df <- ev_adoption_df %>%
  mutate(
    X_Axis = case_when(
      Threshold == "15% EV Adoption" ~ 1.0,
      Threshold == "25% EV Adoption" ~ 1.1,
      Threshold == "35% EV Adoption" ~ 1.2
    ),  # Adjust final x-values to make them closer together
    NO2_Level = initial_NO2 + Reduction * Time^2  # Quadratic decrease for parabolic shape
  )

# Extract only the final data points for error bars and endpoint markers
final_points <- ev_adoption_df %>%
  filter(Time == 1)  # Select only the last time point

# Plot NO2 reductions over time for each EV adoption threshold
ggplot(ev_adoption_df, aes(x = Time, y = NO2_Level, group = Threshold, linetype = Threshold, shape = Threshold)) +
  geom_line(size = 1.2) +  # Plot curved lines
  geom_point(data = final_points, aes(x = X_Axis, y = NO2_Level), size = 4) +  # Add endpoint markers
  geom_errorbar(data = final_points, aes(x = X_Axis, ymin = NO2_Level - SE, ymax = NO2_Level + SE), 
                width = 0.05, color = "black") +  # Error bars at endpoints
  scale_x_continuous(breaks = c(0, 1.05, 1.1, 1.15), labels = c("Pre", "15%", "25%", "35%")) +  # Adjusted x-axis labels
  scale_linetype_manual(values = c("solid", "dashed", "dotted")) +  # Different line types for BW printing
  scale_shape_manual(values = c(16, 17, 18)) +  # Different point shapes for BW printing
  labs(
    title = "Effect of EV Adoption on NO₂ Levels",
    x = "",
    y = "NO₂ Levels (ppb)",
    linetype = "EV Adoption Threshold",
    shape = "EV Adoption Threshold"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


#########
#########

library(ggplot2)
library(dplyr)

# Define the initial NO2 level (pre-treatment mean)
initial_NO2 <- 10.31522

# Define thresholds and their reductions
ev_adoption_df <- data.frame(
  Threshold = c("15% EV Adoption", "25% EV Adoption", "35% EV Adoption"),
  Final_NO2 = initial_NO2 + c(-0.61747566, -0.68864040, -0.62164765),  # Apply reductions
  SE = c(0.25714653, 0.25004344, 0.25083377)  # Standard errors
)

# Define time progression for each threshold separately
time_seq <- seq(0, 1, length.out = 100)

# Expand dataframe for plotting each threshold separately
ev_adoption_long <- ev_adoption_df %>%
  slice(rep(1:n(), each = length(time_seq))) %>%  # Repeat each row for each time step
  mutate(
    Time = rep(time_seq, nrow(ev_adoption_df)),  # Assign time progression
    NO2_Level = initial_NO2 + (Final_NO2 - initial_NO2) * Time^2,  # Quadratic decrease
    X_Axis = case_when(
      Threshold == "15% EV Adoption" ~ 1.05,
      Threshold == "25% EV Adoption" ~ 1.10,
      Threshold == "35% EV Adoption" ~ 1.15
    ))  # Adjust final x positions to be closer

# Extract only the final data points for error bars and endpoint markers
final_points <- ev_adoption_long %>%
  filter(Time == 1)  # Select only the last time point

# Plot NO2 reductions over time for each EV adoption threshold
ggplot(ev_adoption_long, aes(x = Time, y = NO2_Level, group = Threshold, linetype = Threshold, shape = Threshold)) +
  geom_line(size = 1.2) +  # Plot curved lines
  geom_point(data = final_points, aes(x = X_Axis, y = NO2_Level), size = 4) +  # Add endpoint markers
  geom_errorbar(data = final_points, aes(x = X_Axis, ymin = NO2_Level - SE, ymax = NO2_Level + SE), 
                width = 0.03, color = "black") +  # Adjust error bars for clarity
  scale_x_continuous(breaks = c(0, 1.05, 1.10, 1.15), labels = c("Pre", "15%", "25%", "35%")) +  # Adjusted x-axis labels
  scale_linetype_manual(values = c("solid", "dashed", "dotted")) +  # Different line types for BW printing
  scale_shape_manual(values = c(16, 17, 18)) +  # Different point shapes for BW printing
  labs(
    title = "Effect of EV Adoption on NO₂ Levels",
    x = "",
    y = "NO₂ Levels (ppb)",
    linetype = "EV Adoption Threshold",
    shape = "EV Adoption Threshold"
  ) +
  theme_minimal() +
  theme(legend.position = "right", axis.text.x = element_text(size = 12))


###########
###########
############


library(ggplot2)
library(dplyr)

# Define the initial NO2 level (pre-treatment mean)
initial_NO2 <- 10.31522

# Define thresholds and their reductions
ev_adoption_df <- data.frame(
  Threshold = c("15% EV Adoption", "25% EV Adoption", "35% EV Adoption"),
  Final_NO2 = initial_NO2 + c(-0.61747566, -0.68864040, -0.62164765),  # Apply reductions
  SE = c(0.25714653, 0.25004344, 0.25083377)  # Standard errors
)

# Define time progression
time_seq <- seq(0, 1, length.out = 100)

# Expand dataframe for plotting
ev_adoption_long <- ev_adoption_df %>%
  slice(rep(1:n(), each = length(time_seq))) %>%
  mutate(
    Time = rep(time_seq, nrow(ev_adoption_df)),  # Time progression
    NO2_Level = initial_NO2 + (Final_NO2 - initial_NO2) * (1 - (1 - Time)^3),  # Smooth cubic decay
    X_Axis = case_when(
      Threshold == "15% EV Adoption" ~ 1.05,
      Threshold == "25% EV Adoption" ~ 1.08,
      Threshold == "35% EV Adoption" ~ 1.11
    )  # Assign separate final x positions for readability
  )

# Extract final points for error bars
final_points <- ev_adoption_long %>%
  filter(Time == 1)

# Plot NO2 reductions over time for each EV adoption threshold
ggplot(ev_adoption_long, aes(x = Time, y = NO2_Level, group = Threshold, linetype = Threshold, shape = Threshold)) +
  geom_line(size = 1.2) +  # Smooth curved lines
  geom_point(data = final_points, aes(x = X_Axis, y = NO2_Level), size = 4) +  # End markers
  geom_errorbar(data = final_points, aes(x = X_Axis, ymin = NO2_Level - SE, ymax = NO2_Level + SE), 
                width = 0.02, color = "black") +  # Error bars at endpoints
  scale_x_continuous(breaks = c(0, 1.05, 1.08, 1.11), labels = c("Pre", "15%", "25%", "35%")) +  # Adjusted x-axis labels
  scale_linetype_manual(values = c("solid", "dashed", "dotted")) +  # Different line types for BW printing
  scale_shape_manual(values = c(16, 17, 18)) +  # Different point shapes for BW printing
  labs(
    title = "Effect of EV Adoption on NO₂ Levels",
    x = "",
    y = "NO₂ Levels (ppb)",
    linetype = "EV Adoption Threshold",
    shape = "EV Adoption Threshold"
  ) +
  theme_minimal() +
  theme(legend.position = "right")


##########
##########
##########


