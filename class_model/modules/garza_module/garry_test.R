# Testing Garry's model

library(tidyverse)

source("garry_module.r")

# run static model
test_1 <- garry_module(par0 =  seq(0, 1500, 100))

test_2 <- garry_module(par0 =  seq(0, 1500, 100), CO2 = 800)

test_3 <- garry_module(par0 =  seq(0, 1500, 100), temp = 35)

### trying sensitivity test

sensitivity_df <- data.frame(
    par0 =  seq(0, 1500, 100),
    output = c(test_1, test_3))



