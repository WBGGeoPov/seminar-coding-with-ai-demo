/*==============================================================================
Script: 06_regression.do
Purpose: Estimate determinants of welfare
Inputs: survey_analysis.dta
Outputs: table4_regression.txt
==============================================================================*/

use "${final}/survey_analysis.dta", clear

// Model 1: Pooled regression
quietly reg welfare_ppp age adult adult_working i.educat4 i.literacy i.year
estimates store model1

// Model 2: 2018 only
quietly reg welfare_ppp age adult adult_working i.educat4 i.literacy if year == 2018
estimates store model2

// Model 3: 2021 only
quietly reg welfare_ppp age adult adult_working i.educat4 i.literacy if year == 2021
estimates store model3

// Model 4: Pooled with robust standard errors
quietly reg welfare_ppp age adult adult_working i.educat4 i.literacy i.year, robust
estimates store model4

// Export to text file for importing to other software
quietly {
    file open regout using "${tables}/table4_regression.txt", write replace

    file write regout "model,variable,coefficient,obs,r2" _n

    foreach model in model1 model2 model3 model4 {
        estimates restore `model'
        local n = e(N)
        local r2 = e(r2)

        matrix b = e(b)
        local varlist : colnames b

        foreach var of local varlist {
            local coef = b[1, "`var'"]
            file write regout "`model',`var',`coef',`n',`r2'" _n
        }
    }

    file close regout
}
