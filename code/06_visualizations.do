/*==============================================================================
SCRIPT 06: Create Visualizations
Purpose: Generate histograms and distribution plots
==============================================================================*/

use "${data_clean}/survey_clean.dta", clear

// Figure 1: Age distribution
histogram age, ///
    title("Age Distribution") ///
    xtitle("Age") ///
    ytitle("Density") ///
    graphregion(color(white)) bgcolor(white)
graph export "${output_figures}/fig1_age_distribution.png", replace width(800)

// Figure 2: Household size distribution
duplicates tag hhid, gen(dup)
bysort hhid: gen first_obs = (_n == 1)
bysort hhid: egen household_size = count(hhid)

histogram household_size if first_obs == 1, ///
    discrete ///
    title("Household Size Distribution") ///
    xtitle("Household Size") ///
    ytitle("Frequency") ///
    graphregion(color(white)) bgcolor(white)
graph export "${output_figures}/fig2_household_size.png", replace width(800)

drop dup first_obs household_size

// Figure 3: Overall welfare PPP distribution
histogram welfare_ppp, ///
    title("Welfare PPP Distribution (All Years)") ///
    xtitle("Welfare (PPP adjusted)") ///
    ytitle("Density") ///
    graphregion(color(white)) bgcolor(white)
graph export "${output_figures}/fig3_welfare_distribution.png", replace width(800)

// Figure 4: Welfare distribution 2018
histogram welfare_ppp if year == 2018, ///
    title("Welfare PPP Distribution 2018") ///
    xtitle("Welfare (PPP adjusted)") ///
    ytitle("Density") ///
    graphregion(color(white)) bgcolor(white)
graph export "${output_figures}/fig4_welfare_2018.png", replace width(800)

// Figure 5: Welfare distribution 2021
histogram welfare_ppp if year == 2021, ///
    title("Welfare PPP Distribution 2021") ///
    xtitle("Welfare (PPP adjusted)") ///
    ytitle("Density") ///
    graphregion(color(white)) bgcolor(white)
graph export "${output_figures}/fig5_welfare_2021.png", replace width(800)
