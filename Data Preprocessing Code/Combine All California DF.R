

# Load necessary library
library(dplyr)

# Set the folder containing the CSV files
folder_path <- "C:/Users/dlucko/Desktop/2025/EV Paper/California Data"

# Get a list of all CSV files in the folder
file_list <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

# Initialize an empty data frame to store the combined data
combined_data <- data.frame()

# Loop through each file and read the data
for (file in file_list) {
  # Read the current CSV file
  data <- read.csv(file)
  
  # Combine the data into the master data frame
  combined_data <- bind_rows(combined_data, data)
}

# Save the combined data as a new CSV file
write.csv(combined_data, file = "C:/Users/dlucko/Desktop/2025/EV Paper/California_Data_Combined.csv", row.names = FALSE)

# Print completion message
cat("All files combined and saved as 'California_Data_Combined.csv'.\n")
