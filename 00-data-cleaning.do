// data cleaning
clear all
set more off

cd "`c(pwd)'"

// convert csv to dta
import delimited "data/cpi_ppp.csv", clear varnames(1)
save "data/cpi_ppp.dta", replace

import delimited "data/icp2021.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
rename spat_def icp_spat_def
save "data/icp2021.dta", replace
use "data/survey-2018-2021.dta", clear
describe

import delimited "data/spat_def.csv", clear varnames(1)
rename adm1cd_c ADM1CD_c
save "data/spat_def.dta", replace

// load data
use "data/survey-2018-2021.dta", clear
summarize
destring year, replace
drop icp2021

merge m:1 year using "data/cpi_ppp.dta", keep(master match) nogenerate
tab year, missing
merge m:1 year ADM1CD_c using "data/icp2021.dta", keep(master match) nogenerate

tab ADM1CD_c if missing(icp_spat_def), missing
merge m:1 year ADM1CD_c using "data/spat_def.dta", keep(master match) nogenerate
tab ADM1CD_c if missing(spat_def), missing

misstable summarize year ADM1CD_c cpi2021 icp2021 icp_spat_def spat_def
describe
tab year
summarize cpi2021 icp2021 icp_spat_def spat_def

gen welfare_ppp = welfare / cpi2021 / icp2021 * spat_def
tab year

save "data/survey-2018-2021-pre-cleaned.dta", replace

tab ADM1CD_c
summarize age
tab region
tab sample_group
summarize weight_h
tab educat4
summarize welfare
tab literacy
summarize welfare_ppp
tab adult
summarize cpi2021
tab adult_working
summarize icp2021

tab year, summarize(welfare)
summarize icp_spat_def
tab year, summarize(welfare_ppp)
summarize spat_def
tab region, summarize(welfare_ppp)

histogram welfare if year==2018, title("Welfare Distribution 2018")
histogram welfare if year==2021, title("Welfare Distribution 2021")
