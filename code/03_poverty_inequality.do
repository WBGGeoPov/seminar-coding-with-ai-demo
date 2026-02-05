// ============================================================================
// Poverty and inequality measures by region-year
// ============================================================================
// Calculate poverty rate, poverty gap, Gini index, and Theil index

// Calculate poverty line (40% of within-year median)
use "${temp}/survey_clean.dta", clear
bysort year: egen median_welfare = median(welfare_ppp)
gen poverty_line = median_welfare * ${poverty_threshold}
gen poor = (welfare_ppp < poverty_line)
save "${temp}/survey_poverty.dta", replace

// Poverty rate
use "${temp}/survey_poverty.dta", clear
collapse (mean) poverty_rate=poor, by(region year)
save "${temp}/pov_rate.dta", replace

// Poverty gap
use "${temp}/survey_poverty.dta", clear
gen gap = (poverty_line - welfare_ppp) / poverty_line if poor == 1
replace gap = 0 if poor == 0
collapse (mean) poverty_gap=gap, by(region year)
save "${temp}/pov_gap.dta", replace

// Gini coefficient
use "${temp}/survey_poverty.dta", clear
bysort region year: egen n = count(welfare_ppp)
bysort region year: egen sum_welfare = sum(welfare_ppp)
sort region year welfare_ppp
by region year: gen rank = _n
by region year: gen gini_component = (2 * rank - n - 1) * welfare_ppp
by region year: egen sum_component = sum(gini_component)
gen gini = sum_component / (n * sum_welfare)
collapse (mean) gini_index=gini, by(region year)
save "${temp}/gini.dta", replace

// Theil index
use "${temp}/survey_poverty.dta", clear
bysort region year: egen mean_welfare = mean(welfare_ppp)
gen ratio = welfare_ppp / mean_welfare
gen theil_component = ratio * ln(ratio)
replace theil_component = 0 if missing(theil_component)
collapse (mean) theil_index=theil_component, by(region year)
save "${temp}/theil.dta", replace

// Merge all poverty and inequality measures
use "${temp}/pov_rate.dta", clear
merge 1:1 region year using "${temp}/pov_gap.dta", nogenerate
merge 1:1 region year using "${temp}/gini.dta", nogenerate
merge 1:1 region year using "${temp}/theil.dta", nogenerate

order region year poverty_rate poverty_gap gini_index theil_index

export delimited "${output}/poverty_inequality.csv", replace

di as result _n "Poverty and inequality measures calculated and saved to poverty_inequality.csv"
