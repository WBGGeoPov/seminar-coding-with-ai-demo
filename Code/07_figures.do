/*==============================================================================
Script: 07_figures.do
Purpose: Generate descriptive figures
Inputs: survey_analysis.dta
Outputs: PNG files in Figures folder
==============================================================================*/

use "${final}/survey_analysis.dta", clear

// Age distribution
histogram age, title("Age Distribution") ///
               xtitle("Age") ytitle("Density") scheme(s2color)
graph export "${figures}/fig1_age_distribution.png", replace

// Household size distribution
gen first_member = 1
bysort hhid: replace first_member = 0 if _n > 1
bysort hhid: egen hh_size = count(hhid)

histogram hh_size if first_member == 1, discrete ///
                  title("Household Size Distribution") ///
                  xtitle("Household Size") ytitle("Frequency") scheme(s2color)
graph export "${figures}/fig2_household_size.png", replace

// Welfare distribution by year
histogram welfare_ppp if year == 2018, ///
          title("Welfare Distribution 2018") ///
          xtitle("Welfare (PPP)") ytitle("Density") scheme(s2color)
graph export "${figures}/fig3_welfare_2018.png", replace

histogram welfare_ppp if year == 2021, ///
          title("Welfare Distribution 2021") ///
          xtitle("Welfare (PPP)") ytitle("Density") scheme(s2color)
graph export "${figures}/fig4_welfare_2021.png", replace

// Overall welfare distribution
histogram welfare_ppp, title("Welfare Distribution (All Years)") ///
                      xtitle("Welfare (PPP)") ytitle("Density") scheme(s2color)
graph export "${figures}/fig5_welfare_pooled.png", replace
