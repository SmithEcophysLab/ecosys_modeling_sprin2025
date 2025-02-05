# homework02_script.R
## answer key for homework02
### created by Nick

## load libraries
library(tidyverse)

## load data
hw2_data <- read.csv ('../data/homework02_data.csv')

## create column for vpd in kPa
### calculations from: https://pulsegrow.com/blogs/learn/vpd
hw2_data$svp <- 0.61078 * exp((hw2_data$temp / (hw2_data$temp + 237.3)) * 17.2694)
hw2_data$vpd <- hw2_data$svp * (1 - (hw2_data$rh / 100))

## calculate gep
hw2_data$gep <- hw2_data$nep + hw2_data$reco

## plot gep as a function of temperature
gep_temp_plot <- ggplot(data = hw2_data, aes(x = gep, y = temp)) +
  geom_point(shape = 17, color = 'red') +
  ylab(expression('GEP (gC m'^'-2'*' d'^'-1'*')')) +
  xlab(expression('Temperature (°C)'))

## plot nep as a function of gep
gep_temp_plot <- ggplot(data = hw2_data, aes(y = nep, x = gep)) +
  geom_point(shape = 17, color = 'red') +
  ylab(expression('NEP (gC m'^'-2'*' d'^'-1'*')')) +
  xlab(expression('GEP (gC m'^'-2'*' d'^'-1'*')'))

## calculate nep and gep in µmol m-2 s-1
### estimate conversion factor from gC m-2 d-1 to µmolC m-2 s-1
gd_to_umols_cf <- (1/12.01) * (1e6) * (1/24) * (1/60) * (1/60) # 12 g/mol, 1e6 µmol/mol, 24 h/d, 60 m/h, 60 s/m

hw2_data$nep_umols <- hw2_data$nep * gd_to_umols_cf
hw2_data$gep_umols <- hw2_data$gep * gd_to_umols_cf

## plot nep as a function of gep
gep_temp_plot <- ggplot(data = hw2_data, aes(y = nep_umols, x = gep_umols)) +
  geom_point(shape = 17, color = 'red') +
  ylab(expression('NEP (µmol m'^'-2'*' s'^'-1'*')')) +
  xlab(expression('GEP (µmol m'^'-2'*' s'^'-1'*')'))







