# test_kelley_module.R
## script to test the kell_model.R script 

## load libraries 
library(R.utils)

## load functions
source('kelley_p_uptake&storage.R')
sourceDirectory('functions')

## run model 
kelley_module()

kelley_module(45)
kelley_module(temp_max = seq(25, 45, 5))
