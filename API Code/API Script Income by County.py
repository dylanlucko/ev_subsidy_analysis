

#%%
import requests

# BEA API URL
BASE_URL = "https://apps.bea.gov/api/data"

# Parameters for the API request
params = {
    "UserID": "DABB203F-BDDF-45C4-A050-C2A99A621434",  # Replace with your BEA API key
    "method": "GetData",
    "datasetname": "Regional",
    "TableName": "CAINC4",  # Personal income by major component
    "GeoFIPS": "COUNTY",    # All counties
    "Year": ",".join(map(str, range(2004, 2019))),  # Years 2004 to 2015
    "ResultFormat": "json"  # Requesting data in JSON format
}

# Make the API request
response = requests.get(BASE_URL, params=params)

# Check for successful response
if response.status_code == 200:
    data = response.json()
    print("Data retrieved successfully!")
    # Process the JSON data (e.g., save to a file or display)
    print(data)
else:
    print(f"Error: {response.status_code}")
    print(response.text)

# %%


import requests

# BEA API URL
BASE_URL = "https://apps.bea.gov/api/data"

# Parameters to retrieve LineCode values
params = {
    "UserID": "DABB203F-BDDF-45C4-A050-C2A99A621434",  # Replace with your BEA API key
    "method": "GetParameterValuesFiltered",
    "datasetname": "Regional",
    "TargetParameter": "LineCode",
    "TableName": "CAINC4",
    "ResultFormat": "json"
}

# Make the API request
response = requests.get(BASE_URL, params=params)

# Check the response
if response.status_code == 200:
    data = response.json()
    print("LineCode values retrieved successfully!")
    print(data)
else:
    print(f"Error: {response.status_code}")
    print(response.text)

params = {
    "UserID": "Your-36Character-Key",
    "method": "GetData",
    "datasetname": "Regional",
    "TableName": "CAINC4",
    "GeoFIPS": "COUNTY",
    "Year": "2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015",
    "LineCode": "10",  # Example LineCode (update based on your requirement)
    "ResultFormat": "json"
}

response = requests.get(BASE_URL, params=params)

# %%


import requests

# BEA API URL
BASE_URL = "https://apps.bea.gov/api/data"

# Parameters for the API request
params = {
    "UserID": "DABB203F-BDDF-45C4-A050-C2A99A621434",  # Replace with your BEA API key
    "method": "GetData",
    "datasetname": "Regional",
    "TableName": "CAINC4",
    "GeoFIPS": "COUNTY",  # All counties
    "Year": "2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015",  # Years 2004–2015
    "LineCode": "30",  # Example: Per capita personal income
    "ResultFormat": "json"  # Requesting data in JSON format
}

# Make the API request
response = requests.get(BASE_URL, params=params)

# Check for successful response
if response.status_code == 200:
    data = response.json()
    print("Data retrieved successfully!")
    print(data)  # Print or process the retrieved data
else:
    print(f"Error: {response.status_code}")
    print(response.text)

# %%
params = {
    "UserID": "DABB203F-BDDF-45C4-A050-C2A99A621434",  # Your BEA API key
    "method": "GetData",
    "datasetname": "Regional",
    "TableName": "CAINC4",
    "GeoFIPS": "COUNTY",
    "Year": "2004",  # Single year
    "LineCode": "30",  # Per capita personal income
    "ResultFormat": "json"
}

response = requests.get(BASE_URL, params=params)

if response.status_code == 200:
    data = response.json()
    print("Small Query Response:")
    print(data)
else:
    print(f"Error: {response.status_code}")
    print(response.text)

# %%


if response.status_code == 200:
    data = response.json()
    results = data.get("BEAAPI", {}).get("Results", {}).get("Data", [])
    if results:
        print("Retrieved Data:")
        for entry in results:
            print(entry)
    else:
        print("No data found in the response.")
else:
    print(f"Error: {response.status_code}")
    print(response.text)

# %%


import requests

# BEA API URL
BASE_URL = "https://apps.bea.gov/api/data"

# Parameters for the API request
params = {
    "UserID": "DABB203F-BDDF-45C4-A050-C2A99A621434",  # Replace with your BEA API key
    "method": "GetData",
    "datasetname": "Regional",
    "TableName": "CAINC4",       # Personal income by major component
    "GeoFIPS": "County",            # California state-level FIPS code
    "Year": "2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015, 2016, 2017, 2018",  # Years 2004–2015
    "LineCode": "30",           # Per capita personal income (example)
    "ResultFormat": "json"      # Requesting data in JSON format
}

# Make the API request
response = requests.get(BASE_URL, params=params)

# Process the response
if response.status_code == 200:
    data = response.json()
    results = data.get("BEAAPI", {}).get("Results", {}).get("Data", [])
    
    if results:
        print("Retrieved Data for California:")
        for entry in results:
            print(f"GeoName: {entry['GeoName']}, Year: {entry['TimePeriod']}, Value: {entry['DataValue']}")
    else:
        print("No data found in the response.")
else:
    print(f"Error: {response.status_code}")
    print(response.text)

# %%
import requests
import csv

# BEA API URL
BASE_URL = "https://apps.bea.gov/api/data"

# Parameters for the API request
params = {
    "UserID": "DABB203F-BDDF-45C4-A050-C2A99A621434",  # Replace with your BEA API key
    "method": "GetData",
    "datasetname": "Regional",
    "TableName": "CAINC4",       # Personal income by major component
    "GeoFIPS": "COUNTY",         # All counties in California
    "Year": "2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015, 2016, 2017, 2018",              # Single year example (extend for other years if needed)
    "LineCode": "30",            # Per capita personal income (example)
    "ResultFormat": "json"       # Requesting data in JSON format
}

# Make the API request
response = requests.get(BASE_URL, params=params)

# Process the response
if response.status_code == 200:
    data = response.json()
    results = data.get("BEAAPI", {}).get("Results", {}).get("Data", [])
    
    if results:
        print("Retrieved Data for California. Saving to CSV...")
        
        # Save to CSV
        with open("california_data.csv", mode="w", newline="", encoding="utf-8") as file:
            writer = csv.writer(file)
            # Write the header
            writer.writerow(["GeoName", "Year", "DataValue", "Unit", "Multiplier"])
            # Write data rows
            for entry in results:
                writer.writerow([
                    entry.get("GeoName", ""), 
                    entry.get("TimePeriod", ""), 
                    entry.get("DataValue", ""), 
                    entry.get("CL_UNIT", ""),  # Unit, e.g., dollars
                    entry.get("UNIT_MULT", "") # Multiplier, e.g., 1 for no multiplier, 6 for millions
                ])
        print("Data saved to 'california_data.csv'.")
    else:
        print("No data found in the response.")
else:
    print(f"Error: {response.status_code}")
    print(response.text)

# %%
