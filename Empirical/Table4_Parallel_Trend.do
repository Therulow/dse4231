clear
capture log close
set more off

/* 
FE_Models_CausalTable4.do:

Sample period: 1995-2019
t and tsq starts from 1 in 1995 and STt_** STtsq_** are adjusted accordingly.

The difference between this version and version 5 is we add more D_RECtrimmed most of the models that only include
medical or recreational marijuna legalization and keep everything instead. We also include F-test
for all medical, all recreational, or both lagged terms.

5/05/2025
*/

global path "D:/OneDrive/Works/Crime_Pots/Empirical"
log using $path/Table4_Parallel_Trend.log, replace

use $path/crime_potsv4.dta


/* Set up panel data indices */
xtset FIPS YEAR

/* Set up explanatory variables */
global tvar1 STt_*
global tvar2 STt_* STtsq_*
global xvar1 GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnPOLICE lnREALINC
global MEDvar D_MED_P2 D_MED_P1 D_MED_P0 D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
global RECvar D_REC_P2 D_REC_P1 D_REC_P0 D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F

/* FE Effect, Difference-in-Difference, and state specific trend */

areg lnVIOLENT1 $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store V7

areg lnVIOLENT1 $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store V8

areg lnVIOLENT1 $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store V9

areg lnPROPERTY $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store P7

areg lnPROPERTY $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store P8

areg lnPROPERTY $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store P9
esttab V7 V8 V9 P7 P8 P9 using $path/Table5_VIOLENT1_Property.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Violent Property)replace

areg lnMURDER $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store M7

areg lnMURDER $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store M8

areg lnMURDER $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store M9

areg lnBURGLARY $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store B7

areg lnBURGLARY $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store B8

areg lnBURGLARY $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store B9
esttab M7 M8 M9 B7 B8 B9 using $path/Table5_Murder_Burglary.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Murder Burglary)replace

areg lnRAPE $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store RA7

areg lnRAPE $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store RA8

areg lnRAPE $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store RA9

areg lnLARCENY $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store L7

areg lnLARCENY $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store L8

areg lnLARCENY $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store L9
esttab RA7 RA8 RA9 L7 L8 L9 using $path/Table5_Rape_Larceny.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Rape Larceny Theft)replace

areg lnROBBERY $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store RO7

areg lnROBBERY $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store RO8

areg lnROBBERY $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store RO9

areg lnAUTO $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store AU7

areg lnAUTO $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store AU8

areg lnAUTO $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store AU9
esttab RO7 RO8 RO9 AU7 AU8 AU9 using $path/Table5_Robbery_Auto.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Robbery Auto Vehicle Theft)replace

areg lnASSAULT $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store AS7

areg lnASSAULT $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store AS8

areg lnASSAULT $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_P2 D_MED_P1
test D_REC_P2 D_REC_P1
test D_MED_P2 D_MED_P1 D_REC_P2 D_REC_P1
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
test D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
test D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F
est store AS9
esttab AS7 AS8 AS9 using $path/Table5_Assault.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Assault)replace





log close
exit
