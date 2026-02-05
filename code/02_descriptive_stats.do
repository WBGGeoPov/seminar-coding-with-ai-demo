// ============================================================================
// Descriptive statistics by region-year
// ============================================================================
// Calculate mean and SD for key variables by region and year

// Count observations
use "${temp}/survey_clean.dta", clear
gen n_obs = 1
collapse (sum) n_obs, by(region year)
save "${temp}/desc_n.dta", replace

// Count households
use "${temp}/survey_clean.dta", clear
gen temp = 1
bysort region year hhid: replace temp = 0 if _n > 1
collapse (sum) n_households=temp, by(region year)
save "${temp}/desc_hh.dta", replace

// Age statistics
use "${temp}/survey_clean.dta", clear
collapse (mean) age_mean=age (sd) age_sd=age, by(region year)
save "${temp}/desc_age.dta", replace

// Literacy statistics
use "${temp}/survey_clean.dta", clear
collapse (mean) literacy_mean=literacy (sd) literacy_sd=literacy, by(region year)
save "${temp}/desc_lit.dta", replace

// Welfare PPP statistics
use "${temp}/survey_clean.dta", clear
collapse (mean) welfare_mean=welfare_ppp (sd) welfare_sd=welfare_ppp, by(region year)
save "${temp}/desc_wel.dta", replace

// Merge all descriptives
use "${temp}/desc_n.dta", clear
merge 1:1 region year using "${temp}/desc_hh.dta", nogenerate
merge 1:1 region year using "${temp}/desc_age.dta", nogenerate
merge 1:1 region year using "${temp}/desc_lit.dta", nogenerate
merge 1:1 region year using "${temp}/desc_wel.dta", nogenerate

order region year n_obs n_households ///
      age_mean age_sd literacy_mean literacy_sd welfare_mean welfare_sd

export delimited "${output}/descriptives.csv", replace

di as result _n "Descriptive statistics calculated and saved to descriptives.csv"
