clear
capture log close
set more off

global path "D:/OneDrive/Works/Crime_Pots/Empirical"
log using $path/Table1_Summ.log, replace

use $path/crime_potsv4.dta

gen VIOLENT1 = exp(lnVIOLENT1)
gen MURDER = exp(lnMURDER) 
gen RAPE = exp(lnRAPE)
gen ROBBERY = exp(lnROBBERY)
gen ASSAULT = exp(lnASSAULT)
gen PROPERTY = exp(lnPROPERTY)
gen BURGLARY = exp(lnBURGLARY)
gen LARCENY = exp(lnLARCENY)
gen AUTO = exp(lnAUTO)

summ VIOLENT1 MURDER RAPE ROBBERY ASSAULT PROPERTY BURGLARY LARCENY AUTO

log close
exit
