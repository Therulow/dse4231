clear
capture log close
set more off

/* 
SDIDv3.do:

Sample period: 1995-2019

t and tsq starts from 1 in 1995 and STt_** STtsq_** are adjusted accordingly.

*/

log using Table5_SDID.log, replace

use crime_potsv4.dta

replace AVG_MED = 0 if missing(AVG_MED)
replace AVG_REC = 0 if missing(AVG_REC)


// view the dataset

// summary
describe
codebook

// data variable names
ds

// first 10 rows
list in 1/10

// last 10 rows
count
list in -10/l


/* Set up explanatory variables */
global tvar STt_* 
global tvarsq STt_* STtsq_*
global xvar GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnREALINC
global xva_tvar STt_*  GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnREALINC
global xvar_tvarsq STt_* STtsq_* GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnREALINC



// alternative covariates
global xcore GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY lnREALINC
global xsubstance lnALCOHOL lnCIG
global xspill AVG_MED AVG_REC


// for violent crime and subcategories
global xvar_violent $xcore
global xvar_murder $xcore
global xvar_rape $xcore
global xvar_robbery $xcore
global xvar_assault $xcore

global xvar_violent_plus $xcore lnALCOHOL
global xvar_murder_plus $xcore lnALCOHOL
global xvar_rape_plus $xcore lnALCOHOL
global xvar_robbery_plus $xcore lnALCOHOL
global xvar_assault_plus $xcore lnALCOHOL

// for property crime and subcategories , alcohol is less central
global xvar_property $xcore
global xvar_burglary $xcore
global xvar_larceny $xcore
global xvar_auto $xcore



**************************************
******* trying some plots here *******
**************************************

sdid_event lnAUTO STATE YEAR D_MED, vce(bootstrap) covariates($tvars)

matrix res = e(H)[2...,1..5]
preserve
clear
svmat res
gen event_time = _n

twoway ///
    (rarea res3 res4 event_time, lc(gs10) fc(gs11%50)) ///
    (scatter res1 event_time, mc(blue) msymbol(D)) ///
    , legend(off) ///
      title("sdid_event") ///
      xtitle("Periods since treatment") ///
      ytitle("Effect on lnVIOLENT1") ///
      yline(0, lc(red) lp(dash))
restore




**************************************
******* for table  *******
**************************************

/* SDID, Difference-in-Difference, and state specific trend */


// Row 1a: Violent, Medical, projected
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) graph  // (1)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)
// same as above but with 500 BS replications
// sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) reps(500) // (1)
// sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) reps(500) covariates($tvar, projected) // (2)
// sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) reps(500) covariates($tvarsq, projected) // (3)
// sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) reps(500) covariates($xvar, projected) // (4)
// sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) reps(500) covariates($xva_tvar, projected) // (5)
// sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) reps(500) covariates($xvar_tvarsq, projected) // (6)
// same as above but using optimized
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($tvar, optimized) // (2)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, optimized) // (3)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($xvar, optimized) // (4)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, optimized) // (5)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, optimized) // (6)


// Row 1b: Violent, Recreational, projected
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)
// same as above but using optimized
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($tvar, optimized) // (2)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, optimized) // (3)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($xvar, optimized) // (4)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, optimized) // (5)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, optimized) // (6)



// Row 2a: Property, Medical, projected
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)
// same as above but using optimized
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, optimized) // (2)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, optimized) // (3)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, optimized) // (4)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, optimized) // (5)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, optimized) // (6)


// Row 2b: Property, Recreational, projected
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)

*******************************************************************************************

// Row 3a: Murder, Medical, projected
sdid lnMURDER STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnMURDER STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnMURDER STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnMURDER STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnMURDER STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnMURDER STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)

// Row 3b: Murder, Recreational, projected
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)

* done up to here
*******************************************************************************************

// Row 4a: Rape, Medical, projected
sdid lnRAPE STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnRAPE STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnRAPE STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnRAPE STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnRAPE STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnRAPE STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)


// Row 4b: Rape, Recreational, projected
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)

*******************************************************************************************

// Row 5a: Robbery, Medical, projected
sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)


// Row 5b: Murder, Recreational, projected
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)

*******************************************************************************************

// Row 6a: Assault, Medical, projected
sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)


// Row 6b: Assault, Recreational, projected
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)

*******************************************************************************************

// Row 7a: Burglary, Medical, projected
sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)


// Row 7b: Burglary, Recreational, projected
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)

*******************************************************************************************

// Row 8a: Larceny, Medical, projected
sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)


// Row 8b: Larceny, Recreational, projected
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)

*******************************************************************************************

// Row 9a: Auto, Medical, projected
sdid lnAUTO STATE YEAR D_MED, vce(bootstrap) // (1)
sdid lnAUTO STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnAUTO STATE YEAR D_MED, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnAUTO STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnAUTO STATE YEAR D_MED, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnAUTO STATE YEAR D_MED, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)


// Row 9b: Auto, Recreational, projected
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap) // (1)
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected) // (2)
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap) covariates($tvarsq, projected) // (3)
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected) // (4)
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap) covariates($xva_tvar, projected) // (5)
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap) covariates($xvar_tvarsq, projected) // (6)








// everything below is raw replication code 


// sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($xvar, optimized)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnVIOLENT1 STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnPROPERTY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap)
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnPROPERTY STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

sdid lnMURDER STATE YEAR D_MED, vce(bootstrap)
sdid lnMURDER STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnMURDER STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap)
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnMURDER STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

sdid lnRAPE STATE YEAR D_MED, vce(bootstrap)
sdid lnRAPE STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnRAPE STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap)
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnRAPE STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap)
sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnROBBERY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap)
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnROBBERY STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap)
sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnASSAULT STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap)
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnASSAULT STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap)
sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnBURGLARY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap)
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnBURGLARY STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap)
sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnLARCENY STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap)
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnLARCENY STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

sdid lnAUTO STATE YEAR D_MED, vce(bootstrap)
sdid lnAUTO STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnAUTO STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap)
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap) covariates($tvar, projected)
sdid lnAUTO STATE YEAR D_REC, vce(bootstrap) covariates($xvar, projected)

log close
exit
