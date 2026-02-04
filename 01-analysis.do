clear all
set more off
cd "`c(pwd)'"

use "data/survey-2018-2021-pre-cleaned.dta", clear
gen obs=1
collapse (sum) n=obs, by(region year)
save "data/t1.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
collapse (mean) m1=age (sd) s1=age, by(region year)
save "data/t2.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
collapse (mean) m2=literacy (sd) s2=literacy, by(region year)
save "data/t3.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
collapse (mean) m3=welfare_ppp (sd) s3=welfare_ppp, by(region year)
save "data/t4.dta", replace

use "data/t1.dta", clear
merge 1:1 region year using "data/t2.dta", nogen
merge 1:1 region year using "data/t3.dta", nogen
merge 1:1 region year using "data/t4.dta", nogen

gen age_mean = m1
gen age_sd = s1
gen lit_mean = m2
gen lit_sd = s2
gen wel_mean = m3
gen wel_sd = s3
drop m1 s1 m2 s2 m3 s3

use "data/survey-2018-2021-pre-cleaned.dta", clear
gen temp=1
bysort region year hhid: replace temp=0 if _n>1
collapse (sum) hhsize=temp, by(region year)
save "data/t5.dta", replace

use "data/t1.dta", clear
merge 1:1 region year using "data/t2.dta", nogen
merge 1:1 region year using "data/t3.dta", nogen
merge 1:1 region year using "data/t4.dta", nogen
merge 1:1 region year using "data/t5.dta", nogen

gen age_m = m1
gen age_s = s1
gen lit_m = m2
gen lit_s = s2
gen wel_m = m3
gen wel_s = s3
drop m1 s1 m2 s2 m3 s3

order region year n hhsize age_m age_s lit_m lit_s wel_m wel_s

list region year n hhsize age_m age_s lit_m lit_s wel_m wel_s, clean

export delimited "data/output_table.csv", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
bysort year: egen med_wel = median(welfare_ppp)
gen pov_line = med_wel * 0.4
save "data/temp_pov.dta", replace

use "data/temp_pov.dta", clear
gen poor = (welfare_ppp < pov_line)
collapse (mean) pov_rate=poor, by(region year)
save "data/t1.dta", replace

use "data/temp_pov.dta", clear
gen poor = (welfare_ppp < pov_line)
gen gap = (pov_line - welfare_ppp) / pov_line if poor==1
replace gap = 0 if poor==0
collapse (mean) pov_gap=gap, by(region year)
save "data/t2.dta", replace

use "data/temp_pov.dta", clear
collapse (mean) mean_w=welfare_ppp, by(region year)
save "data/t3.dta", replace

use "data/temp_pov.dta", clear
bysort region year: egen n_obs = count(welfare_ppp)
gen temp_var = welfare_ppp
sort region year temp_var
by region year: gen rank = _n
gen diff_sum = 0
save "data/temp_gini.dta", replace

use "data/temp_gini.dta", clear
bysort region year: egen sum_w = sum(welfare_ppp)
by region year: gen weight = (2 * rank - n_obs - 1) * welfare_ppp
by region year: egen sum_weight = sum(weight)
gen gini = sum_weight / (n_obs * sum_w)
collapse (mean) gini_idx=gini, by(region year)
save "data/t4.dta", replace

use "data/temp_pov.dta", clear
bysort region year: egen mean_inc = mean(welfare_ppp)
gen ratio = welfare_ppp / mean_inc
gen theil_comp = ratio * ln(ratio)
replace theil_comp = 0 if missing(theil_comp)
collapse (mean) theil=theil_comp, by(region year)
save "data/t5.dta", replace

use "data/t1.dta", clear
merge 1:1 region year using "data/t2.dta", nogen
save "data/temp_merge1.dta", replace

use "data/temp_merge1.dta", clear
merge 1:1 region year using "data/t3.dta", nogen
merge 1:1 region year using "data/t4.dta", nogen
save "data/temp_merge2.dta", replace

use "data/temp_merge2.dta", clear
merge 1:1 region year using "data/t5.dta", nogen

gen pr_m = pov_rate
gen pr_s = .
gen pg_m = pov_gap
gen pg_s = .
gen gi_m = gini_idx
gen gi_s = .
gen th_m = theil
gen th_s = .

drop pov_rate pov_gap mean_w gini_idx theil

order region year pr_m pr_s pg_m pg_s gi_m gi_s th_m th_s

list region year pr_m pr_s pg_m pg_s gi_m gi_s th_m th_s, clean

export delimited "data/output_table2.csv", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
gen obs=1
collapse (sum) n=obs, by(year)
save "data/t1.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
collapse (mean) m1=age (sd) s1=age, by(year)
save "data/t2.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
gen temp=1
bysort year hhid: replace temp=0 if _n>1
collapse (sum) hhsize=temp, by(year)
save "data/t3.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
collapse (mean) m2=literacy (sd) s2=literacy, by(year)
save "data/t4.dta", replace

use "data/t1.dta", clear
merge 1:1 year using "data/t2.dta", nogen
merge 1:1 year using "data/t3.dta", nogen
save "data/temp_c1.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
collapse (mean) m3=welfare_ppp (sd) s3=welfare_ppp, by(year)
save "data/t5.dta", replace

use "data/temp_c1.dta", clear
merge 1:1 year using "data/t4.dta", nogen
merge 1:1 year using "data/t5.dta", nogen

use "data/survey-2018-2021-pre-cleaned.dta", clear
bysort year: egen med_wel = median(welfare_ppp)
gen pov_line = med_wel * 0.4
gen poor = (welfare_ppp < pov_line)
collapse (mean) pov_rate=poor, by(year)
save "data/t6.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
bysort year: egen med_wel = median(welfare_ppp)
gen pov_line = med_wel * 0.4
gen poor = (welfare_ppp < pov_line)
gen gap = (pov_line - welfare_ppp) / pov_line if poor==1
replace gap = 0 if poor==0
collapse (mean) pov_gap=gap, by(year)
save "data/t7.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
bysort year: egen n_obs = count(welfare_ppp)
sort year welfare_ppp
by year: gen rank = _n
bysort year: egen sum_w = sum(welfare_ppp)
by year: gen weight = (2 * rank - n_obs - 1) * welfare_ppp
by year: egen sum_weight = sum(weight)
gen gini = sum_weight / (n_obs * sum_w)
collapse (mean) gini_idx=gini, by(year)
save "data/t8.dta", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
bysort year: egen mean_inc = mean(welfare_ppp)
gen ratio = welfare_ppp / mean_inc
gen theil_comp = ratio * ln(ratio)
replace theil_comp = 0 if missing(theil_comp)
collapse (mean) theil=theil_comp, by(year)
save "data/t9.dta", replace

use "data/t1.dta", clear
merge 1:1 year using "data/t2.dta", nogen
merge 1:1 year using "data/t3.dta", nogen
merge 1:1 year using "data/t4.dta", nogen
merge 1:1 year using "data/t5.dta", nogen
merge 1:1 year using "data/t6.dta", nogen
save "data/temp_c2.dta", replace

use "data/temp_c2.dta", clear
merge 1:1 year using "data/t7.dta", nogen
merge 1:1 year using "data/t8.dta", nogen
merge 1:1 year using "data/t9.dta", nogen

gen c_n = n
gen c_hh = hhsize
gen c_age_m = m1
gen c_age_s = s1
gen c_lit_m = m2
gen c_lit_s = s2
gen c_wel_m = m3
gen c_wel_s = s3
gen c_pr_m = pov_rate
gen c_pg_m = pov_gap
gen c_gi_m = gini_idx
gen c_th_m = theil

drop n hhsize m1 s1 m2 s2 m3 s3 pov_rate pov_gap gini_idx theil

order year c_n c_hh c_age_m c_age_s c_lit_m c_lit_s c_wel_m c_wel_s c_pr_m c_pg_m c_gi_m c_th_m

list year c_n c_hh c_age_m c_age_s c_lit_m c_lit_s c_wel_m c_wel_s c_pr_m c_pg_m c_gi_m c_th_m, clean

export delimited "data/output_table3.csv", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear

quietly reg welfare_ppp age adult adult_working i.educat4 i.literacy i.year
estimates store model1

use "data/survey-2018-2021-pre-cleaned.dta", clear

quietly reg welfare_ppp age adult adult_working i.educat4 i.literacy i.year if year==2018
estimates store model2

quietly reg welfare_ppp age adult adult_working i.educat4 i.literacy if year==2021
estimates store model3

use "data/survey-2018-2021-pre-cleaned.dta", clear

quietly reg welfare_ppp age i.adult i.adult_working educat4 literacy i.year, robust
estimates store model4

estimates table model1 model2 model3 model4, stats(N r2)

use "data/survey-2018-2021-pre-cleaned.dta", clear
histogram age, title("Age Distribution")
graph export "data/hist_age.png", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
gen temp=1
bysort hhid: replace temp=0 if _n>1
gen hh_temp=1 if temp==1
bysort hhid: egen hh_size = count(hhid)
histogram hh_size if temp==1, title("Household Size Distribution")
graph export "data/hist_hhsize.png", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
histogram welfare_ppp, title("Welfare PPP Distribution")
graph export "data/hist_welfare.png", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
histogram welfare_ppp if year==2018, title("Welfare PPP 2018")
graph export "data/hist_welfare_2018.png", replace

use "data/survey-2018-2021-pre-cleaned.dta", clear
histogram welfare_ppp if year==2021, title("Welfare PPP 2021")
graph export "data/hist_welfare_2021.png", replace
