/*==============================================================================
SCRIPT 04: Poverty and Inequality Measures
Purpose: Calculate poverty rates, gaps, Gini, and Theil indices
==============================================================================*/

/*------------------------------------------------------------------------------
Table 2: Regional poverty and inequality
------------------------------------------------------------------------------*/

use "${data_clean}/survey_clean.dta", clear

// Define poverty line as 40% of median welfare
bysort year: egen median_welfare = median(welfare_ppp)
gen poverty_line = median_welfare * 0.4

// Identify poor individuals
gen poor = (welfare_ppp < poverty_line)

// Calculate poverty rate by region and year
preserve
collapse (mean) poverty_rate=poor [aw=weight_h], by(region year)
tempfile pov_rate
save `pov_rate'
restore

// Calculate poverty gap by region and year
gen pov_gap_ind = (poverty_line - welfare_ppp) / poverty_line if poor == 1
replace pov_gap_ind = 0 if poor == 0
preserve
collapse (mean) poverty_gap=pov_gap_ind [aw=weight_h], by(region year)
tempfile pov_gap
save `pov_gap'
restore

// Calculate Gini coefficient by region and year
sort region year welfare_ppp
by region year: gen rank = _n
by region year: egen n_obs = count(welfare_ppp)
by region year: egen sum_welfare = sum(welfare_ppp * weight_h)
by region year: egen sum_weight = sum(weight_h)
gen weighted_rank = rank * weight_h
by region year: egen sum_weighted_rank = sum(weighted_rank)
gen gini_numerator = (2 * weighted_rank - sum_weight - 1) * welfare_ppp * weight_h
by region year: egen sum_gini_num = sum(gini_numerator)
gen gini_coef = sum_gini_num / (sum_weight * sum_welfare)
preserve
collapse (mean) gini_index=gini_coef, by(region year)
tempfile gini
save `gini'
restore

// Calculate Theil index by region and year
by region year: egen mean_welfare_reg = mean(welfare_ppp)
gen welfare_ratio = welfare_ppp / mean_welfare_reg
gen theil_component = welfare_ratio * ln(welfare_ratio) * weight_h
replace theil_component = 0 if missing(theil_component)
by region year: egen sum_theil = sum(theil_component)
by region year: egen sum_wt = sum(weight_h)
gen theil_idx = sum_theil / sum_wt
preserve
collapse (mean) theil_index=theil_idx, by(region year)
tempfile theil
save `theil'
restore

// Merge all measures
use `pov_rate', clear
merge 1:1 region year using `pov_gap', nogenerate
merge 1:1 region year using `gini', nogenerate
merge 1:1 region year using `theil', nogenerate

// Reorder variables
order region year poverty_rate poverty_gap gini_index theil_index

// Export table
export delimited "${output_tables}/table2_poverty_inequality_regional.csv", replace

/*------------------------------------------------------------------------------
Table 4: National poverty and inequality
------------------------------------------------------------------------------*/

use "${data_clean}/survey_clean.dta", clear

// Define poverty line
bysort year: egen median_welfare = median(welfare_ppp)
gen poverty_line = median_welfare * 0.4

// Identify poor individuals
gen poor = (welfare_ppp < poverty_line)

// Calculate national poverty rate by year
preserve
collapse (mean) poverty_rate=poor [aw=weight_h], by(year)
tempfile pov_rate_nat
save `pov_rate_nat'
restore

// Calculate national poverty gap by year
gen pov_gap_ind = (poverty_line - welfare_ppp) / poverty_line if poor == 1
replace pov_gap_ind = 0 if poor == 0
preserve
collapse (mean) poverty_gap=pov_gap_ind [aw=weight_h], by(year)
tempfile pov_gap_nat
save `pov_gap_nat'
restore

// Calculate national Gini coefficient by year
sort year welfare_ppp
by year: gen rank = _n
by year: egen n_obs = count(welfare_ppp)
by year: egen sum_welfare = sum(welfare_ppp * weight_h)
by year: egen sum_weight = sum(weight_h)
gen weighted_rank = rank * weight_h
by year: egen sum_weighted_rank = sum(weighted_rank)
gen gini_numerator = (2 * weighted_rank - sum_weight - 1) * welfare_ppp * weight_h
by year: egen sum_gini_num = sum(gini_numerator)
gen gini_coef = sum_gini_num / (sum_weight * sum_welfare)
preserve
collapse (mean) gini_index=gini_coef, by(year)
tempfile gini_nat
save `gini_nat'
restore

// Calculate national Theil index by year
by year: egen mean_welfare_yr = mean(welfare_ppp)
gen welfare_ratio = welfare_ppp / mean_welfare_yr
gen theil_component = welfare_ratio * ln(welfare_ratio) * weight_h
replace theil_component = 0 if missing(theil_component)
by year: egen sum_theil = sum(theil_component)
by year: egen sum_wt = sum(weight_h)
gen theil_idx = sum_theil / sum_wt
preserve
collapse (mean) theil_index=theil_idx, by(year)
tempfile theil_nat
save `theil_nat'
restore

// Merge measures
use `pov_rate_nat', clear
merge 1:1 year using `pov_gap_nat', nogenerate
merge 1:1 year using `gini_nat', nogenerate
merge 1:1 year using `theil_nat', nogenerate

// Reorder variables
order year poverty_rate poverty_gap gini_index theil_index

// Export table
export delimited "${output_tables}/table4_poverty_inequality_national.csv", replace
