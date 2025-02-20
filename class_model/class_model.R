# class_model.R
## primary script for the model developed for the course
## note that the 'functions' directory may need to be sourced to run all code

class_model <- function(phi_j = 0.25, # realized quantum efficiency of electron transport
                        par0 = 400, # photosynthetically active radiation at sea level (µmol m-2 s-1)
                        z = 0, #elevation (m)
                        temperature = 25, # temperature (°C)
                        vpd0 = 1, # vapor pressure deficit at sea level (kPa)
                        ca0 = 400, # atmpsheric CO2 (µmol mol-1)
                        oa0 = 209460, # atmpsheric O2 (µmol mol-1)
                        cica = 0.7 # ratio of intercellular to atmospheric CO2
                        ){
  
  # conversions
  par <- calc_par(par0, z)
  patm <- calc_patm(z)
  vpd <- calc_vpd(temperature, z, vpd0)
  ca <- ca0 * 1e-6 * patm
  oa <- oa0 * 1e-6 * patm
  
  # carbon in
  ## leaf photosynthesis
  j <- phi_j * par # electron transport rate (µmol m-2 s-1)
  gammastar <- calc_gammastar_pa(temperature, z)
  ci = cica * ca
  m <- (ci - gammastar) / (ci +2*gammastar)
  aj <- (j/4) * m
  
}