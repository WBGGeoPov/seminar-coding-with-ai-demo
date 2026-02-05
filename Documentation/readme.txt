================================================================================
PROJECT: Poverty and Welfare Analysis 2018-2021
================================================================================

OVERVIEW
--------
This project analyzes household survey data from 2018-2021 to estimate poverty
rates, inequality metrics, and determinants of welfare. The analysis produces
regional and national statistics on poverty headcount, poverty gap, Gini
coefficient, and Theil index.

REQUIREMENTS
------------
Software: Stata 17 or higher
Packages: No additional packages required

DATA SOURCES
------------
Input files (place in Data/Raw/):
1. survey-2018-2021.dta - Household survey microdata
2. cpi_ppp.csv - Consumer Price Index and PPP conversion factors
3. icp2021.csv - ICP 2021 spatial price deflators
4. spat_def.csv - Additional spatial deflators by region

Data documentation: See Documentation/data_dictionary.txt

DIRECTORY STRUCTURE
-------------------
Code/               - All analysis scripts (01-07)
Data/
  Raw/              - Original data files (read-only)
  Final/            - Cleaned analysis dataset
  Temp/             - Temporary files and log files
Output/
  Tables/           - Result tables (CSV and DTA formats)
  Figures/          - PNG figures
Documentation/      - Data dictionary and methodological notes

INSTRUCTIONS
------------
1. Place all raw data files in Data/Raw/
2. Open Stata and set working directory to project root
3. Run: do master.do
4. Check log files in Data/Temp/ for any errors
5. Results available in Output/

SCRIPTS
-------
Scripts run in sequence via master.do:

01_import.do - Import CSV files and convert to Stata format
02_clean.do - Merge survey data with price deflators
03_construct.do - Construct PPP-adjusted welfare variable
04_analysis_regional.do - Regional descriptive and poverty statistics
05_analysis_national.do - National-level statistics
06_regression.do - Regression analysis of welfare determinants
07_figures.do - Generate distribution plots

OUTPUTS
-------
Tables (DTA and CSV formats):
- table1_descriptive_regional.dta/csv - Descriptive stats by region-year
- table2_poverty_regional.dta/csv - Poverty metrics by region-year
- table3_national.dta/csv - National statistics by year
- table4_regression.txt - Regression results (comma-delimited)

Figures (PNG format):
- fig1_age_distribution.png
- fig2_household_size.png
- fig3_welfare_2018.png
- fig4_welfare_2021.png
- fig5_welfare_pooled.png

METHODOLOGY
-----------
Welfare Adjustment:
  welfare_ppp = welfare / cpi2021 / icp2021 * spat_def

Poverty Line: 40% of national median welfare (by year)

Gini Coefficient: Standard formula based on welfare ranking

Theil Index: Mean log deviation measure

CONTACT
-------
Date: February 5, 2026

LICENSE
-------
[Specify license - e.g., MIT, CC-BY 4.0]
================================================================================
