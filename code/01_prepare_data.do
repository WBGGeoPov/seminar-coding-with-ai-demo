// ============================================================================
// Data preparation
// ============================================================================
// Convert CSV deflators to Stata format and merge with survey data
// Create PPP-adjusted welfare variable

// Import CPI and PPP conversion factors
import delimited "${data}/cpi_ppp.csv", clear varnames(1)
save "${temp}/cpi_ppp.dta", replace

// Import ICP spatial deflators
import delimited "${data}/icp2021.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
rename spat_def icp_spat_def
save "${temp}/icp2021.dta", replace

// Import additional spatial deflators
import delimited "${data}/spat_def.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
save "${temp}/spat_def.dta", replace

// Load survey data
use "${data}/survey-2018-2021.dta", clear
destring year, replace
drop icp2021

// Merge CPI/PPP by year
merge m:1 year using "${temp}/cpi_ppp.dta", keep(master match) nogenerate

// Merge ICP deflators by year-region
merge m:1 year ADM1CD_c using "${temp}/icp2021.dta", keep(master match) nogenerate

// Merge spatial deflators by year-region
merge m:1 year ADM1CD_c using "${temp}/spat_def.dta", keep(master match) nogenerate

// Validate merge quality
count if missing(icp_spat_def)
count if missing(spat_def)

// Create PPP-adjusted welfare variable
gen welfare_ppp = welfare / cpi2021 / icp2021 * spat_def

// Validate results
assert welfare_ppp > 0 if !missing(welfare_ppp)
count if missing(welfare_ppp)

// Save cleaned dataset
save "${temp}/survey_clean.dta", replace

di as result _n "Data preparation complete. Survey data merged with deflators."
