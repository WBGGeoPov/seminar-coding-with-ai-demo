/*==============================================================================
Script: 03_construct.do
Purpose: Construct PPP-adjusted welfare variable
Inputs: survey_merged.dta
Outputs: survey_analysis.dta
Notes: welfare_ppp = welfare adjusted for inflation (CPI),
       international prices (ICP), and spatial costs (spat_def)
==============================================================================*/

use "${temp}/survey_merged.dta", clear

// Create PPP-adjusted welfare variable
// Deflate by CPI to 2021 prices, convert to PPP, adjust for spatial costs
gen welfare_ppp = welfare / cpi2021 / icp2021 * spat_def

save "${final}/survey_analysis.dta", replace
