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
                        rnpp_ratio = 0.5, # ratio of npp lost from ecosystem respiration
                        Cplant = 0.5 , # whole plant carbon
                        Nplant = 0.6 , # whole plant nitrogen 
                        Croot = 0.3 , # total carbon in root biomass
                        Nsoil=  0.9, # available soil nitrogen
                        Camf= 0.2,   # total carbon directed in AMF biomass
                        Cacq = 0.3, # carbon available to spend on nitrogen acquisition
                        kN = 1, # parameter that controls the cost as a function of soil N
                        kC= 1,
                        env_type = "moderate", # "dry", "moderate", "wet"
                        light_lvl = "medium", # "low", "medium", "high"
                        moisture_loss_rate = 0.2
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
  
  ## n uptake (snehanjana)
  # Plant Nitrogen demand 
  Ndemand <-  npp/(Cplant/Nplant)
  
  # Carbon cost to acquire nutrients from roots
  COSTact <- (kN/Nsoil) * (kC/Croot)
  
  # Plant Nitrogen uptake through roots
  Nuptake <- Cacq/COSTact
  
  # Carbon cost to acquire nutrients from AMF
  COSTamf <- (kN/Nsoil)*(kC/Camf)
  
  # Plant Nitrogen uptake through AMF
  Nuptakeamf <- Cacq/COSTamf
  
  # Total N uptake
  TotalN <- COSTact + COSTamf
  
  ## npp allocation (Isa)
  w_params <- switch(env_type,
                     dry = list(rc = 0.6, rn = 0.2, rp = 0.1, rk = 0.7,
                                lc = 0.2, ln = 0.5, lp = 0.2, lk = 0.1,
                                sc = 0.2, sn = 0.3, sp = 0.7, sk = 0.2,
                                Re = 0.4),
                     moderate = list(rc = 0.3, rn = 0.3, rp = 0.2, rk = 0.2,
                                     lc = 0.5, ln = 0.5, lp = 0.3, lk = 0.3,
                                     sc = 0.2, sn = 0.2, sp = 0.5, sk = 0.5,
                                     Re = 0.3),
                     wet = list(rc = 0.1, rn = 0.1, rp = 0.1, rk = 0.1,
                                lc = 0.6, ln = 0.7, lp = 0.2, lk = 0.1,
                                sc = 0.3, sn = 0.2, sp = 0.7, sk = 0.1,
                                Re = 0.2)
  )
  
  # Light competition
  l_params <- switch(light_lvl,
                     low = list(lc = 1.3, sc = 1.5, rc = 0.7),
                     medium = list(lc = 1.0, sc = 1.0, rc = 1.0),
                     high = list(lc = 0.8, sc = 0.7, rc = 1.2)
  )
  
  # C adjustments to organs after light competition
  rc <- w_params$rc * l_params$rc
  lc <- w_params$lc * l_params$lc
  sc <- w_params$sc * l_params$sc
  
  npp_root <- rc * npp
  npp_stem <- sc * npp
  npp_leaf <- lc * npp
  
  ## fire probability (azaj)
  vpd_normalized <- vpd / 5 # normalized the vpd
  ignition_probability <- moisture_loss_rate * vpd_normalized
  fire_occurs <- rbinom(1, 1, ignition_probability) # weighted probability of fire occurence
  if (fire_occurs == 1) {
    biomass_loss <- (1 - moisture_loss_rate) 
    npp_postfire <- npp * (1 - biomass_loss)
  }else{
    biomass_loss <- 0
    npp_postfire <- npp
    }
  
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
                        'reco' = reco,
                        "Cplant" = Cplant,
                        "Nplant" = Nplant,
                        "Croot" = Croot,
                        "Nsoil" = Nsoil,
                        "Camf" = Camf,
                        "Cacq"= Cacq,
                        "kN"= kN,
                        "kC"= kC,
                        "Ndemand"= Ndemand,
                        "COSTact" = COSTact, 
                        "Nuptake" = Nuptake, 
                        "COSTamf" = COSTamf, 
                        "Nuptakeamf" = Nuptakeamf, 
                        "TotalN" = TotalN,
                        'environment' = env_type,
                        'light' = light_lvl,
                        'rc' = rc,
                        'sc' = sc,
                        'lc' = lc,
                        'npp_root' = npp_root,
                        'npp_stem' = npp_stem,
                        'npp_leaf' = npp_leaf,
                        'vpd_normalized' = vpd_normalized,
                        'moisture_loss_rate'= moisture_loss_rate,
                        'ignition_probability' = ignition_probability,
                        'fire_occurs' = fire_occurs,
                        'biomass_loss' = biomass_loss,
                        'npp_postfire' = npp_postfire
                        )

  results
  
}