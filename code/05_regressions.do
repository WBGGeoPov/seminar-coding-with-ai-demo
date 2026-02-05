/*==============================================================================
SCRIPT 05: Regression Analysis
Purpose: Estimate welfare determinants using OLS regression
==============================================================================*/

use "${data_clean}/survey_clean.dta", clear

// Model 1: Pooled regression with year fixed effects
quietly regress welfare_ppp age adult adult_working i.educat4 i.literacy i.year
estimates store model1

// Model 2: 2018 only
quietly regress welfare_ppp age adult adult_working i.educat4 i.literacy if year == 2018
estimates store model2

// Model 3: 2021 only
quietly regress welfare_ppp age adult adult_working i.educat4 i.literacy if year == 2021
estimates store model3

// Model 4: Pooled with robust standard errors
quietly regress welfare_ppp age adult adult_working i.educat4 i.literacy i.year, robust
estimates store model4

// Export regression results to CSV using esttab
// Creates table with coefficients, standard errors, N, and R-squared
capture which esttab
if _rc == 0 {
    esttab model1 model2 model3 model4 using "${output_tables}/table5_regression_results.csv", ///
        b(3) se(3) r2(3) ///
        stats(N r2, fmt(0 3) labels("Observations" "R-squared")) ///
        replace ///
        csv ///
        mtitles("Pooled" "2018" "2021" "Pooled_Robust")
}
else {
    // Alternative export if esttab not available
    estimates table model1 model2 model3 model4, ///
        stats(N r2) ///
        star

    // Manual CSV export
    clear
    set obs 20
    gen str30 variable = ""
    gen model1 = .
    gen model2 = .
    gen model3 = .
    gen model4 = .

    local row = 1
    foreach var in "age" "adult" "adult_working" {
        replace variable = "`var'" in `row'
        quietly estimates restore model1
        replace model1 = _b[`var'] in `row'
        quietly estimates restore model2
        replace model2 = _b[`var'] in `row'
        quietly estimates restore model3
        replace model3 = _b[`var'] in `row'
        quietly estimates restore model4
        replace model4 = _b[`var'] in `row'
        local row = `row' + 1
    }

    // Add N and R-squared
    replace variable = "N" in `row'
    quietly estimates restore model1
    replace model1 = e(N) in `row'
    quietly estimates restore model2
    replace model2 = e(N) in `row'
    quietly estimates restore model3
    replace model3 = e(N) in `row'
    quietly estimates restore model4
    replace model4 = e(N) in `row'
    local row = `row' + 1

    replace variable = "R_squared" in `row'
    quietly estimates restore model1
    replace model1 = e(r2) in `row'
    quietly estimates restore model2
    replace model2 = e(r2) in `row'
    quietly estimates restore model3
    replace model3 = e(r2) in `row'
    quietly estimates restore model4
    replace model4 = e(r2) in `row'

    keep if variable != ""
    export delimited "${output_tables}/table5_regression_results.csv", replace
}
