// ============================================================================
// Visualizations
// ============================================================================
// Generate distribution histograms and graphs

// Age distribution
use "${temp}/survey_clean.dta", clear
histogram age, title("Age Distribution") ///
    xtitle("Age") ytitle("Density") scheme(s2color)
graph export "${output}/hist_age.png", replace

// Household size distribution
use "${temp}/survey_clean.dta", clear
gen temp = 1
bysort hhid: replace temp = 0 if _n > 1
bysort hhid: egen hh_size = count(hhid)
histogram hh_size if temp == 1, discrete title("Household Size Distribution") ///
    xtitle("Household Size") ytitle("Density") scheme(s2color)
graph export "${output}/hist_hhsize.png", replace

// Overall welfare PPP distribution
use "${temp}/survey_clean.dta", clear
histogram welfare_ppp, title("Welfare PPP Distribution") ///
    xtitle("Welfare (PPP)") ytitle("Density") scheme(s2color)
graph export "${output}/hist_welfare.png", replace

// Welfare PPP distribution by year
use "${temp}/survey_clean.dta", clear
histogram welfare_ppp if year == 2018, title("Welfare PPP 2018") ///
    xtitle("Welfare (PPP)") ytitle("Density") scheme(s2color)
graph export "${output}/hist_welfare_2018.png", replace

use "${temp}/survey_clean.dta", clear
histogram welfare_ppp if year == 2021, title("Welfare PPP 2021") ///
    xtitle("Welfare (PPP)") ytitle("Density") scheme(s2color)
graph export "${output}/hist_welfare_2021.png", replace

di as result _n "Visualizations created and saved to output/"
