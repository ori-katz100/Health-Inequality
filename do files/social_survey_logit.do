use "social_survey_2017.dta", clear

*creating variables and renaming LAMAS variables:
gen female = (minn == 2)
gen arab = (pop_group == 2)
gen academic = (teudagvoha == 4 | teudagvoha == 5 | teudagvoha == 6)
replace academic = . if teudagvoha == . | teudagvoha == 888888 | teudagvoha == 999999
gen phisical_occ = (semelmishlach_wp == 6 | semelmishlach_wp == 7 | semelmishlach_wp == 8 | semelmishlach_wp == 9)
replace phisical_occ = . if semelmishlach_wp == 999999 | semelmishlach_wp == .
rename gil age_group
rename hachnasaavoda income_group
replace income_group = 0 if income_group == 11
replace income_group = . if income_group == 888888 | income_group == 999999
gen weight = round(nn)
gen haredi = (datiutyehudi == 1)

gen good_health = (matzavbriut == 1)
replace good_health = . if matzavbriut == . | matzavbriut == 888888
gen good_health2 = (matzavbriut5 == 1)
replace matzavbriut = . if matzavbriut == 888888 | matzavbriut == 999999
replace good_health2 = . if matzavbriut == . | matzavbriut == 888888
replace kamamemutak = .  if kamamemutak == 888888 | kamamemutak == 999999
replace kamayerakot = .  if kamayerakot == 888888 | kamayerakot == 999999
replace kamaperot = .  if kamaperot == 888888 | kamaperot == 999999
replace pegufanithaimasak = .  if pegufanithaimasak == 888888 | pegufanithaimasak == 999999
replace pegufanithaimasak = 0 if pegufanithaimasak == 2
replace ishunkayom = .  if ishunkayom == 888888 | ishunkayom == 999999
replace ishunkayom = 0 if ishunkayom == 2
gen vaccin = (hisunyeladim == 1)
replace vaccin = .  if hisunyeladim == 888888 | hisunyeladim == 999999
replace viturtipulrefuyi  = .  if viturtipulrefuyi == 888888 | viturtipulrefuyi == 999999
replace viturtipulrefuyi = 0 if viturtipulrefuyi == 2
replace viturterufot  = .  if viturterufot == 888888 | viturterufot == 999999
replace viturterufot = 0 if viturterufot == 2
replace lachuz  = . if lachuz == 888888 | lachuz == 999999 // 1 is the largest
replace meduke  = . if meduke == 888888 | meduke == 999999 // 1 is the largest
gen stressed = (lachuz == 1)
gen dipressed = (meduke == 1)

gen non_smoker = 1 - ishunkayom
gen non_stressed = 1 - stressed
gen non_dipressed = 1 - dipressed

*************************************************************************************************************************
*good health regressions:

set more off

logit good_health income_group female age_group [pweight = nn], or
outreg2 using "social_logit.xls", replace eform cti(odds ratio) 

logit good_health academic female age_group [pweight = nn], or
outreg2 using "social_logit.xls", eform cti(odds ratio)

logit good_health phisical_occ female age_group [pweight = nn], or
outreg2 using "social_logit.xls", eform cti(odds ratio)

logit good_health arab female age_group [pweight = nn], or
outreg2 using "social_logit.xls", eform cti(odds ratio)

logit good_health haredi female age_group [pweight = nn], or
outreg2 using "social_logit.xls", eform cti(odds ratio)

logit good_health i.nafa female age_group [pweight = nn], or
outreg2 using "social_logit.xls", eform cti(odds ratio)

logit good_health income_group academic phisical_occ arab haredi i.nafa female age_group [pweight = nn], or
outreg2 using "social_logit.xls", eform cti(odds ratio)

*************************************************************************************************************************
*behavior regressions: 
 
foreach var in good_health kamamemutak kamayerakot kamaperot pegufanithaimasak ishunkayom vaccin viturtipulrefuyi viturterufot stressed dipressed good_health2 matzavbriut {
	
	if "`var'" == "good_health" local rep = "replace"
	if "`var'" != "good_health" local rep = " "
		
	reg `var' income_group academic phisical_occ arab haredi female age_group i.nafa [pweight = nn]
	outreg2 using "social.xls", ctitle(`var') `rep'

}
