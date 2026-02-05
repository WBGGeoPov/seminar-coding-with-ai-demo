/*==============================================================================
SCRIPT 03: Descriptive Statistics Tables
Purpose: Generate summary statistics by region-year and national level
==============================================================================*/

/*------------------------------------------------------------------------------
Table 1: Regional descriptive statistics
------------------------------------------------------------------------------*/

use "${data_clean}/survey_clean.dta", clear

// Calculate statistics by region and year
collapse ///
    (count) n=welfare_ppp ///
    (mean) age_mean=age literacy_mean=literacy welfare_mean=welfare_ppp ///
    (sd) age_sd=age literacy_sd=literacy welfare_sd=welfare_ppp, ///
    by(region year)

// Count unique households per region-year
preserve
use "${data_clean}/survey_clean.dta", clear
bysort hhid region year: gen first = (_n == 1)
keep if first == 1
collapse (count) households=first, by(region year)
tempfile hh_counts
save `hh_counts'
restore

merge 1:1 region year using `hh_counts', nogenerate

// Reorder variables
order region year n households age_mean age_sd literacy_mean literacy_sd welfare_mean welfare_sd

// Export table
export delimited "${output_tables}/table1_descriptive_regional.csv", replace

/*------------------------------------------------------------------------------
Table 3: National descriptive statistics
------------------------------------------------------------------------------*/

use "${data_clean}/survey_clean.dta", clear

// Calculate national statistics by year
collapse ///
    (count) n=welfare_ppp ///
    (mean) age_mean=age literacy_mean=literacy welfare_mean=welfare_ppp ///
    (sd) age_sd=age literacy_sd=literacy welfare_sd=welfare_ppp, ///
    by(year)

// Count unique households per year
preserve
use "${data_clean}/survey_clean.dta", clear
bysort hhid year: gen first = (_n == 1)
keep if first == 1
collapse (count) households=first, by(year)
tempfile hh_counts_nat
save `hh_counts_nat'
restore

merge 1:1 year using `hh_counts_nat', nogenerate

// Reorder variables
order year n households age_mean age_sd literacy_mean literacy_sd welfare_mean welfare_sd

// Export table
export delimited "${output_tables}/table3_descriptive_national.csv", replace
