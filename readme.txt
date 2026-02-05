================================================================================
PROJECT: Poverty and Welfare Analysis 2018-2021
================================================================================

DESCRIPTION:
This project analyzes household survey data to measure poverty, inequality,
and welfare indicators across regions and years (2018-2021). All monetary
values are adjusted for inflation and purchasing power parity (PPP).

--------------------------------------------------------------------------------
SOFTWARE REQUIREMENTS:
--------------------------------------------------------------------------------
- Stata 16 or later
- R 4.0 or later
- R packages: sf, dplyr, ggplot2, patchwork
  Install with: install.packages(c("sf", "dplyr", "ggplot2", "patchwork"))
- Operating System: Windows/Mac/Linux

--------------------------------------------------------------------------------
DATA SOURCES:
--------------------------------------------------------------------------------
Input data files (located in data/raw/):
1. survey-2018-2021.dta - Household survey microdata
2. cpi_ppp.csv - Consumer price index and PPP conversion factors by year
3. icp2021.csv - ICP spatial deflators by region and year
4. spat_def.csv - Additional spatial deflators by region and year
5. adm1.geojson - Geographic boundary data for regional maps

--------------------------------------------------------------------------------
FOLDER STRUCTURE:
--------------------------------------------------------------------------------
/code          - All analysis scripts (Stata .do files and R scripts)
/data/raw      - Original input data (read-only)
/data-clean    - Processed intermediate datasets
/output/tables - Final results tables (CSV format)
/output/figures - Charts and graphs (PNG format)

--------------------------------------------------------------------------------
EXECUTION INSTRUCTIONS:
--------------------------------------------------------------------------------
1. Place all raw data files in data/raw/ folder
2. Ensure R is installed and accessible from command line (Rscript command)
3. Install required R packages (see SOFTWARE REQUIREMENTS)
4. Open Stata and set working directory to project root
5. Run: do master.do
6. Check output/ folder for results

Expected runtime: 2-5 minutes

--------------------------------------------------------------------------------
OUTPUTS:
--------------------------------------------------------------------------------
Tables (output/tables/):
- table1_descriptive_regional.csv - Descriptive statistics by region and year
- table2_poverty_inequality_regional.csv - Poverty/inequality by region and year
- table3_descriptive_national.csv - National-level descriptive statistics
- table4_poverty_inequality_national.csv - National poverty/inequality measures
- table5_regression_results.csv - Welfare regression coefficients
- table6_poverty_summary.csv - Summary statistics of poverty by year

Figures (output/figures/):
- fig1_age_distribution.png - Age distribution histogram
- fig2_household_size.png - Household size distribution
- fig3_welfare_distribution.png - Overall welfare PPP distribution
- fig4_welfare_2018.png - Welfare distribution for 2018
- fig5_welfare_2021.png - Welfare distribution for 2021
- map_poverty_2018.png - Spatial map of poverty rates in 2018
- map_poverty_2021.png - Spatial map of poverty rates in 2021
- map_poverty_comparison.png - Side-by-side comparison of poverty maps

--------------------------------------------------------------------------------
METHODOLOGY NOTES:
--------------------------------------------------------------------------------
- Poverty line: 40% of median welfare (relative poverty measure)
- Poverty measures: Headcount rate and poverty gap calculated using FGT formulas
- Inequality measures: Gini coefficient and Theil index
- All measures use household weights (weight_h)
- Welfare PPP = welfare / cpi2021 / icp2021 * spat_def

--------------------------------------------------------------------------------
VERSION INFORMATION:
--------------------------------------------------------------------------------
Last updated: February 2026
Stata version tested: 17.0
================================================================================
