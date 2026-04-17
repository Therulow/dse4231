clear
capture log close
set more off

global path "C:/Users/nashwinkumar/Empirical"
cd "$path"

log using "$path/Table3_Dynamic.log", replace

use "$path/crime_potsv4.dta", clear

xtset FIPS YEAR

global tvar1 STt_*
global tvar2 STt_* STtsq_*
global xvar1 GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnPOLICE lnREALINC

* Dynamic treatment variables matching the published Table 3 structure
global MEDvar D_MED_P0 D_MED_M1 D_MED_M2 D_MED_M3 D_MED_M4 D_MED_M5F
global RECvar D_REC_P0 D_REC_M1 D_REC_M2 D_REC_M3 D_REC_M4 D_REC_M5F

capture program drop run_dyn
program define run_dyn
    syntax varname, prefix(name)

    di "============================================================"
    di "Outcome: `varlist'"
    di "============================================================"

    eststo clear

    * ---------------- Model 1 ----------------
    di " "
    di "Model 1: FE + covariates"
    areg `varlist' $MEDvar $RECvar $xvar1 i.YEAR, absorb(FIPS) vce(robust)
    estimates store `prefix'7

    test (D_MED_P0 = D_MED_M1) ///
         (D_MED_M1 = D_MED_M2) ///
         (D_MED_M2 = D_MED_M3) ///
         (D_MED_M3 = D_MED_M4) ///
         (D_MED_M4 = D_MED_M5F)
    local F_med_7 = r(F)
    local p_med_7 = r(p)

    test (D_REC_P0 = D_REC_M1) ///
         (D_REC_M1 = D_REC_M2) ///
         (D_REC_M2 = D_REC_M3) ///
         (D_REC_M3 = D_REC_M4) ///
         (D_REC_M4 = D_REC_M5F)
    local F_rec_7 = r(F)
    local p_rec_7 = r(p)

    test (D_MED_P0 = D_MED_M1) ///
         (D_MED_M1 = D_MED_M2) ///
         (D_MED_M2 = D_MED_M3) ///
         (D_MED_M3 = D_MED_M4) ///
         (D_MED_M4 = D_MED_M5F) ///
         (D_REC_P0 = D_REC_M1) ///
         (D_REC_M1 = D_REC_M2) ///
         (D_REC_M2 = D_REC_M3) ///
         (D_REC_M3 = D_REC_M4) ///
         (D_REC_M4 = D_REC_M5F)
    local F_all_7 = r(F)
    local p_all_7 = r(p)

    estimates restore `prefix'7
    estadd scalar F_med = `F_med_7'
    estadd scalar p_med = `p_med_7'
    estadd scalar F_rec = `F_rec_7'
    estadd scalar p_rec = `p_rec_7'
    estadd scalar F_all = `F_all_7'
    estadd scalar p_all = `p_all_7'

    * ---------------- Model 2 ----------------
    di " "
    di "Model 2: FE + covariates + linear state trends"
    areg `varlist' $MEDvar $RECvar $tvar1 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
    estimates store `prefix'8

    test (D_MED_P0 = D_MED_M1) ///
         (D_MED_M1 = D_MED_M2) ///
         (D_MED_M2 = D_MED_M3) ///
         (D_MED_M3 = D_MED_M4) ///
         (D_MED_M4 = D_MED_M5F)
    local F_med_8 = r(F)
    local p_med_8 = r(p)

    test (D_REC_P0 = D_REC_M1) ///
         (D_REC_M1 = D_REC_M2) ///
         (D_REC_M2 = D_REC_M3) ///
         (D_REC_M3 = D_REC_M4) ///
         (D_REC_M4 = D_REC_M5F)
    local F_rec_8 = r(F)
    local p_rec_8 = r(p)

    test (D_MED_P0 = D_MED_M1) ///
         (D_MED_M1 = D_MED_M2) ///
         (D_MED_M2 = D_MED_M3) ///
         (D_MED_M3 = D_MED_M4) ///
         (D_MED_M4 = D_MED_M5F) ///
         (D_REC_P0 = D_REC_M1) ///
         (D_REC_M1 = D_REC_M2) ///
         (D_REC_M2 = D_REC_M3) ///
         (D_REC_M3 = D_REC_M4) ///
         (D_REC_M4 = D_REC_M5F)
    local F_all_8 = r(F)
    local p_all_8 = r(p)

    estimates restore `prefix'8
    estadd scalar F_med = `F_med_8'
    estadd scalar p_med = `p_med_8'
    estadd scalar F_rec = `F_rec_8'
    estadd scalar p_rec = `p_rec_8'
    estadd scalar F_all = `F_all_8'
    estadd scalar p_all = `p_all_8'

    * ---------------- Model 3 ----------------
    di " "
    di "Model 3: FE + covariates + linear and quadratic state trends"
    areg `varlist' $MEDvar $RECvar $tvar2 $xvar1 i.YEAR, absorb(FIPS) vce(robust)
    estimates store `prefix'9

    test (D_MED_P0 = D_MED_M1) ///
         (D_MED_M1 = D_MED_M2) ///
         (D_MED_M2 = D_MED_M3) ///
         (D_MED_M3 = D_MED_M4) ///
         (D_MED_M4 = D_MED_M5F)
    local F_med_9 = r(F)
    local p_med_9 = r(p)

    test (D_REC_P0 = D_REC_M1) ///
         (D_REC_M1 = D_REC_M2) ///
         (D_REC_M2 = D_REC_M3) ///
         (D_REC_M3 = D_REC_M4) ///
         (D_REC_M4 = D_REC_M5F)
    local F_rec_9 = r(F)
    local p_rec_9 = r(p)

    test (D_MED_P0 = D_MED_M1) ///
         (D_MED_M1 = D_MED_M2) ///
         (D_MED_M2 = D_MED_M3) ///
         (D_MED_M3 = D_MED_M4) ///
         (D_MED_M4 = D_MED_M5F) ///
         (D_REC_P0 = D_REC_M1) ///
         (D_REC_M1 = D_REC_M2) ///
         (D_REC_M2 = D_REC_M3) ///
         (D_REC_M3 = D_REC_M4) ///
         (D_REC_M4 = D_REC_M5F)
    local F_all_9 = r(F)
    local p_all_9 = r(p)

    estimates restore `prefix'9
    estadd scalar F_med = `F_med_9'
    estadd scalar p_med = `p_med_9'
    estadd scalar F_rec = `F_rec_9'
    estadd scalar p_rec = `p_rec_9'
    estadd scalar F_all = `F_all_9'
    estadd scalar p_all = `p_all_9'

    * On-screen compact table only
    di " "
    di "Compact coefficient table for `varlist':"
    esttab `prefix'7 `prefix'8 `prefix'9, ///
        keep($MEDvar $RECvar) ///
        cells(b(star fmt(3)) t(par fmt(2))) ///
        starlevels(* 0.10 ** 0.05 *** 0.01) ///
        stats(ar2 F_med p_med F_rec p_rec F_all p_all, ///
        fmt(4 2 3 2 3 2 3) ///
        labels("adj. R2" "F eq. D_MED" "(p-value)" ///
               "F eq. D_REC" "(p-value)" ///
               "F eq. all D" "(p-value)"))
end

run_dyn lnVIOLENT1, prefix(V)
run_dyn lnMURDER,   prefix(M)
run_dyn lnRAPE,     prefix(RA)
run_dyn lnROBBERY,  prefix(RO)
run_dyn lnASSAULT,  prefix(AS)
run_dyn lnPROPERTY, prefix(P)
run_dyn lnBURGLARY, prefix(B)
run_dyn lnLARCENY,  prefix(L)
run_dyn lnAUTO,     prefix(AU)

log close
exit