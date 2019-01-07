cap prog drop fhselect
cap set matastrict off
program define fhselect, rclass
	version 11.2
	#delimit ;
	syntax varlist (min=1 numeric fv) [if] [in],
	numvar(numlist max=1 int)
	pval(numlist max=1 >=0 <=1)
	REvar(varlist max=1 numeric) method(string);
#delimit cr		
set more off


marksample touse

tokenize `varlist'
local depvar `1'
macro shift
local indeps `*'


local BIC = 1e15
local AIC = 1e15
local AICc = 1e15
local LL  = 0

	while ((`nvar'< `numvar') & ()

