#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
#%%
import requests
import pandas as pd

# API URL
url = "https://aqs.epa.gov/data/api/dailyData/byState"
params = {
    "email": "dlucko@hbs.edu",
    "key": "goldosprey13",
    "param": "42602",  # NO2
    "state": "06"  # California
}

# Loop through each year from 2004 to 2015
for year in range(2004, 2019):
    # Set the start and end dates for the current year
    bdate = f"{year}0101"
    edate = f"{year}1231"
    
    # Update the date parameters
    params["bdate"] = bdate
    params["edate"] = edate
    
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
            
            # Save to a CSV file named by the year
            csv_filename = f"42602_04_18_daily_air_quality_data_{year}.csv"
            df.to_csv(csv_filename, index=False)
            print(f"Data for {year} saved to '{csv_filename}'.")
        else:
            print(f"No data found for {year}.")
    else:
        print(f"Failed to fetch data for {year}. Status code: {response.status_code}")

# %%
