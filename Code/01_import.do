/*==============================================================================
Script: 01_import.do
Purpose: Import and convert CSV files to Stata format
Inputs: CSV files in Raw folder
Outputs: DTA files in Temp folder
==============================================================================*/

// CPI and PPP conversion factors
import delimited "${raw}/cpi_ppp.csv", clear varnames(1)
save "${temp}/cpi_ppp.dta", replace

// ICP 2021 spatial deflators
import delimited "${raw}/icp2021.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
rename spat_def icp_spat_def
save "${temp}/icp2021.dta", replace

// Additional spatial deflators
import delimited "${raw}/spat_def.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
save "${temp}/spat_def.dta", replace
