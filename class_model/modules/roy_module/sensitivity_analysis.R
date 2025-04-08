###################
#Changes in litter pool after drought
#Author: Puja Roy
###################

# I want to look at how the litter pool changes after drought in a particular
# terrestrial ecosystem
# Here, 
# L= Litterfall biomass (g/m²)
# Tmax = Maximum temperature (°C)
# P = Precipitation (mm)
# Vforest = Forest type factor 
# Tavg = average temperature (°C)
# a, b, c, and d are empirically derived constants and their units are g/m²/°C,
# g/m²/mm, g/m²/°C, g/m² respectively 
# a = adjustment for maximum temperature, refers to how much litter biomass  
# changes for every degree changes in maximum temperature
# b = adjustment for precipitation, means how much  litter biomass changes 
# for every unit changes in precipitation
# c = adjustment for average temperature, refers to the changes in litter biomass  
# for every degree changes in average temperature
# d is the baseline constant which represents the amount of leaf litter biomass 
# expected even if temperature and precipitation were zero

## sensitivity analysis by changing the temperature 

litterbio <- function(Tmax = 35, 
                      Tavg = seq(20, 35, 0.05),
                      P = 100,
                      Vforest = 1.5, 
                      a = 0.5, 
                      b = 0.2, 
                      c = 0.3, 
                      d = 10){ 
  L <- ((a*Tmax+b*P)*Vforest+(c*Tavg)+d) #put the constant value of d
  return(L) 
}

litterbio()
litter_data1 <- data.frame(Temperature = seq(20, 35, 0.05), 
                          Litter = litterbio())
litter_data1
library(ggplot2)
p <- aes(x = Temperature, y = Litter)
ggplot(litter_data1, p)+geom_point(color = "red")+ 
  xlab("Temperature (°C)") + 
  ylab("Litter (grams)") +
  ggtitle("Changes in Litter Biomass with Temperature")

## sensitivity analysis by changing the precipitation 

litterbio <- function(Tmax = 35, 
                      Tavg = 25, 
                      P = seq(60, 100, 0.05),
                      Vforest = 1.5, 
                      a = 0.5, 
                      b = 0.2, 
                      c = 0.3, 
                      d = 10){ 
  L <- ((a*Tmax+b*P)*Vforest+(c*Tavg)+d) #put the constant value of d
  return(L) 
}

litterbio()
litter_data2 <- data.frame(Precipitation = seq(60, 100, 0.05), 
                           Litter = litterbio())
litter_data2
library(ggplot2)
p <- aes(x = Precipitation, y = Litter)
ggplot(litter_data2, p)+geom_point(color = "blue")+ 
  xlab("Precipitation (mm)") + 
  ylab("Litter (grams)") +
  ggtitle("Changes in Litter Biomass with Precipitation")
