################################################################################
## author: monika kelley
## purpose: model module : phosphorus uptake and storage
## date: 2025/02/18
################################################################################

# notes ------------------------------------------------------------------------
## APPLEPIE = part of modle that likely too advanced for class, deals w/ time

# description: -----------------------------------------------------------------
## Module to depict phosphorus uptake and storage within a system (too broad?). 
## Goal is to try and model how much P is likely stored within pools, e.g., 
## plant biomass (leaf, root, wood), litter, and within soil. 


# inputs and outputs: ----------------------------------------------------------
## MRK: likely inputs and outputs
## inputs: fertilizer application, dust deposition, and weathering
## likely outputs: pools within in plants, litter, soil, and microbial



## V1: rough concept 2024/02/25 --------------------------------------

# kelley_module_concept <- function (
#     # p influence 
#     temp_max = 25, # air temperature, influences plant nutrient uptake
#     plant_p = 10, # phosphorous amount in plants
#     atmo_n = 5, # influences phosphorous uptake and availability to plants
#     soil_texture = -5, # soil texture influences phosphorous availability
#     precipitation = -10, # general proxy for "weathering" right now
#     # p into system
#     soil_fertilizer_p = 20, # soil fertilization, agriculture 
#     soil_p_start = 20 # initial phosphorous in soil
#     ){
#   
#   # phosphorous in
#   p_in <- soil_p_start + soil_fertilizer_p # p into a system
#   
#   # phosphorous out
#   p_influence_neg <- soil_texture + precipitation # neg. influence P in
#   p_influence_pos <- atmo_n + temp_max # pos. influence P in systems
#   p_out <- plant_p * (p_influence_pos + p_influence_neg) # total influences
#   
#   # total p in system
#   total_p <- p_in - p_out # calculate total P
# 
#   # output results
#   results <- data.frame('temp_max' = temp_max,
#                         'plant_p' = plant_p,
#                         'atmospheric_n' = atmo_n,
#                         'soil_p_start' = soil_p_start,
#                         'soil_texture' = soil_texture,
#                         'precipitation' = precipitation,
#                         'soil_fertilizer_p' = soil_fertilizer_p,
#                         'p_in' = p_in,
#                         'p_out' = p_out,
#                         'total_p_in_system' = total_p)
#   results
#   
#   
# }

## V2: applied literature ------------------------------------------------------

kelley_module <- function (
   
  ## parameters for "APPLEPIE" section
   # par0 = 400, # photo. active radiation µmol m-2 s-1
    # temp_max = 25, # max air temp. during biomass 1 & 2
    # temp_min = 5, # min air temp. during biomass 1 & 2
    # tbase = 0, # temp. plants stop growing for region
    # biomass_delta = 10, # biomass change over time g/m^2
    
    # plant inputs (want to add LAI if possible)
    litterfall = 800,  # yearly litterfall production (kgCha-1yr-1)
    RE = 0.7, #resorption efficiency, 70% of P (global average ~65%)
    root_length = 0.5, # root length within a soil cm/cm3
    
    # specific demand, biomass (kgPha-1yr-1)
    biomass_canopy = 1000, 
    biomass_wood = 1500,
    biomass_roots = 800, 
    
    # C:P stoichiometry (C to P ratio)
    s_canopy = 350,
    s_wood = 500,
    s_roots = 400,
    
    # phosphorous available/ pools (kg ha-1)
    pool_pi_sol = 3.0, # soluble Pi
    pool_po = 3.0, # soluble Po
    pool_pi_insol = 100, # insoluble Pi
    
    # weathering - temp + precip will affect availability, use pH approach?
    # temp_max = , 
    # temp_min = ,
    # precipitation = ,
    
    # soil influences
    pH_soil = 7
    
    ){
  
  # conversions ---------
  # par <- par0 * 0.0002176 # converts µmol m-2 s-1 to MJm-2 # APPLEPIE
  
  
  # sub-module 1) plant P demand ---------
  ## APPLEPIE
  ## mrk: depends on difference in time, likely not within scope of class.
  # RUE = biomass_delta / par # radiation use efficiency
  # gdd = ((temp_max + temp_min) / 2) - tbase # growing degree days
  # GWnew = (RUE * par) / gdd # total biomass increment rate(gbiomassm-2(Cd°)-1)
  
  ## P demand by plant component (kgPha-1yr-1) 
  Pdemand_canopy = biomass_canopy / s_canopy
  Pdemand_wood = biomass_wood / s_wood
  Pdemand_roots = biomass_roots / s_roots
  Pdemand_total = Pdemand_canopy + Pdemand_wood + Pdemand_roots
  
  ## P resorption (kgPha-1yr-1)
  Presorption_canopy = ((litterfall / s_canopy ) * RE)
  Presorption_wood = ((litterfall / s_wood ) * RE)
  Presorption_roots = ((litterfall / s_roots ) * RE)
  Presorption_total =  Presorption_canopy + Presorption_wood +  Presorption_roots

  
  # sub-module 2) phosphorous supply ---------
  ## adjusting P availability based on pH
  # pH_mod = if (pH_soil >= 6 & pH_soil <= 7) { 1 # neutral pH, P fully available 
  # } else { if (pH_soil < 6) { 0.5 # acidic pH, P reduce availability
  #   } else { 0.5 # alkaline soils, P reduce availability
  #   }
  # }

  ## updated pH modification, allows for "seq" run in testing (internet thanks!)
  pH_mod <- ifelse(pH_soil >= 6 & pH_soil <= 7, 1, 0.5) 
  
  
  ## applying pH modifications
  pool_pi_sol_pH = pool_pi_sol * pH_mod
  pool_po_sol_pH = pool_po * pH_mod
  pool_pi_insol_pH = pool_pi_insol * pH_mod
  
  # sub-module 3) plant phosphorus uptake capability ---------
  β = 0.3 # P uptake through roots + AMF (Reichert et al., 2023)
  ## root capacity to access P changes w/ length
  AccessP = 1 - exp(-β * root_length)
  
  ## P uptake from different pools.
  total_Ppools = pool_pi_sol_pH + pool_po_sol_pH + pool_pi_insol_pH
  
  pool_acess_pi_sol = (pool_pi_sol_pH * (Pdemand_total / total_Ppools)) * AccessP
  pool_acess_po_sol = (pool_po_sol_pH * (Pdemand_total / total_Ppools)) * AccessP
  pool_acess_pi_insol = (pool_pi_insol_pH * (Pdemand_total / total_Ppools)) * AccessP
  
  pool_access_total = pool_acess_pi_sol + pool_acess_po_sol + pool_acess_pi_insol
  

  ## final results
  p_uptake_by_plants = pool_access_total + Presorption_total # P uptake plants
  
  # remaining pool values
  remaining_pool_pi_sol = pool_pi_sol_pH - pool_acess_pi_sol
  remaining_pool_po_sol = pool_po_sol_pH - pool_acess_po_sol
  remaining_pool_pi_insol = pool_pi_insol_pH - pool_acess_pi_insol
  

  
  # output results
  results <- data.frame('p_uptake_by_plants' = p_uptake_by_plants,
                        'remaining_pool_pi_sol' = remaining_pool_pi_sol,
                        'remaining_pool_po_sol' = remaining_pool_po_sol,
                        'remaining_pool_pi_insol' = remaining_pool_pi_insol,
                        'pH_soil' = pH_soil,
                        'root_length' = root_length)
  return(results)
}






