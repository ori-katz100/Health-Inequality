use "localities.dta", clear
set more off

gen cancer_mean = (invasive_asr_m_n + invasive_asr_f_n)/2 //mean cancer for males and females
gen jewish = (arabs10 <= 10 & arabs10 != .) // jewish localities
gen arab = (arabs10 >= 90 & arabs10 != .) // arab localities

*standardisation: 
foreach var in sahar_shirim_tot15_n rx1317_stdfr_n m0_1317_n ex0_1317_n diabdsr14_16_n bmi85plus_gr7_1718_n cancer_mean dist_telaviv_km ///
	travel_time death_per_hosp_2017 bagrut_1516_n jews16_n {
	egen z`var' = std(`var')
}


foreach var in zrx1317_stdfr_n zm0_1317_n zex0_1317_n zdiabdsr14_16_n zbmi85plus_gr7_1718_n zcancer_mean zdeath_per_hosp_2017 {

	if "`var'" == "zrx1317_stdfr_n" local rep = "replace"
	if "`var'" != "zrx1317_stdfr_n" local rep = " "
	
	reg `var' zsahar_shirim_tot15_n zbagrut_1516_n arab  ztravel_time zdist_telaviv_km  
	outreg2 using "locality_reg.xls", `rep'   
	
}

foreach var in zrx1317_stdfr_n zm0_1317_n zex0_1317_n zdiabdsr14_16_n zbmi85plus_gr7_1718_n zcancer_mean zdeath_per_hosp_2017 {

	if "`var'" == "zrx1317_stdfr_n" local rep = "replace"
	if "`var'" != "zrx1317_stdfr_n" local rep = " "
	
	reg `var' zsahar_shirim_tot15_n zbagrut_1516_n arab  ztravel_time   
	outreg2 using "locality_reg_ztravel_time.xls", `rep'   
	
}

foreach var in zrx1317_stdfr_n zm0_1317_n zex0_1317_n zdiabdsr14_16_n zbmi85plus_gr7_1718_n zcancer_mean zdeath_per_hosp_2017 {

	if "`var'" == "zrx1317_stdfr_n" local rep = "replace"
	if "`var'" != "zrx1317_stdfr_n" local rep = " "
	
	reg `var' zsahar_shirim_tot15_n zbagrut_1516_n arab  zdist_telaviv_km  
	outreg2 using "locality_reg_telaviv_km.xls", `rep'   
	
}

*district-level analysis:
encode district, gen(district_n)

foreach var in zrx1317_stdfr_n zm0_1317_n zex0_1317_n zdiabdsr14_16_n zbmi85plus_gr7_1718_n zcancer_mean zdeath_per_hosp_2017 {

	if "`var'" == "zrx1317_stdfr_n" local rep = "replace"
	if "`var'" != "zrx1317_stdfr_n" local rep = " "
	
	reg `var' zsahar_shirim_tot15_n zbagrut_1516_n arab i.district_n 
	outreg2 using "locality_reg_distict.xls", `rep'   
	
}

