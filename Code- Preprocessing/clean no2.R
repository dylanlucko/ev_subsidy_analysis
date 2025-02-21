
#This script automates the process of merging multiple CSV files from a specified folder into a single dataset. It performs the following steps:
  
# 1. Loads the required dplyr library for efficient data handling.
# 2. Specifies the folder path containing the CSV files.
# 3. Retrieves a list of all CSV files within the folder.
# 4. Iterates through each file, reads the data, and appends it to a master dataset.
# 5. Combines all individual CSVs into a single data frame using bind_rows().
# 6. Saves the merged dataset as a new CSV file in the specified directory.
# 7. Prints a confirmation message once the process is completed.

# Source the preamble script to load necessary functions and libraries
source("C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/Data Preprocessing Code/preamble.R")


# Set the folder containing the CSV files
folder_path <- "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/California Data 42602"

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
write.csv(combined_data, file = "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/42602_04_18_California_Data_Combined.csv", row.names = FALSE)

# Print completion message
cat("All files combined and saved as '42602_04_18_California_Data_Combined.csv'.\n")
