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

litterbio <- function(Tmax = 35, 
                      P = 100,
                      Tavg = 25, 
                      Vforest = 1.5, 
                      a = 0.5, 
                      b = 0.2, 
                      c = 0.3, 
                      d = 10){ 
  L <- ((a*Tmax+b*P)*Vforest+(c*Tavg)+d) #put the constant value of d
  return(L) 
}

