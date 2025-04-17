# test_class_model.R
## script to test the class_model.R script

## load libraries
library(R.utils)

## load functions
source('class_model.R')
sourceDirectory('functions')

## run model
class_model()
class_model(gpp_mod = 'garry')

class_model(par0 = seq(0, 2000, 500))
class_model(temperature = seq(5, 45, 5))
class_model(vpd = 5, moisture_loss_rate = seq(0,1,0.1))
