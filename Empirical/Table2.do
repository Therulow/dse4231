clear
capture log close
set more off

/* 
FE_ModelsTable2.do:

Read: \Data\crime_potsv4.dta
Log: FE_ModelsTable2.log

Sample period: 1995-2019.

Design of regressions:
1. D_MED, state and year fixed effects
2. D_MED, state and year fixed effects, common time trend
3. D_MED, state and year fixed effects, state specific time trend
4. D_REC, state and year fixed effects
5. D_MED, state and year fixed effects, common time trend
6. D_REC, state and year fixed effects, state specific time trend
7. D_MED, D_REC, state and year fixed effects
8. D_MED, D_REC, state and year fixed effects, common time trend
9. D_MED, D_REC, state and year fixed effects, state specific time trend

*/

global path "D:/OneDrive/Works/Crime_Pots/Empirical"
log using $path/Table2_FE.log, replace

use $path/crime_potsv4.dta


/* Set up panel data indices */
xtset FIPS YEAR

/* Set up explanatory variables */
global tvar1 STt_*
global tvar2 STt_* STtsq_*
global xvar1 GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnPOLICE lnREALINC
global xvar2 GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnPOLICE lnREALINC POP18_24 POP25_39 POP40_54 POP55_65 EDU_ATTAIN_25
global xvar3 GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnPOLICE lnREALINC POP18_24 POP25_39 POP40_54 POP55_65 EDU_ATTAIN_18_24 EDU_ATTAIN_25


/* FE Effect, Difference-in-Difference, and state specific trend */
areg lnVIOLENT1 D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store V1
areg lnVIOLENT1 D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store V2
areg lnVIOLENT1 D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store V3
areg lnVIOLENT1 D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store V4
areg lnVIOLENT1 D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store Table2
areg lnVIOLENT1 D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store V6
areg lnVIOLENT1 D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store V7
areg lnVIOLENT1 D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store V8
areg lnVIOLENT1 D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store V9
esttab V1 V2 V3 V4 Table2 V6 V7 V8 V9 using $path/Table2_VIOLENT1.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Violent 1)replace

areg lnMURDER D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store M1
areg lnMURDER D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store M2
areg lnMURDER D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store M3
areg lnMURDER D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store M4
areg lnMURDER D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store M5
areg lnMURDER D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store M6
areg lnMURDER D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store M7
areg lnMURDER D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store M8
areg lnMURDER D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store M9
esttab M1 M2 M3 M4 M5 M6 M7 M8 M9 using $path/Table2_Murder.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Murder)replace

areg lnRAPE D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RA1
areg lnRAPE D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RA2
areg lnRAPE D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store RA3
areg lnRAPE D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RA4
areg lnRAPE D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RA5
areg lnRAPE D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store RA6
areg lnRAPE D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RA7
areg lnRAPE D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RA8
areg lnRAPE D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store RA9
esttab RA1 RA2 RA3 RA4 RA5 RA6 RA7 RA8 RA9 using $path/Table2_Rape.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Rape)replace

areg lnROBBERY D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RO1
areg lnROBBERY D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RO2
areg lnROBBERY D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store RO3
areg lnROBBERY D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RO4
areg lnROBBERY D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RO5
areg lnROBBERY D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store RO6
areg lnROBBERY D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RO7
areg lnROBBERY D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store RO8
areg lnROBBERY D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store RO9
esttab RO1 RO2 RO3 RO4 RO5 RO6 RO7 RO8 RO9 using $path/Table2_Robbery.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Robbery)replace

areg lnASSAULT D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AS1
areg lnASSAULT D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AS2
areg lnASSAULT D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store AS3
areg lnASSAULT D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AS4
areg lnASSAULT D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AS5
areg lnASSAULT D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store AS6
areg lnASSAULT D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AS7
areg lnASSAULT D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AS8
areg lnASSAULT D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store AS9
esttab AS1 AS2 AS3 AS4 AS5 AS6 AS7 AS8 AS9 using $path/Table2_Assault.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Assault)replace

areg lnPROPERTY D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store P1
areg lnPROPERTY D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store P2
areg lnPROPERTY D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store P3
areg lnPROPERTY D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store P4
areg lnPROPERTY D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store P5
areg lnPROPERTY D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store P6
areg lnPROPERTY D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store P7
areg lnPROPERTY D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store P8
areg lnPROPERTY D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store P9
esttab P1 P2 P3 P4 P5 P6 P7 P8 P9 using $path/Table2_Property.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Property)replace

areg lnBURGLARY D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store B1
areg lnBURGLARY D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store B2
areg lnBURGLARY D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store B3
areg lnBURGLARY D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store B4
areg lnBURGLARY D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store B5
areg lnBURGLARY D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store B6
areg lnBURGLARY D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store B7
areg lnBURGLARY D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store B8
areg lnBURGLARY D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store B9
esttab B1 B2 B3 B4 B5 B6 B7 B8 B9 using $path/Table2_Burglary.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Burglary)replace

areg lnLARCENY D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store L1
areg lnLARCENY D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store L2
areg lnLARCENY D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store L3
areg lnLARCENY D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store L4
areg lnLARCENY D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store L5
areg lnLARCENY D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store L6
areg lnLARCENY D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store L7
areg lnLARCENY D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store L8
areg lnLARCENY D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store L9
esttab L1 L2 L3 L4 L5 L6 L7 L8 L9 using $path/Table2_Larceny.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Larceny Theft)replace

areg lnAUTO D_MED $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AU1
areg lnAUTO D_MED $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AU2
areg lnAUTO D_MED $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store AU3
areg lnAUTO D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AU4
areg lnAUTO D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AU5
areg lnAUTO D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store AU6
areg lnAUTO D_MED D_REC $xvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AU7
areg lnAUTO D_MED D_REC $xvar1 $tvar1 i.YEAR, absorb(FIPS) vce(robust)
est store AU8
areg lnAUTO D_MED D_REC $xvar1 $tvar2 i.YEAR, absorb(FIPS) vce(robust)
est store AU9
esttab AU1 AU2 AU3 AU4 AU5 AU6 AU7 AU8 AU9 using $path/Table2_Auto.tex, cells(b(star fmt(3)) t(par fmt(2))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ar2(4) ///
title(Auto Vehicle Theft)replace

log close
exit
