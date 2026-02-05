// ============================================================================
// National aggregates by year
// ============================================================================
// Calculate country-level statistics aggregated across all regions

// Count observations
use "${data}/processed/survey_clean.dta", clear
gen n_obs = 1
collapse (sum) n_obs, by(year)
save "${data}/temp/nat_n.dta", replace

// Count households
use "${data}/processed/survey_clean.dta", clear
gen temp = 1
bysort year hhid: replace temp = 0 if _n > 1
collapse (sum) n_households=temp, by(year)
save "${data}/temp/nat_hh.dta", replace

// Age statistics
use "${data}/processed/survey_clean.dta", clear
collapse (mean) age_mean=age (sd) age_sd=age, by(year)
save "${data}/temp/nat_age.dta", replace

// Literacy statistics
use "${data}/processed/survey_clean.dta", clear
collapse (mean) literacy_mean=literacy (sd) literacy_sd=literacy, by(year)
save "${data}/temp/nat_lit.dta", replace

// Welfare PPP statistics
use "${data}/processed/survey_clean.dta", clear
collapse (mean) welfare_mean=welfare_ppp (sd) welfare_sd=welfare_ppp, by(year)
save "${data}/temp/nat_wel.dta", replace

// Poverty rate
use "${data}/temp/survey_poverty.dta", clear
collapse (mean) poverty_rate=poor, by(year)
save "${data}/temp/nat_pov_rate.dta", replace

// Poverty gap
use "${data}/temp/survey_poverty.dta", clear
gen gap = (poverty_line - welfare_ppp) / poverty_line if poor == 1
replace gap = 0 if poor == 0
collapse (mean) poverty_gap=gap, by(year)
save "${data}/temp/nat_pov_gap.dta", replace

// Gini coefficient
use "${data}/temp/survey_poverty.dta", clear
bysort year: egen n = count(welfare_ppp)
bysort year: egen sum_welfare = sum(welfare_ppp)
sort year welfare_ppp
by year: gen rank = _n
by year: gen gini_component = (2 * rank - n - 1) * welfare_ppp
by year: egen sum_component = sum(gini_component)
gen gini = sum_component / (n * sum_welfare)
collapse (mean) gini_index=gini, by(year)
save "${data}/temp/nat_gini.dta", replace

// Theil index
use "${data}/temp/survey_poverty.dta", clear
bysort year: egen mean_welfare = mean(welfare_ppp)
gen ratio = welfare_ppp / mean_welfare
gen theil_component = ratio * ln(ratio)
replace theil_component = 0 if missing(theil_component)
collapse (mean) theil_index=theil_component, by(year)
save "${data}/temp/nat_theil.dta", replace

// Merge all national aggregates
use "${data}/temp/nat_n.dta", clear
merge 1:1 year using "${data}/temp/nat_hh.dta", nogenerate
merge 1:1 year using "${data}/temp/nat_age.dta", nogenerate
merge 1:1 year using "${data}/temp/nat_lit.dta", nogenerate
merge 1:1 year using "${data}/temp/nat_wel.dta", nogenerate
merge 1:1 year using "${data}/temp/nat_pov_rate.dta", nogenerate
merge 1:1 year using "${data}/temp/nat_pov_gap.dta", nogenerate
merge 1:1 year using "${data}/temp/nat_gini.dta", nogenerate
merge 1:1 year using "${data}/temp/nat_theil.dta", nogenerate

order year n_obs n_households age_mean age_sd literacy_mean literacy_sd ///
      welfare_mean welfare_sd poverty_rate poverty_gap gini_index theil_index

export delimited "${output}/tables/national_summary.csv", replace
