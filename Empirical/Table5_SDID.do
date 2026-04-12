clear
capture log close
set more off

/* 
SDIDv3.do:

Sample period: 1995-2019

t and tsq starts from 1 in 1995 and STt_** STtsq_** are adjusted accordingly.

*/

global path "D:/OneDrive/Works/Crime_Pots/Empirical"
log using $path/Table5_SDID.log, replace

use $path/crime_potsv4.dta

replace AVG_MED = 0 if missing(AVG_MED)
replace AVG_REC = 0 if missing(AVG_REC)

/* Set up explanatory variables */
global tvar STt_* STtsq_*
global xvar GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnREALINC

/* SDID, Difference-in-Difference, and state specific trend */

sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($tvar, projected)
sdid lnVIOLENT1 STATE YEAR D_MED, vce(bootstrap) covariates($xvar, projected)
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
