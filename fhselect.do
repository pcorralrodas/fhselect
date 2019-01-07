cap prog drop fhselect
cap set matastrict off
program define fhselect, rclass
	version 11.2
	#delimit ;
	syntax varlist (min=1 numeric fv) [if] [in] [aw],
	numvar(numlist max=1 int)
	pval(numlist max=1 >=0 <=1)
	[R2
	fstat];
	#delimit cr	
set more off
marksample touse

tokenize `varlist'
local depvar `1'
macro shift
local indeps `*'

//Weights
	local wvar : word 2 of `exp'
	if "`wvar'"=="" {
		tempvar w
		gen `w' = 1
		local wvar `w'
	}

local f=1e-6
local r=1e-6
local nvar=0
local thevars 
local final
local allvars

while (`nvar'< `numvar'){
local f=1e-6
local r=1e-6
local thevars 
local final

	foreach x of local indeps{
	local nogo:list allvars & x
		if ("`nogo'"==""){
			qui: reg `depvar' `allvars' `x' [aw=`wvar']
			local fn = e(F)
			local rn = e(r2_a)
			qui: test `x'
			if (`fn'>`f' & `r(p)'<`pval' & `rn'>`r'){
				local thevars: list thevars - final
				local final `x'
				local f = `fn'
				local thevars: list thevars | final			
			}
			else{
				local thevars : list thevars - x
			}
		}	
	}
	
	local allvars `allvars' `thevars' 
	local thevars 
	local nvar: list sizeof allvars
	dis in red "`nvar'"
}

reg `depvar' `allvars' [aw=`wvar']

return local model ="`allvars'"

end
