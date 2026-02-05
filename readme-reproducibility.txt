WELFARE ANALYSIS 2018-2021
==========================

PROJECT OVERVIEW
----------------
This project analyzes household survey data from 2018-2021 to measure welfare
trends, poverty rates, and inequality across regions. The analysis includes PPP
adjustments using CPI, ICP, and spatial deflators.

PROJECT STRUCTURE
-----------------
main.do                      # Master script - run this file
code/                        # Analysis scripts
  ├── 00_setup.do            # Environment setup and validation
  ├── 01_import_data.do      # Import and convert CSV files
  ├── 02_clean_data.do       # Merge deflators, create welfare_ppp
  ├── 03_descriptive_stats.do # Regional statistics
  ├── 04_poverty_inequality.do# Poverty and inequality measures
  ├── 05_national_aggregates.do# Country-level summaries
  └── 06_visualizations.do   # Graphs and figures
data/
  ├── raw/                   # Original untouched data
  ├── temp/                  # Intermediate files (preserved)
  └── processed/             # Clean datasets ready for analysis
output/
  ├── tables/                # CSV output tables
  └── figures/               # PNG graphs

DATA SOURCES
------------
Input Files (data/raw/):
- survey-2018-2021.dta: Household survey data covering 2018-2021
- cpi_ppp.csv: Consumer Price Index and PPP conversion factors by year
- icp2021.csv: ICP spatial deflators by year and region
- spat_def.csv: Spatial deflators by year and region
- adm1.geojson: Geographic boundaries (if needed)

Processed Data (data/processed/):
- survey_clean.dta: Survey data merged with all deflators and welfare_ppp calculated
- cpi_ppp.dta, icp2021.dta, spat_def.dta: Converted deflator files

OUTPUTS
-------
Tables (output/tables/):
- descriptives.csv: Descriptive statistics by region and year
- poverty_inequality.csv: Poverty and inequality measures by region and year
- national_summary.csv: Country-level aggregated statistics

Figures (output/figures/):
- hist_age.png: Age distribution
- hist_hhsize.png: Household size distribution
- hist_welfare.png: Overall welfare distribution
- hist_welfare_2018.png: Welfare distribution for 2018
- hist_welfare_2021.png: Welfare distribution for 2021

KEY PARAMETERS
--------------
- Poverty threshold: 40% of within-year median welfare_ppp
- Base year: 2021 (for CPI adjustment)
- Welfare measure: PPP-adjusted using formula:
  welfare_ppp = welfare / cpi2021 / icp2021 * spat_def

HOW TO RUN
----------
Requirements:
- Stata 16 or higher (see REQUIREMENTS.txt)
- Input data files in data/raw/ folder

Execution:
1. Open Stata
2. Set working directory to project root
3. Run the master script:
   do "main.do"

The script will:
- Validate directory structure
- Import and process all data
- Generate statistics and measures
- Create output tables and figures
- Save log file to output/main.log

Running Individual Components:
To run specific sections only, edit main.do and comment out unwanted sections.

REPRODUCIBILITY
---------------
- All analysis runs from main.do
- Intermediate files stored in data/temp/ (preserved for inspection)
- Original data in data/raw/ is never modified
- Deterministic analysis (no random seed required)
- Stata version documented in REQUIREMENTS.txt

NOTES
-----
- Temp files in data/temp/ are preserved after runs for quality checking
- All monetary values are in PPP-adjusted terms unless specified
- Regional codes use ADM1CD_c variable
- Analysis weighted by weight_h (household weight)
