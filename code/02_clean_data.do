// ============================================================================
// Clean data
// ============================================================================
// Merge survey data with deflators and create PPP-adjusted welfare

// Load survey data
use "${data}/raw/survey-2018-2021.dta", clear
destring year, replace
capture drop icp2021

// Merge CPI/PPP by year
merge m:1 year using "${data}/processed/cpi_ppp.dta", keep(master match) nogenerate
assert !missing(cpi2021)

// Merge ICP deflators by year-region
merge m:1 year ADM1CD_c using "${data}/processed/icp2021.dta", keep(master match) nogenerate

// Merge spatial deflators by year-region
merge m:1 year ADM1CD_c using "${data}/processed/spat_def.dta", keep(master match) nogenerate

// Report merge quality
count if missing(icp_spat_def)
count if missing(spat_def)

// Create PPP-adjusted welfare variable
gen welfare_ppp = welfare / cpi2021 / icp2021 * spat_def
label variable welfare_ppp "PPP-adjusted welfare"

// Validate results
assert welfare_ppp > 0 if !missing(welfare_ppp)
count if missing(welfare_ppp)

// Save cleaned dataset
save "${data}/processed/survey_clean.dta", replace
