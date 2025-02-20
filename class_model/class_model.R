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
                        cica = 0.7, # ratio of intercellular to atmospheric CO2
                        lai = 1, #leaf area index (m2 m-2)
                        rgpp_ratio = 0.47, # ratio of plant respiration to gpp (Waring)
                        rnpp_ratio = 0.5 # ratio of npp lost from ecosystem respiration
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
  gammastar <- calc_gammastar_pa(temperature, z) # co2 compensation point (Pa)
  ci = cica * ca # intercellular CO2 (Pa)
  m <- (ci - gammastar) / (ci +2*gammastar) # co2 limitation of photosynthesis (unitless)
  aj <- (j/4) * m # gross photosynthesis (µmol m-2 s-1)
  
  ## gpp
  gpp <- aj * lai # gross primary productivity (µmol m-2 s-1)
  
  ## npp
  rplant <- rgpp_ratio*gpp
  npp <- gpp - rplant # net primary productivity (µmol m-2 s-1)
  
  ## nee
  reco <- rnpp_ratio * npp
  nep <- npp - reco # net ecosystem productivity (µmol m-2 s-1)
  
  
  # output results
  results <- data.frame('phi_j' = phi_j,
                        'par0' = par0,
                        'z' = z,
                        'temperature' = temperature,
                        'vpd0' = vpd0,
                        'ca0' = ca0,
                        'oa0' = oa0,
                        'cica' = cica,
                        'rgpp_ratio' = rgpp_ratio,
                        'rnpp_ratio' = rnpp_ratio,
                        'par' = par,
                        'patm' = patm,
                        'vpd' = vpd,
                        'ca' = ca,
                        'oa' = oa,
                        'j' = j,
                        'gammastar' = gammastar,
                        'ci' = ci,
                        'm' = m,
                        'aj' = aj,
                        'gpp' = gpp,
                        'rplant' = rplant,
                        'npp' = npp,
                        'reco' = reco,
                        'rnpp' = rnpp)
  
  results
  
}