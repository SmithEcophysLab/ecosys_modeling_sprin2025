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
                        precipitation = 1500, # precipitation (mm)
                        vpd0 = 1, # vapor pressure deficit at sea level (kPa)
                        ca0 = 400, # atmpsheric CO2 (µmol mol-1)
                        oa0 = 209460, # atmpsheric O2 (µmol mol-1)
                        beta = 240, # cost of nutrients relative to water (Wang et al., 2017)
                        c = 0.41, # cost of jmax (Wang et al., 2017)
                        gpp_mod = 'pmodel',
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
                        moisture_loss_rate = 0.2,
                        lf_tuner = 0.05, # litter fraction tuning constant
                        cp_ratio_leaf = 350,
                        cp_ratio_stem = 500, 
                        cp_ratio_root = 400,
                        soil_ph = 7,
                        pool_pi_soluble = 30, # soluble Pi (immediately ready for plants, small #)
                        pool_po_soluble = 50, # soluble Po (mineralization required convert to Pi)
                        pool_pi_insoluble = 100, # insoluble Pi (very very slowly available)
                        r_poc = 0.4,    # Base POC to DOC rate
                        r_moc = 0.3,    # Base net DOC to MOC rate
                        r_resp = 0.2,    # DOC respiration rate
                        W = 0.25, # soil water content
                        Q10 = 2, 
                        T_ref = 20,
                        W_opt = 0.3,
                        clay = 0.25,     # soil clay fraction
                        k_clay = 0.15,   # clay stabilization coefficient
                        CUE = 0.4,
                        Kf = 0.05e09,       # Rate constant for fluoresence at PSII and PSI, s-1
                        Kd = 0.55e09,       # Rate constant for constitutive heat loss at PSII and PSI, s-1
                        Kp1 = 14.5e09,      # Rate constant for photochemistry at PSI, s-1
                        Kn1 = 14.5e09,      # Rate constant for regulated heat loss at PSI, s-1
                        Kp2 = 4.5e09,       # Rate constant for photochemistry at PSII, s-1
                        kq = 300,           # Cyt b6f kcat for PQH2, mol e-1 mol sites-1 s-1
                        nl = 0.75,          # ATP per e- in linear flow, ATP/e-
                        nc = 1,             # ATP per e- in cyclic flow, ATP/e-
                        kc = 3.6,           # Rubisco kcat for CO2, mol CO2 mol sites-1 s-1
                        ko = 3.6 * 0.27,    # Rubisco kcat for O2, mol O2 mol sites-1 s-1
                        Kc = 260 / 1e6,     # Rubisco Km for CO2, bar
                        Ko = 179000 / 1e6,  # Rubisco Km for O2, bar
                        Abs = 0.85, ### Total leaf absorptance to PAR, mol PPFD absorbed mol-1 PPFD incident
                        beta_garry = 0.52, ### PSII fraction of total leaf absorptance, mol PPFD absorbed by PSII mol-1 PPFD absorbed
                        CB6F = ((350 / 300) / 1e6), ### Cyt b6f density, mol sites m-2
                        RUB = ((100 / 3.6) / 1e6), ### Rubisco density, mol sites m-2
                        Rds = 0.01, ### Scalar for dark respiration, dimensionless
                        Ku2 = 0e09, ### Rate constant for exciton sharing at PSII, s-1
                        theta1 = 1, ### Curvature parameter for Aj/Ac transition, dimensionless
                        eps1 = 0, ### PSI transfer function, mol PSI F to detector mol-1 PSI F emitted
                        eps2 = 1, ### PSII transfer function, mol PSII F to detector mol-1 PSII F emitted
                        alpha_opt = "static" ### option for static or dymanic absorption cross-sections of PSI and PSII
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
  if(gpp_mod == 'pmodel'){
    
  phi0 <- ((a_l * b_l) / 4) * (0.352 + 0.022 * temperature - 0.00034 * (temperature^2))
  ci = chi * ca # intercellular CO2 (Pa)
  m <- (ci - gammastar) / (ci +2*gammastar) # co2 limitation of photosynthesis (unitless)
  m_prime <- sqrt(1-((c/m)^(2/3)))
  gpp <- phi0 * m * m_prime * par * fapar # gross primary productivity (µmol m-2 s-1)
  
  }else if(gpp_mod == 'garry'){
    a2 <- Abs * beta_garry
    a1 <- Abs - a2
    
    Vqmax <- CB6F * kq    # maximum Cyt b6f activity, mol e-1 m-2 s-1
    S <- (kc / Kc) * (Ko / ko)   # Rubisco specificity for CO2/O2, dimensionless
    gammas <- oa / (2 * S)        # CO2 compensation point in the absence of Rd, bar
    eta <- (1 - (nl / nc) + (3 + 7 * gammas / ca) / ((4 + 8 * gammas / ca) * nc))   # PSI/II ETR
    phi1P_max <- Kp1 / (Kp1 + Kd + Kf)        # maximum photochemical yield PSI
    
    JP700_j <- (par * fapar * Vqmax) / (par * fapar + Vqmax / (a1 * phi1P_max)) # rate of electron transport through PSI
    JP680_j <- JP700_j / eta # rate of electron transport through PSII
    Vc_j <- JP680_j / (4 * (1 + 2 * gammas / ca))
    Vo_j <- Vc_j * 2 * gammas / ca
    Ag_j <- Vc_j - Vo_j / 2 # potential rate of net CO2 assimilation under Cyt b6f limitation
    
    gpp <- Ag_j
    
  }else{
    
    return('gpp_error')
    
  }
  
  ## npp
  rplant <- rgpp_ratio * gpp
  npp <- gpp - rplant # net primary productivity (µmol m-2 s-1)
  
  
  
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
  
  ## litter biomass (Puja)
  litter_fraction <- exp(-lf_tuner * (temperature - precipitation / 100)^2) # fraction of npp that becomes litter
  LitterBiomass <- litter_fraction * npp # litter biomass
  
  ## P uptake (Monika)
  ### p demand
  p_demand_leaf = npp_leaf / cp_ratio_leaf
  p_demand_stem = npp_stem / cp_ratio_stem
  p_demand_root = npp_root / cp_ratio_root
  p_demand_total = p_demand_leaf + p_demand_stem + p_demand_root
  
  ### p availability
  pH_mod <- ifelse(soil_ph >= 6 & soil_ph <= 8, 0.5, 1) 
  p_pool_total = pool_pi_soluble + pool_po_soluble + pool_pi_insoluble
  p_pool_total = (p_pool_total) * pH_mod # adding pH modification to soils
  
  ### p uptake
  if(p_demand_total < p_pool_total){
    
    p_uptake <- p_demand_total
    
  }else{
    
    p_uptake <- p_pool_total
    
  }
  
  ## soil C cycling (Pawan)
  # Environmental modifiers
  fT <- Q10 ^ ((temperature - T_ref) / 10)
  fW <- 1 - ((W - W_opt) / W_opt)^2
  fW <- max(fW, 0)
  env_mod <- fT * fW
  
  # calculate microbial carbon modifier from CUE and respiration
  mbc_mod <- (CUE / (1 - CUE)) * r_resp  # derived from microbial C partitioning
  
  # Carbon partitioning
  LC  <- LitterBiomass  # Assumption: Average carbon content in plant litter is 50%
  POC_initial <- LC * 0.40 * env_mod
  DOC_initial <- LC * 0.20 * env_mod
  CO2_initial <- LC * 0.40 * env_mod
  
  # Modify conversion rates by environment
  r_poc_mod <- r_poc * env_mod
  r_moc_mod <- r_moc * env_mod * clay * k_clay
  
  
  # DOC pool includes direct litter + converted POC
  DOC <- DOC_initial + POC_initial * r_poc_mod
  
  # DOC to MOC stabilization
  MOC <- DOC * r_moc_mod
  
  # Microbial uptake and respiration
  DOC_uptake <- DOC * mbc_mod * env_mod
  DOC_respired <- DOC * r_resp * env_mod
  MBC <- DOC_uptake
  
  
  # Final labile DOC available after respiration, recycling, and stabilization
  labile <- DOC - DOC_respired + MBC * (1-r_resp) - MOC
  recalcitrant <- (1 - r_poc_mod) * POC_initial + MOC
  heter_resp <- CO2_initial + DOC_respired
  
  ## nee
  nep <- npp - heter_resp # net ecosystem productivity (µmol m-2 s-1)
  
  # output results
  results <- data.frame('par0' = par0,
                        'fapar' = fapar,
                        'a_l' = a_l,
                        'b_l' = b_l,
                        'z' = z,
                        'temperature' = temperature,
                        "precipitation" = precipitation,
                        'lf_tuner' = lf_tuner,
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
                        #'ci' = ci,
                        #'phi0' = phi0,
                        #'m' = m,
                        #'m_prime' = m,
                        'gpp' = gpp,
                        'rplant' = rplant,
                        'npp' = npp,
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
                        'npp_postfire' = npp_postfire,
                        'litter_fraction' = litter_fraction,
                        'LitterBiomass' = LitterBiomass,
                        'p_demand_leaf' = p_demand_leaf,
                        'p_demand_stem' = p_demand_stem,
                        'p_demand_root' = p_demand_root,
                        'p_demand_total' = p_demand_total,
                        'cp_ratio_leaf' = cp_ratio_leaf,
                        'cp_ratio_stem' = cp_ratio_stem,
                        'cp_ratio_root' = cp_ratio_root,
                        'pH_mod' = pH_mod,
                        'soil_ph' = soil_ph,
                        'pool_pi_soluble' = pool_pi_soluble,
                        'pool_po_soluble' = pool_po_soluble,
                        'pool_pi_insoluble' = pool_pi_insoluble,
                        'p_pool_total' = p_pool_total,
                        'p_uptake' = p_uptake,
                        'W' = W,
                        'LC' = LC,
                        'MBC' = MBC,
                        'heter_resp' = heter_resp,
                        'labile' = labile,
                        'recalcitrant' = recalcitrant,
                        'clay' = clay,
                        'CUE' = CUE
                        )

  results
  
}