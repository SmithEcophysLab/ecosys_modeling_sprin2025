# Testing Garry's model

library(tidyverse)

source("garry_module.r")

# run static model
test_1 <- garry_module(par0 = (1000), temp = seq(0, 50, 5), CB6F = (1.2/1e6), RUB = (27.8/1e6))

