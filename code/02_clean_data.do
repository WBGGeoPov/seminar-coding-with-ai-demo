/*==============================================================================
SCRIPT 02: Clean and Merge Data
Purpose: Merge survey data with price deflators and create PPP-adjusted welfare
==============================================================================*/

use "${data_clean}/survey_raw.dta", clear

// Ensure year is numeric
destring year, replace

// Drop conflicting variable if exists
capture drop icp2021

// Merge CPI and PPP data
merge m:1 year using "${data_clean}/cpi_ppp.dta", keep(master match) nogenerate

// Merge ICP spatial deflators
merge m:1 year ADM1CD_c using "${data_clean}/icp2021.dta", keep(master match) nogenerate

// Merge additional spatial deflators for missing ICP values
merge m:1 year ADM1CD_c using "${data_clean}/spat_def.dta", keep(master match) nogenerate

// Create PPP-adjusted welfare variable
// Formula: nominal welfare / CPI / ICP deflator * spatial deflator
gen welfare_ppp = welfare / cpi2021 / icp2021 * spat_def

// Save cleaned dataset
save "${data_clean}/survey_clean.dta", replace
