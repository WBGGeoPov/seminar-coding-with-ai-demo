/*==============================================================================
Script: 05_analysis_national.do
Purpose: Calculate descriptive statistics and poverty metrics at national level
Inputs: survey_analysis.dta
Outputs: table3_national.dta
==============================================================================*/

use "${final}/survey_analysis.dta", clear

// Count observations
gen obs = 1
collapse (count) n=obs ///
         (mean) age_mean=age lit_mean=literacy wel_mean=welfare_ppp ///
         (sd) age_sd=age lit_sd=literacy wel_sd=welfare_ppp, ///
         by(year)

tempfile desc_national
save `desc_national'

// Count households
use "${final}/survey_analysis.dta", clear
gen first_member = 1
bysort year hhid: replace first_member = 0 if _n > 1
collapse (sum) hhsize=first_member, by(year)

merge 1:1 year using `desc_national', nogenerate

tempfile desc_complete
save `desc_complete'

// Poverty and inequality metrics
use "${final}/survey_analysis.dta", clear

bysort year: egen median_welfare = median(welfare_ppp)
gen poverty_line = median_welfare * 0.4
gen poor = (welfare_ppp < poverty_line)

gen poverty_gap_temp = (poverty_line - welfare_ppp) / poverty_line if poor == 1
replace poverty_gap_temp = 0 if poor == 0

sort year welfare_ppp
bysort year: gen rank = _n
bysort year: gen n_obs = _N
bysort year: egen sum_welfare = sum(welfare_ppp)
gen gini_weight = (2 * rank - n_obs - 1) * welfare_ppp
bysort year: egen sum_gini_weight = sum(gini_weight)
gen gini = sum_gini_weight / (n_obs * sum_welfare)

bysort year: egen mean_welfare = mean(welfare_ppp)
gen welfare_ratio = welfare_ppp / mean_welfare
gen theil_component = welfare_ratio * ln(welfare_ratio)
replace theil_component = 0 if missing(theil_component)

collapse (mean) pov_rate=poor pov_gap=poverty_gap_temp ///
         gini_index=gini theil_index=theil_component, ///
         by(year)

merge 1:1 year using `desc_complete', nogenerate

order year n hhsize age_mean age_sd lit_mean lit_sd wel_mean wel_sd ///
      pov_rate pov_gap gini_index theil_index

save "${tables}/table3_national.dta", replace
export delimited "${tables}/table3_national.csv", replace
