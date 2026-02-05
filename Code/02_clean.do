/*==============================================================================
Script: 02_clean.do
Purpose: Merge survey data with price deflators
Inputs: survey-2018-2021.dta, price deflator files
Outputs: survey_merged.dta
==============================================================================*/

use "${raw}/survey-2018-2021.dta", clear

// Convert year to numeric
destring year, replace
drop icp2021

// Merge CPI and PPP deflators by year
merge m:1 year using "${temp}/cpi_ppp.dta", keep(master match) nogenerate

// Merge ICP spatial deflators by year and region
merge m:1 year ADM1CD_c using "${temp}/icp2021.dta", keep(master match) nogenerate

// Merge additional spatial deflators where ICP missing
merge m:1 year ADM1CD_c using "${temp}/spat_def.dta", keep(master match) nogenerate

// Check for missing deflators
misstable summarize cpi2021 icp2021 icp_spat_def spat_def

save "${temp}/survey_merged.dta", replace
