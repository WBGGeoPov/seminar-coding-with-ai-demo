/*==============================================================================
Script: 04_analysis_regional.do
Purpose: Calculate descriptive statistics and poverty metrics by region-year
Inputs: survey_analysis.dta
Outputs: table1_descriptive_regional.dta, table2_poverty_regional.dta
==============================================================================*/

// TABLE 1: Descriptive Statistics by Region-Year
use "${final}/survey_analysis.dta", clear

// Count observations
gen obs = 1
collapse (count) n=obs ///
         (mean) age_mean=age lit_mean=literacy wel_mean=welfare_ppp ///
         (sd) age_sd=age lit_sd=literacy wel_sd=welfare_ppp, ///
         by(region year)

// Count households
tempfile desc_stats
save `desc_stats'

use "${final}/survey_analysis.dta", clear
gen first_member = 1
bysort region year hhid: replace first_member = 0 if _n > 1
collapse (sum) hhsize=first_member, by(region year)

merge 1:1 region year using `desc_stats', nogenerate

order region year n hhsize age_mean age_sd lit_mean lit_sd wel_mean wel_sd

save "${tables}/table1_descriptive_regional.dta", replace
export delimited "${tables}/table1_descriptive_regional.csv", replace

// TABLE 2: Poverty and Inequality Metrics by Region-Year
use "${final}/survey_analysis.dta", clear

// Calculate poverty line as 40% of national median by year
bysort year: egen median_welfare = median(welfare_ppp)
gen poverty_line = median_welfare * 0.4
gen poor = (welfare_ppp < poverty_line)

// Poverty gap
gen poverty_gap_temp = (poverty_line - welfare_ppp) / poverty_line if poor == 1
replace poverty_gap_temp = 0 if poor == 0

// Gini coefficient calculation
sort region year welfare_ppp
bysort region year: gen rank = _n
bysort region year: gen n_obs = _N
bysort region year: egen sum_welfare = sum(welfare_ppp)
gen gini_weight = (2 * rank - n_obs - 1) * welfare_ppp
bysort region year: egen sum_gini_weight = sum(gini_weight)
gen gini = sum_gini_weight / (n_obs * sum_welfare)

// Theil index
bysort region year: egen mean_welfare = mean(welfare_ppp)
gen welfare_ratio = welfare_ppp / mean_welfare
gen theil_component = welfare_ratio * ln(welfare_ratio)
replace theil_component = 0 if missing(theil_component)

// Collapse to region-year level
collapse (mean) pov_rate=poor pov_gap=poverty_gap_temp ///
         gini_index=gini theil_index=theil_component, ///
         by(region year)

order region year pov_rate pov_gap gini_index theil_index

save "${tables}/table2_poverty_regional.dta", replace
export delimited "${tables}/table2_poverty_regional.csv", replace
