# test_kelley_module.R
## script to test the kell_model.R script 

## load libraries 
library(R.utils)

## load functions
source('kelley_p_uptake&storage.R')
# sourceDirectory('functions') no functions yet

## run model 
kelley_module()

## testing the root length
kelley_module(root_length_average = seq(0, 200, 500))

## testing the pH
kelley_module(soil_ph = seq(1, 14, 1))



