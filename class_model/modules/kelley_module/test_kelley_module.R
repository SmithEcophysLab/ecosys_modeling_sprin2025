# test_kelley_module.R
## script to test the kell_model.R script 

## load libraries 
library(R.utils)

## load functions
source('kelley_p_uptake&storage.R')
# sourceDirectory('functions') mrk add later when move functions over

## run model 
kelley_module()

kelley_module(root_length = seq(0.1, 1, by = 0.1))
kelley_module(pH_soil = seq(1, 14, by = 0.5))
