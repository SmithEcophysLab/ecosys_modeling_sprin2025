# Testing Garry's model

library(tidyverse)

source("garry_module.r")

# run static model
test_1 <- garry_module(par0 =  seq(0, 1500, 100))

# It works!! 
##lets see if I can run the class model.....
