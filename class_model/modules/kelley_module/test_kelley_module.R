# test_kelley_module.R
## script to test the kell_model.R script 

## load libraries 
library(R.utils)

## load functions
source('kelley_p_uptake&storage.R')
# sourceDirectory('functions') no functions yet

## run model 
kelley_module()

kelley_module(root_length = seq(0.1, 1, by = 0.1))
kelley_module(soil_ph = seq(1, 14, by = 0.5))



testing_ph <- kelley_module(soil_ph = seq(1, 14, by = 0.5))
