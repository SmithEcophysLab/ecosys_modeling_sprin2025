# class_model.R
## primary script for the model developed for the course
## note that the 'functions' directory may need to be sourced to run all code

class_model <- function(fapar = 0.25, # realized quantum efficiency of electron transport
                        phi0 = 0.05, # quantum yield
                        par0 = 400, # photosynthetically active radiation at sea level (µmol m-2 s-1)
                        z = 0, #elevation (m)
                        temperature = 25, # temperature (°C)
                        vpd0 = 1, # vapor pressure deficit at sea level (kPa)
                        ca0 = 400, # atmpsheric CO2 (µmol mol-1)
                        oa0 = 209460, # atmpsheric O2 (µmol mol-1)
                        cica = 0.7, # ratio of intercellular to atmospheric CO2
                        c = 0.41,
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
  ## canopy photosynthesis (stocker et al., 2020)
  iabs <- fapar * par
  gammastar <- calc_gammastar_pa(temperature, z) # co2 compensation point (Pa)
  ci = cica * ca # intercellular CO2 (Pa)
  m <- (ci - gammastar) / (ci +2*gammastar) # co2 limitation of photosynthesis (unitless)
  mprime <- m * sqrt(1 - (c/m)^(2/3))
  lue = phi0 * mprime
  gpp <- lue * iabs * (12/1000) *60 * 60 * 24 # gross primary productivity (g C m-2 d-1)
  
  ## npp
  rplant <- rgpp_ratio*gpp
  npp <- gpp - rplant # net primary productivity (gC m-2 d-1)
  
  ## nee
  reco <- rnpp_ratio * npp
  nep <- npp - reco # net ecosystem productivity (gC m-2 d-1)
  
  
  # output results
  results <- data.frame('par0' = par0,
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
                        'gammastar' = gammastar,
                        'ci' = ci,
                        'm' = m,
                        'gpp' = gpp,
                        'rplant' = rplant,
                        'npp' = npp,
                        'reco' = reco,
                        'rgpp_ratio' = rgpp_ratio)
  
  results
  
}