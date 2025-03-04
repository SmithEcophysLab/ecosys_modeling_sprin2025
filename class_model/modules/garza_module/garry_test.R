# Testing Garry's model

library(tidyverse)

source("garry_module.r")

# run static model
garry_module(PAR = temp(0, 50, 5), CB6F = (1.2/1e6), RUB = (27.8/1e6))

