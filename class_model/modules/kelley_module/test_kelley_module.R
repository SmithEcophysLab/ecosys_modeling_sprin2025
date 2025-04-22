# test_kelley_module.R
## script to test the kell_model.R script 

## load libraries 
library(R.utils)

## load functions
source('kelley_p_uptake&storage.R')
# sourceDirectory('functions') no functions yet

## run model 
kelley_module()

test_roots <- lapply(seq(0.1, 1, by = 0.1), function(x) 
  kelley_module(root_length_average = x))

test_roots_df <- do.call(rbind, test_roots)
test_roots_df

test_ph <- lapply(seq(1, 14, by = 1), function(x) 
  kelley_module(soil_ph = x))

test_ph_df <- do.call(rbind, test_ph)
test_ph_df
