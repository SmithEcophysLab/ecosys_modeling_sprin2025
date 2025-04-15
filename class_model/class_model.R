# class_model.R
## primary script for the model developed for the course
## note that the 'functions' directory may need to be sourced to run all code

class_model <- function(fapar = 0.5, # realized quantum efficiency of electron transport
                        a_l = 0.8, #leaf absorptance
                        b_l = 0.5, #fraction absorbed light that reaches psII
                        #phi0 = 0.05, # quantum yield
                        par0 = 400, # photosynthetically active radiation at sea level (µmol m-2 s-1)
                        z = 0, #elevation (m)
                        temperature = 25, # temperature (°C)
                        vpd0 = 1, # vapor pressure deficit at sea level (kPa)
                        ca0 = 400, # atmpsheric CO2 (µmol mol-1)
                        oa0 = 209460, # atmpsheric O2 (µmol mol-1)
                        beta = 240, # cost of nutrients relative to water (Wang et al., 2017)
                        c = 0.41, # cost of jmax (Wang et al., 2017)
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
  ## ci/ca (i.e., chi) (Wang et al., 2017)
  km <- calc_km_pa(temperature, z) # M-M coefficient for rubisco
  gammastar <- calc_gammastar_pa(temperature, z) # co2 compensation point (Pa)
  nstar <- calc_nstar(temperature, z) # scalar a ccounting for temperature effect on water viscosity
  squiggle <- sqrt(beta*((km + gammastar)/(1.6*nstar)))
  chi <- squiggle / (squiggle + sqrt(vpd*1000)) # ratio of inter to intra cellular co2
  
  ## gpp
  phi0 <- ((a_l * b_l) / 4) * (0.352 + 0.022 * temperature - 0.00034 * (temperature^2))
  ci = chi * ca # intercellular CO2 (Pa)
  m <- (ci - gammastar) / (ci +2*gammastar) # co2 limitation of photosynthesis (unitless)
  m_prime <- sqrt(1-((c/m)^(2/3)))
  gpp <- phi0 * m * m_prime * par * fapar # gross primary productivity (µmol m-2 s-1)
  
  ## npp
  rplant <- rgpp_ratio * gpp
  npp <- gpp - rplant # net primary productivity (µmol m-2 s-1)
  
  ## nee
  reco <- rnpp_ratio * npp
  nep <- npp - reco # net ecosystem productivity (gC m-2 d-1)
  
  
  # output results
  results <- data.frame('par0' = par0,
                        'fapar' = fapar,
                        'a_l' = a_l,
                        'b_l' = b_l,
                        'z' = z,
                        'temperature' = temperature,
                        'vpd0' = vpd0,
                        'ca0' = ca0,
                        'oa0' = oa0,
                        'beta' = beta,
                        'rgpp_ratio' = rgpp_ratio,
                        'rnpp_ratio' = rnpp_ratio,
                        'par' = par,
                        'patm' = patm,
                        'vpd' = vpd,
                        'ca' = ca,
                        'oa' = oa,
                        'gammastar' = gammastar,
                        'km' = km,
                        'nstar' = nstar,
                        'squiggle' = squiggle,
                        'chi' = chi,
                        'ci' = ci,
                        'phi0' = phi0,
                        'm' = m,
                        'm_prime' = m,
                        'gpp' = gpp,
                        'rplant' = rplant,
                        'npp' = npp,
                        'reco' = reco)

  results
  
}