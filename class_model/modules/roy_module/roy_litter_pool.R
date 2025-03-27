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

litterbio <- function(Tmax = 35, 
                      P = 100,
                      Tavg = 25, 
                      Vforest = 1.5, 
                      a = 0.5, 
                      b = 0.2, 
                      c = 0.3, 
                      d = 10){
  L <- ((a*Tmax+b*P)*Vforest+(c*Tavg)+d)
  return(L)
}

#example
litterbio()
# [1] 73.75