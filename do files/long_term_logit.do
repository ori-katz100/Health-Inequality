use "long_term_2017.dta", clear

*creating variables and renaming LAMAS variables:
replace matzavbriut1 = . if matzavbriut1 > 4
gen good_health = (matzavbriut1 == 1)
replace good_health = . if matzavbriut1 == .
gen arab = (leom == 2)
gen haredi = (datiutyehudi1 == 1) //this is problematic, they only asked the first respondend, i need to give all others from the same family the same code
bysort siduri: egen haredi2 = max(haredi) // this is for all the family
gen academic = (teudagvoha1 == 4 | teudagvoha1 == 5 | teudagvoha1 == 6)
replace academic = . if teudagvoha1 == .
gen phisical_occ = (semelmishlach1 == "6" | semelmishlach1 == "7" | semelmishlach1 == "8" | semelmishlach1 == "9")
replace phisical_occ = . if semelmishlach1 == "X" | semelmishlach1 == ""  
rename sacshnati_lepratmeavoda total_income
gen female = (min1 == 2)
rename gil1 age
replace total_income = . if total_income == 0
gen ltotal_income = ln(total_income)
egen ztotal_income = std(total_income)
egen zage = std(age)
gen weight = round(mishkalprat)
xtile inc_quarters = total_income [fweight = weight], nq(4)
gen top_25 = (inc_quarters == 4)
gen bottom_25 = (inc_quarters == 1)

gen overweight = (bmi > 25)
replace overweight = . if bmi == .
tab overweight

gen overweight2 = (bmi > 30)
replace overweight2 = . if bmi == .
tab overweight2

gen overweight3 = (bmi <= 25)
replace overweight3 = . if bmi == .
tab overweight

*************************************************************************************************************************
*good health regressions:

set more off

logit good_health ltotal_income female age [pweight = mishkalprat], or
outreg2 using "longterm.xls", replace eform cti(odds ratio)

logit good_health academic female age [pweight = mishkalprat], or
outreg2 using "longterm.xls", eform cti(odds ratio)

logit good_health phisical_occ female age [pweight = mishkalprat], or
outreg2 using "longterm.xls", eform cti(odds ratio)

logit good_health arab female age [pweight = mishkalprat], or
outreg2 using "longterm.xls", eform cti(odds ratio)

logit good_health haredi2 female age [pweight = mishkalprat], or
outreg2 using "longterm.xls", eform cti(odds ratio)

logit good_health ltotal_income academic phisical_occ arab haredi2 female age [pweight = mishkalprat], or
outreg2 using "longterm.xls", eform cti(odds ratio)

*************************************************************************************************************************
*bmi regressions:

logit overweight ltotal_income female age [pweight = mishkalprat], or
outreg2 using "longterm_bmi.xls", replace eform cti(odds ratio)

logit overweight academic female age [pweight = mishkalprat], or
outreg2 using "longterm_bmi.xls", eform cti(odds ratio)

logit overweight phisical_occ female age [pweight = mishkalprat], or
outreg2 using "longterm_bmi.xls", eform cti(odds ratio)

logit overweight arab female age [pweight = mishkalprat], or
outreg2 using "longterm_bmi.xls", eform cti(odds ratio)

logit overweight haredi2 female age [pweight = mishkalprat], or
outreg2 using "longterm_bmi.xls", eform cti(odds ratio)

logit overweight ltotal_income academic phisical_occ arab haredi2 female age [pweight = mishkalprat], or
outreg2 using "longterm_bmi.xls", eform cti(odds ratio)

