# test_class_model.R
## script to test the class_model.R script

## load libraries
library(R.utils)

## load functions
source('class_model.R')
sourceDirectory('functions')

## run model
class_model()

class_model(par0 = seq(0, 2000, 500))
