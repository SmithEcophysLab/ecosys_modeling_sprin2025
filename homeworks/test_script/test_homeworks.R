# test_homeworks.R
## script to test module development during homeworks

## load libraries
library(R.utils)

## beltran
Directory('../../class_model/modules/Beltran_module/Beltran_plant_functional_group_competition_module.R')
li_under() # no default for i0 or lai (feb 25)
li_under(i0 = 400, lai = 1) # works

## chatterjee
source('../../class_model/modules/Chatterjee_module/chatterjee_Mycorrhizamodule.R')
mycorrhizal_fungi_module() # works, but output is list

## devkota
source('../../class_model/modules/devkota_module/devkota_soilcarbon.R')
carbon_fraction() # will not run because lB in option list should be "LB"

## garza
source('../../class_model/modules/garza_module/garry_module.R') # cannot even source because function just has options and no calculations

## kelley
source('../../class_model/modules/kelley_module/kelley_p_uptake&storage.R')
kelley_module() # works!

## mahmud
source('../../class_model/modules/module_mahmud/mahmud_FRCC.R') # this contains more than just a function
FR_model() # cannot run with data missing

## roy
source('../../class_model/modules/roy_module/roy_litter_pool.R')
biomass() # works!
