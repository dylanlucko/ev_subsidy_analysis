
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "sandram44",
    "param": "42603",  # Ozone
    "bdate": "20040101",  # Start date
    "edate": "20041231",  # End date
    "state": "06"  # California
}

# Make the API request
response = requests.get(url, params=params)

# Check if the request was successful
if response.status_code == 200:
    # Parse the JSON response
    data = response.json()
    
    # Check if there's data
    if "Data" in data:
        # Convert to a pandas DataFrame
        df = pd.DataFrame(data["Data"])
        
        # Save to CSV
        df.to_csv("daily_air_quality_data.csv", index=False)
        print("Data saved to 'daily_air_quality_data.csv'.")
    else:
        print("No data found in the API response.")
else:
    print(f"Failed to fetch data. Status code: {response.status_code}")

# %%
