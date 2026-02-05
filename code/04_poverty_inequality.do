// ============================================================================
// Poverty and inequality measures by region-year
// ============================================================================
// Calculate poverty rate, poverty gap, Gini index, and Theil index

// Calculate poverty line (40% of within-year median)
use "${data}/processed/survey_clean.dta", clear
bysort year: egen median_welfare = median(welfare_ppp)
gen poverty_line = median_welfare * ${poverty_threshold}
gen poor = (welfare_ppp < poverty_line)
save "${data}/temp/survey_poverty.dta", replace

// Poverty rate
use "${data}/temp/survey_poverty.dta", clear
collapse (mean) poverty_rate=poor, by(region year)
save "${data}/temp/pov_rate.dta", replace

// Poverty gap
use "${data}/temp/survey_poverty.dta", clear
gen gap = (poverty_line - welfare_ppp) / poverty_line if poor == 1
replace gap = 0 if poor == 0
collapse (mean) poverty_gap=gap, by(region year)
save "${data}/temp/pov_gap.dta", replace

// Gini coefficient
use "${data}/temp/survey_poverty.dta", clear
bysort region year: egen n = count(welfare_ppp)
bysort region year: egen sum_welfare = sum(welfare_ppp)
sort region year welfare_ppp
by region year: gen rank = _n
by region year: gen gini_component = (2 * rank - n - 1) * welfare_ppp
by region year: egen sum_component = sum(gini_component)
gen gini = sum_component / (n * sum_welfare)
collapse (mean) gini_index=gini, by(region year)
save "${data}/temp/gini.dta", replace

// Theil index
use "${data}/temp/survey_poverty.dta", clear
bysort region year: egen mean_welfare = mean(welfare_ppp)
gen ratio = welfare_ppp / mean_welfare
gen theil_component = ratio * ln(ratio)
replace theil_component = 0 if missing(theil_component)
collapse (mean) theil_index=theil_component, by(region year)
save "${data}/temp/theil.dta", replace

// Merge all poverty and inequality measures
use "${data}/temp/pov_rate.dta", clear
merge 1:1 region year using "${data}/temp/pov_gap.dta", nogenerate
merge 1:1 region year using "${data}/temp/gini.dta", nogenerate
merge 1:1 region year using "${data}/temp/theil.dta", nogenerate

order region year poverty_rate poverty_gap gini_index theil_index

// Save as Stata dataset
label variable region "Region name"
label variable year "Survey year"
label variable poverty_rate "Poverty headcount rate"
label variable poverty_gap "Poverty gap index"
label variable gini_index "Gini coefficient"
label variable theil_index "Theil index"

save "${data}/processed/subnational_poverty_inequality.dta", replace
export delimited "${output}/tables/poverty_inequality.csv", replace
