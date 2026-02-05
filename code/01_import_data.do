// ============================================================================
// Import data
// ============================================================================
// Convert CSV deflators to Stata format

// Import CPI and PPP conversion factors
import delimited "${data}/raw/cpi_ppp.csv", clear varnames(1)
label variable year "Survey year"
label variable cpi2021 "Consumer Price Index (2021 base)"
label variable icp2021 "ICP 2021 deflator"
save "${data}/processed/cpi_ppp.dta", replace

// Import ICP spatial deflators
import delimited "${data}/raw/icp2021.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
rename spat_def icp_spat_def
label variable year "Survey year"
label variable ADM1CD_c "Region code"
label variable icp_spat_def "ICP spatial deflator"
save "${data}/processed/icp2021.dta", replace

// Import additional spatial deflators
import delimited "${data}/raw/spat_def.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
label variable year "Survey year"
label variable ADM1CD_c "Region code"
label variable spat_def "Spatial price deflator"
save "${data}/processed/spat_def.dta", replace
