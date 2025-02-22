* (Optional: Set your working directory)
cd "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/"

* Import the CSV data file (adjust the path if necessary)
import delimited "panel_data_did_2_13.csv", clear

* Verify the imported variables
describe

* Drop unwanted columns
* (Assumes the unwanted variables are named: X_1, X, X_y, and X_2;
   adjust the variable names if they differ in your file.)
drop X_1 X X_y X_2* (Optional: Set your working directory)
cd "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/"

* Import the CSV data file (adjust the path if necessary)
import delimited "panel_data_did_2_13.csv", clear

* Verify the imported variables
describe

* Drop unwanted columns
* (Assumes the unwanted variables are named: X_1, X, X_y, and X_2;
   adjust the variable names if they differ in your file.)
drop X_1 X X_y X_2* (Optional: Set your working directory)
cd "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/"

* Import the CSV data file (adjust the path if necessary)
import delimited "panel_data_did_2_13.csv", clear

* Verify the imported variables
describe

* Drop unwanted columns
* (Assumes the unwanted variables are named: X_1, X, X_y, and X_2;
   adjust the variable names if they differ in your file.)
drop X_1 X X_y X_2* (Optional: Set your working directory)
cd "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/"

* Import the CSV data file (adjust the path if necessary)
import delimited "panel_data_did_2_13.csv", clear

* Verify the imported variables
describe

* Drop unwanted columns
* (Assumes the unwanted variables are named: X_1, X, X_y, and X_2;
   adjust the variable names if they differ in your file.)
drop X_1 X X_y X_2* (Optional: Set your working directory)
cd "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/"

* Import the CSV data file (adjust the path if necessary)
import delimited "panel_data_did_2_13.csv", clear

* Verify the imported variables
describe

* Drop unwanted columns
* (Assumes the unwanted variables are named: X_1, X, X_y, and X_2;
   adjust the variable names if they differ in your file.)
drop X_1 X X_y X_2* (Optional: Set your working directory)
cd "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/"

* Import the CSV data file (adjust the path if necessary)
import delimited "panel_data_did_2_13.csv", clear

* Verify the imported variables
describe

* Drop unwanted columns
* (Assumes the unwanted variables are named: X_1, X, X_y, and X_2;
   adjust the variable names if they differ in your file.)
drop X_1 X X_y X_2* (Optional: Set your working directory)
cd "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/"

* Import the CSV data file (adjust the path if necessary)
import delimited "panel_data_did_2_13.csv", clear

* Verify the imported variables
describe

* Drop unwanted columns
* (Assumes the unwanted variables are named: X_1, X, X_y, and X_2;
   adjust the variable names if they differ in your file.)
drop X_1 X X_y X_2/******************************************************************
  STATA DO-FILE: Difference-in-Differences Analysis and EV Adoption
 ******************************************************************/

/*---------------------------------------------------------------
  1. SET UP & DATA IMPORT
---------------------------------------------------------------*/
* (Optional: Set your working directory)
cd "C:/Users/dlucko/Documents/GitHub/ev_subsidy_analysis/EV_NOX_PROJECT/cache_5_50_pct/"

* Import the CSV data file (adjust the path if necessary)
import delimited "panel_data_did_2_13.csv", clear

* Verify the imported variables
describe

* Drop unwanted columns
* (Assumes the unwanted variables are named: X_1, X, X_y, and X_2;
   adjust the variable names if they differ in your file.)
drop X_1 X X_y X_2

/*---------------------------------------------------------------
  2. DATA PREPARATION & VARIABLE CREATION
---------------------------------------------------------------*/
* Compute total number of cars by summing across car type variables
gen total_cars = num_bev_cars + num_diesel_cars + num_flex_fuel_cars + ///
                  num_gasoline_cars + num_gasoline_hybrid_cars + ///
                  num_natural_gas_cars + num_propane_cars + ///
                  num_fuel_cell_cars + num_plug_in_hybrid

* Compute BEV share (as a fraction; multiply by 100 for percentage if desired)
gen bev_share = num_bev_cars / total_cars

* Convert the date string (assumed "YYYY-MM-DD") to a Stata date
gen stata_date = date(date, "YMD")
format stata_date %td

* Extract year and month from the date
gen year = year(stata_date)
gen month = month(stata_date)

* Create the Post indicator: equals 1 if year is 2011 or later, 0 otherwise
gen Post = (year >= 2011)

* Keep only observations from 2010 onward
keep if year >= 2010

/*---------------------------------------------------------------
  3. CLEAN FERTILIZER VARIABLES
---------------------------------------------------------------*/
* Define a local macro with the names of fertilizer variables to clean.
local fertcols "ANHYDROUS_AMMONIA AQUA_AMMONIA AMMONIUM_NITRATE NITRATE_SOLUTION ///
                AMMONIUM_POLYSULFIDE AMMONIUM_SULFATE AMMONIUM_THIOSULFATE BLOOD_MEAL ///
                AMMONIUM_NITRATE_1 CALCIUM_NITRATE SOLUTION_28_ SOLUTION_32_ SODIUM_NITRATE ///
                COATED_UREA UREA UREA_SOLUTION MATERIALS___ALL_OTHER DIAMMONIUM_PHOSPHATE ///
                PHOSPHATE_SULFATE MONOAMMONIUM_PHOSPHATE PHOSPHORIC_ACID ///
                AMMONIUM_POLYPHOSPHATE NORMAL_SUPERPHOSPHATE TRIPLE_SUPERPHOSPHATE ///
                ALL_OTHER OF_POTASH POTASH_MAGNESIA POTASSIUM_NITRATE POTASSIUM_SULFATE ///
                MATERIALS___ALL_OTHER_1"

* Loop over each fertilizer variable: if it is stored as a string,
* remove non-numeric characters and convert it to numeric.
foreach var of local fertcols {
    capture confirm string variable `var'
    if !_rc {
        * Remove any character that is not a digit, a decimal point, or a minus sign
        gen temp_`var' = real(ustrregexra(`var', "[^0-9.-]", ""))
        drop `var'
        rename temp_`var' `var'
    }
}

/*---------------------------------------------------------------
  4. DIFFERENCE-IN-DIFFERENCES (DiD) MODELS USING FIXED EFFECTS
---------------------------------------------------------------*/
* Note: The following models use the reghdfe command.
* If not already installed, run: ssc install reghdfe

* ----- Model 1 -----
* Regression with interaction (Treatment_zip x Post), logged population and income,
* and additional controls; fixed effects for cbsa_code, year, and month;
* standard errors clustered at the county level.
reghdfe no2_ppb i.Treatment_zip##i.Post ln(population) ln(income_per_capita) ///
         total_fertilizer chemical_insecticide num_gasoline_cars, ///
         absorb(cbsa_code year month) cluster(county)
  
* ----- Model 2 -----
* Regression adding more controls and fixed effects for site_number.
reghdfe no2_ppb i.Treatment_zip##i.Post population income_per_capita total_fertilizer ///
         total_cars num_bev_cars fertiizer_manure fertilizer_organic ///
         ANHYDROUS_AMMONIA AMMONIUM_NITRATE_1 NITRATE_SOLUTION UREA, ///
         absorb(cbsa_code site_number year month) cluster(county)

* ----- Model 1 (Alternate Specification) -----
* Simpler model with only population and income.
reghdfe no2_ppb i.Treatment_zip##i.Post population income_per_capita, ///
         absorb(cbsa_code site_number year month) cluster(county)

* ----- Model 3 -----
* Model with additional controls for total_cars and num_bev_cars.
reghdfe no2_ppb i.Treatment_zip##i.Post population income_per_capita ///
         total_cars num_bev_cars, ///
         absorb(cbsa_code site_number year month) cluster(county)

* ----- Model 4: Outcome Cleaning and Regression -----
* Replace problematic no2_ppb values (< 0 or missing) with 0,
* then create a log-transformed version using ln(1+x)
gen no2_ppb_clean = cond(no2_ppb < 0 | missing(no2_ppb), 0, no2_ppb)
gen log_no2_ppb = ln(1 + no2_ppb_clean)

* Run the DiD model using the cleaned data.
reghdfe no2_ppb i.Treatment_zip##i.Post ln(population) ln(income_per_capita) ///
         total_cars num_bev_cars fertiizer_manure fertilizer_organic ///
         total_fertilizer ANHYDROUS_AMMONIA AMMONIUM_NITRATE_1 NITRATE_SOLUTION UREA, ///
         absorb(cbsa_code site_number year month) cluster(county)

* Check for missing values across variables
misstable summarize

/*---------------------------------------------------------------
  5. EVENT STUDY & PLACEBO ANALYSES
---------------------------------------------------------------*/
* ----- Event Study Model -----
* Interact year with Treatment_zip (using 2010 as the reference period if needed).
reghdfe no2_ppb i.year##i.Treatment_zip, ///
         absorb(cbsa_code site_number month) cluster(county)
* (You may use post-estimation commands or coefplot to extract and graph pre-treatment coefficients.)

* ----- Placebo DiD -----
* Create a placebo Post variable (assuming treatment starts in 2009 so that Post=1 for year>=2010)
gen Post_Placebo = (year >= 2010)
reghdfe no2_ppb i.Treatment_zip##i.Post_Placebo population income_per_capita, ///
         absorb(cbsa_code site_number year month) cluster(county)

* ----- Pre-trend Interaction Model -----
* Generate interaction dummies for pre-treatment trends.
gen pre_trend_2011 = (year == 2009 & Treatment_zip == 1)
gen pre_trend_2010 = (year == 2010 & Treatment_zip == 1)
reghdfe no2_ppb pre_trend_2011 pre_trend_2010 i.Treatment_zip##i.Post ///
         population income_per_capita, ///
         absorb(cbsa_code site_number year month) cluster(county)

* Export the cleaned/processed panel data to CSV for further use.
export delimited using "panel_data_did_2_15.csv", replace

* Extended pre-trend model with additional covariates.
reghdfe no2_ppb pre_trend_2011 pre_trend_2010 i.Treatment_zip##i.Post ///
         population income_per_capita total_cars num_bev_cars fertiizer_manure ///
         fertilizer_organic total_fertilizer ANHYDROUS_AMMONIA AMMONIUM_NITRATE_1 ///
         NITRATE_SOLUTION UREA, ///
         absorb(year month) cluster(county)

/*---------------------------------------------------------------
  6. EV ADOPTION ANALYSIS & PLOTTING
---------------------------------------------------------------*/
* Create a dataset for EV adoption thresholds and their NO₂ reduction coefficients.
clear
input str15 Threshold Reduction SE
"15% EV Adoption" -0.61747566 0.25714653
"25% EV Adoption" -0.68864040 0.25004344
"35% EV Adoption" -0.62164765 0.25083377
end

* Define the baseline (pre-treatment) NO₂ level.
gen initial_NO2 = 10.31522

* Compute the final NO₂ level after reduction.
gen Final_NO2 = initial_NO2 + Reduction

* Encode the categorical threshold to obtain numeric x-values for plotting.
encode Threshold, gen(threshold_num)

* Example Plot 1: Scatter plot with error bars
twoway ///
    (rcap Final_NO2-SE Final_NO2+SE threshold_num, lcolor(black)) ///
    (scatter Final_NO2 threshold_num, msize(medium) mcolor(blue)), ///
    ytitle("Final NO₂ (ppb)") xtitle("EV Adoption Threshold") ///
    title("Effect of EV Adoption on NO₂ Levels") ///
    xlabel(1 "15%" 2 "25%" 3 "35%") legend(off)
	* Example Plot 1: Scatter plot with error bars
twoway ///
    (rcap Final_NO2-SE Final_NO2+SE threshold_num, lcolor(black)) ///
    (scatter Final_NO2 threshold_num, msize(medium) mcolor(blue)), ///
    ytitle("Final NO₂ (ppb)") xtitle("EV Adoption Threshold") ///
    title("Effect of EV Adoption on NO₂ Levels") ///
    xlabel(1 "15%" 2 "25%" 3 "35%") legend(off)
	* Example Plot 1: Scatter plot with error bars
twoway ///
    (rcap Final_NO2-SE Final_NO2+SE threshold_num, lcolor(black)) ///
    (scatter Final_NO2 threshold_num, msize(medium) mcolor(blue)), ///
    ytitle("Final NO₂ (ppb)") xtitle("EV Adoption Threshold") ///
    title("Effect of EV Adoption on NO₂ Levels") ///
    xlabel(1 "15%" 2 "25%" 3 "35%") legend(off)
	* Example Plot 1: Scatter plot with error bars
twoway ///
    (rcap Final_NO2-SE Final_NO2+SE threshold_num, lcolor(black)) ///
    (scatter Final_NO2 threshold_num, msize(medium) mcolor(blue)), ///
    ytitle("Final NO₂ (ppb)") xtitle("EV Adoption Threshold") ///
    title("Effect of EV Adoption on NO₂ Levels") ///
    xlabel(1 "15%" 2 "25%" 3 "35%") legend(off)
	

* (Optional) You can add more advanced plots using additional twoway options.

/******************************************************************
                    END OF DO-FILE
******************************************************************/
