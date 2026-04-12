clear
capture log close
set more off

/* 
FE_Models_CausalTable3.do:

Sample period: 1995-2019
t and tsq starts from 1 in 1995 and STt_** STtsq_** are adjusted accordingly.

5/05/2025
*/

global path "D:/OneDrive/Works/Crime_Pots/Empirical"
log using $path/Table3_Dynamic.log, replace

use $path/crime_potsv3.dta


/* Set up panel data indices */
xtset FIPS YEAR

/* Set up explanatory variables */
global tvar1 STt_*
global tvar2 STt_* STtsq_*
global xvar1 GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnPOLICE lnREALINC
global MEDvar D_MED_P0 D_MED_M1 D_MED_M2 D_MED_M3F
global RECvar D_REC_P0 D_REC_M1 D_REC_M2 D_REC_M3F

/* FE Effect, Difference-in-Difference, and state specific trend */

areg lnVIOLENT1 $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store V7
areg lnVIOLENT1 $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store V8
areg lnVIOLENT1 $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store V9
esttab V7 V8 V9 using $path/Table3_VIOLENT1.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Violent 1)replace

areg lnMURDER $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store M7
areg lnMURDER $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store M8
areg lnMURDER $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store M9
esttab M7 M8 M9 using $path/Table3_Murder.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Murder)replace

areg lnRAPE $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store RA7
areg lnRAPE $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store RA8
areg lnRAPE $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store RA9
esttab RA7 RA8 RA9 using $path/Table3_Rape.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Rape)replace

areg lnROBBERY $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store RO7
areg lnROBBERY $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store RO8
areg lnROBBERY $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store RO9
esttab RO7 RO8 RO9 using $path/Table3_Robbery.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Robbery)replace

areg lnASSAULT $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store AS7
areg lnASSAULT $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store AS8
areg lnASSAULT $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store AS9
esttab AS7 AS8 AS9 using $path/Table3_Assault.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Assault)replace

areg lnPROPERTY $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store P7
areg lnPROPERTY $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store P8
areg lnPROPERTY $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store P9
esttab P7 P8 P9 using $path/Table3_Property.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Property)replace

areg lnBURGLARY $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store B7
areg lnBURGLARY $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store B8
areg lnBURGLARY $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store B9
esttab B7 B8 B9 using $path/Table3_Burglary.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Burglary)replace

areg lnLARCENY $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store L7
areg lnLARCENY $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store L8
areg lnLARCENY $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store L9
esttab L7 L8 L9 using $path/Table3_Larceny.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Larceny Theft)replace

areg lnAUTO $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store AU7
areg lnAUTO $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store AU8
areg lnAUTO $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
test D_MED_M1 D_MED_M2 D_MED_M3F 
test D_REC_M1 D_REC_M2 D_REC_M3F
test D_MED_M1 D_MED_M2 D_MED_M3F D_REC_M1 D_REC_M2 D_REC_M3F
est store AU9
esttab AU7 AU8 AU9 using $path/Table3_Auto.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Auto Vehicle Theft)replace

log close
exit
