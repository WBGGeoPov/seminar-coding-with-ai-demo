/*==============================================================================
SCRIPT 01: Prepare and Import Raw Data
Purpose: Convert CSV files to Stata format and standardize variable names
==============================================================================*/

// Import CPI and PPP conversion factors
import delimited "${data_raw}/cpi_ppp.csv", clear varnames(1)
save "${data_clean}/cpi_ppp.dta", replace

// Import ICP spatial deflators
import delimited "${data_raw}/icp2021.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
rename spat_def icp_spat_def
save "${data_clean}/icp2021.dta", replace

// Import additional spatial deflators
import delimited "${data_raw}/spat_def.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
save "${data_clean}/spat_def.dta", replace

// Copy survey data to clean folder
use "${data_raw}/survey-2018-2021.dta", clear
save "${data_clean}/survey_raw.dta", replace
