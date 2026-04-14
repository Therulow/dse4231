clear
capture log close
set more off

/* 
SDIDv3.do:

Sample period: 1995-2019

t and tsq starts from 1 in 1995 and STt_** STtsq_** are adjusted accordingly.

*/

log using generate_event_study_plots.log, replace

cd "/Users/jerontan/Desktop/y4s2/DSE4231/project/replicate/"
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


// /* Set up explanatory variables */
// global tvar STt_* 
// global tvarsq STt_* STtsq_*
// global xvar GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnREALINC
// global xva_tvar STt_*  GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnREALINC
// global xvar_tvarsq STt_* STtsq_* GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY AVG_MED AVG_REC lnCIG lnALCOHOL lnREALINC
//
//
//
// // alternative covariates
// global xcore GOV_DEM STATE_DEM POV_RATE UNRATE POP_DENSITY lnREALINC
// global xsubstance lnALCOHOL lnCIG
// global xspill AVG_MED AVG_REC
//
//
// // for violent crime and subcategories
// global xvar_violent $xcore
// global xvar_murder $xcore
// global xvar_rape $xcore
// global xvar_robbery $xcore
// global xvar_assault $xcore
//
// global xvar_violent_plus $xcore lnALCOHOL
// global xvar_murder_plus $xcore lnALCOHOL
// global xvar_rape_plus $xcore lnALCOHOL
// global xvar_robbery_plus $xcore lnALCOHOL
// global xvar_assault_plus $xcore lnALCOHOL
//
// // for property crime and subcategories , alcohol is less central
// global xvar_property $xcore
// global xvar_burglary $xcore
// global xvar_larceny $xcore
// global xvar_auto $xcore


*====================================================*
* RUN ALL PLOTS: Event study SDID plots for all outcomes and treatments
*====================================================*

capture mkdir "../plots"

* outcomes and proper labels
local outcomes  "lnVIOLENT1 lnPROPERTY lnMURDER lnRAPE lnROBBERY lnASSAULT lnBURGLARY lnLARCENY lnAUTO"
local ylabels   `" "Violent Crimes" "Property Crimes" "Murder" "Rape" "Robbery" "Aggravated Assault" "Burglary" "Larceny Theft" "Auto Vehicle Theft" "'

* treatments and proper labels
local treats    "D_MED D_REC"
local tlabels   `" "Medical Legalization" "Recreational Legalization" "'

local n_outcomes : word count `outcomes'
local n_treats   : word count `treats'

forvalues i = 1/`n_outcomes' {
    local yvar    : word `i' of `outcomes'
    local ylabel  : word `i' of `ylabels'

    forvalues j = 1/`n_treats' {
        local dvar    : word `j' of `treats'
        local dlabel  : word `j' of `tlabels'

        di as text "Running sdid_event for `yvar' with `dvar'..."
		
		// (1)
// 		sdid_event `yvar' STATE YEAR `dvar', vce(bootstrap) placebo(5)
		
		
		// (2) add state specific linear trends
		unab tvar_expanded : STt_* STtsq_*
		sdid_event `yvar' STATE YEAR `dvar', vce(bootstrap) placebo(5) covariates("`tvar_expanded'")
		
		
		// (3) add state specific linear and quad trends
// 		unab tvar_expanded : STt_* STtsq_*
// 		sdid_event `yvar' STATE YEAR `dvar', vce(bootstrap) placebo(5) covariates("`tvar_expanded'")
		

        * run event-study SDID with 5 placebo periods


        * pull results matrix: cols are estimate, se, lb, ub, switchers
        matrix res = e(H)[2...,1..5]
		local nrows = rowsof(res)

		preserve
		clear
		set obs `nrows'
		svmat res

		local n_pre = 5
		local n_total = _N
		local n_post = `n_total' - `n_pre'

		gen event_time = .
		replace event_time = _n if _n <= `n_post'
		replace event_time = -`n_pre' + (_n - `n_post' - 1) if _n > `n_post'

		sort event_time
		gen switchers_lbl = string(res5, "%9.0f")

		twoway ///
			(rarea res3 res4 event_time, lc(gs10) fc(gs11%50)) ///
			(scatter res1 event_time, mc(blue) msymbol(D) ///
				mlabel(switchers_lbl) mlabpos(12) mlabsize(small)) ///
			, legend(off) ///
			  title("`dlabel': `ylabel'") ///
			  xtitle("Event time") ///
			  ytitle("Effect on `ylabel'") ///
			  yline(0, lc(red) lp(dash)) ///
			  xline(0, lc(black) lp(solid)) ///
			  name(g_`yvar'_`dvar', replace)

		graph export "../plots/model_3b/`yvar'_`dvar'_sdid_event.png", replace width(2000)

		restore
    }
}

log close



*====================================================*
* Single Iteration 
*====================================================*


local yvar   "lnPROPERTY"
local ylabel "Property"
local dvar   "D_MED"
local dlabel "Medical Legalization"

di as text "Running sdid_event for `yvar' with `dvar'..."

* (2) add state specific linear trends
unab tvar_expanded : STt_*
sdid_event `yvar' STATE YEAR `dvar', vce(bootstrap) placebo(5) covariates("`tvar_expanded'")

* pull results matrix: cols are estimate, se, lb, ub, switchers
matrix res = e(H)[2...,1..5]
local nrows = rowsof(res)

preserve
clear
set obs `nrows'
svmat res

local n_pre = 5
local n_total = _N
local n_post = `n_total' - `n_pre'

gen event_time = .
replace event_time = _n if _n <= `n_post'
replace event_time = -`n_pre' + (_n - `n_post' - 1) if _n > `n_post'

sort event_time
gen switchers_lbl = string(res5, "%9.0f")

twoway ///
    (rarea res3 res4 event_time, lc(gs10) fc(gs11%50)) ///
    (scatter res1 event_time, mc(blue) msymbol(D) ///
        mlabel(switchers_lbl) mlabpos(12) mlabsize(small)) ///
    , legend(off) ///
      title("`dlabel': `ylabel'") ///
      xtitle("Event time") ///
      ytitle("Effect on `ylabel'") ///
      yline(0, lc(red) lp(dash)) ///
      xline(0, lc(black) lp(solid)) ///
      name(g_`yvar'_`dvar', replace)



restore
