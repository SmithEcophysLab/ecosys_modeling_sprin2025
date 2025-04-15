################################################################################
## author: monika kelley
## purpose: model module : phosphorus uptake and storage
## date: 2025/02/18
################################################################################

# notes ------------------------------------------------------------------------
## APPLEPIE = part of model that likely too advanced for class, deals w/ time
## removed APPLEPIE on 04/14/2025 for clarity. 

## next time - remember to keep things lowercase, pain w/ the "H" in "pH"

# description: -----------------------------------------------------------------
## Module to depict phosphorus uptake and storage within a system (too broad?). 
## Goal is to try and model how much P is likely stored within pools, e.g., 
## plant biomass (leaf, root, wood), litter, and within soil. 


# inputs and outputs: ----------------------------------------------------------
## MRK: likely inputs and outputs
## inputs: fertilizer application, dust deposition, and weathering
## likely outputs: pools within in plants, litter, soil, and microbial


## model  ----------------------------------------------------------------------

kelley_module <- function (
    
    # plant inputs (want to add LAI if possible)
    litterfall = 800,  # yearly litterfall production (kgCha-1yr-1)
    RE = 0.7, #resorption efficiency, 70% of P (global average ~65%)
    root_length = 0.5, # root length within a soil cm/cm3
    
    # specific demand, biomass (kgPha-1yr-1)
    ## demand estimate of total P acquired from soil to maintain biomass 
    ## production yearly, P demand = total P take up 
    biomass_canopy = 1000, 
    biomass_wood = 1500,
    biomass_roots = 800, 
    
    # C:P stoichiometry (C to P ratio, unitless!)
    s_canopy = 350,
    s_wood = 500, 
    s_roots = 400,
    
    # phosphorous available/ pools (kg ha-1)
    pool_pi_sol = 30, # soluble Pi
    pool_po = 50, # soluble Po
    pool_pi_insol = 100, # insoluble Pi
    
    # weathering - temp + precip. will affect availability, use pH approach?
    # temp_max = , 
    # temp_min = ,
    # precipitation = ,
    
    # soil influences
    pH_soil = 7
    
    ){
  
  
  # sub-module 1) plant P demand -----------------------------------------------
  
  ## P demand by plant component (kgPha-1yr-1)
  ## Total P = sum of the demand of different components of biomass production 
  ## (canopy, wood, roots) w/ considering stoichiometry values, and subtract
  ## P reabsorbed (maybe just from the canopy?)
  Pdemand_canopy = biomass_canopy / s_canopy
  Pdemand_wood = biomass_wood / s_wood
  Pdemand_roots = biomass_roots / s_roots
  Pdemand_total = Pdemand_canopy + Pdemand_wood + Pdemand_roots
  
  ## P resorption (kgPha-1yr-1)
  Presorption_canopy = ((litterfall / s_canopy ) * RE)
  Presorption_wood = ((litterfall / s_wood ) * RE)
  Presorption_roots = ((litterfall / s_roots ) * RE)
  Presorption_total =  Presorption_canopy + Presorption_wood + Presorption_roots

  
  # sub-module 2) phosphorous supply -------------------------------------------
  ## updated pH modification, allows for "seq" run in testing
  ## pH modified phosphorous P pools availability in soil. Acidic pH (low pH)
  ## tied up w/ iron & aluminum oxides. Alkaline pH (high pH) bind w/ calcium. 
  pH_mod <- ifelse(pH_soil >= 6 & pH_soil <= 8, 0.5, 1) 
  
  ## MRK 04/14/2025 swapped pH values to achieve curve.. but wrong biologically
  ## the pH mod needs to be on the pools, and less available 1 - 6, 8 - 14. 
  
  
  # sub-module 3) plant phosphorus uptake capability ---------------------------
  beta = 0.3 # P uptake through roots + AMF (Reichert et al., 2023)
  
  ## root capacity to access P changes w/ root length. Proxy for soil
  ## exploration capacity (AccessP = accessibility of P)
  AccessP = 1 - exp(-beta * root_length)
  
  ## P uptake from different pools.
  total_Ppools = pool_pi_sol + pool_po + pool_pi_insol
  total_Ppools = (total_Ppools) * pH_mod # adding pH modification to soils
  
  pool_acess_pi_sol = (pool_pi_sol * (Pdemand_total / total_Ppools)) * AccessP
  pool_acess_po_sol = (pool_po * (Pdemand_total / total_Ppools)) * AccessP
  pool_acess_pi_insol = (pool_pi_insol * (Pdemand_total / total_Ppools)) * AccessP
  
  # total pool access availability
  pool_access_total = pool_acess_pi_sol + pool_acess_po_sol + pool_acess_pi_insol
  
  ## final results
  p_uptake_by_plants = pool_access_total + Presorption_total # P uptake plants
  
  # remaining pool values
  remaining_pool_pi_sol = pool_pi_sol - pool_acess_pi_sol
  remaining_pool_po_sol = pool_po - pool_acess_po_sol
  remaining_pool_pi_insol = pool_pi_insol - pool_acess_pi_insol
  

  
  # output results -------------------------------------------------------------
  results <- data.frame('p_uptake_by_plants' = p_uptake_by_plants,
                        'pool_pi_sol' = pool_pi_sol,
                        'pool_pi_sol_after' = remaining_pool_pi_sol,
                        'pool_po_start' = pool_po,
                        'pool_po_after' = remaining_pool_po_sol,
                        'pool_pi_insol_start' = pool_pi_insol,
                        'pool_pi_insol_after' = remaining_pool_pi_insol,
                        'total_p_pools' = total_Ppools,
                        'pool_access_pi_sol' = pool_acess_pi_sol,
                        'pool_access_po_sol' = pool_acess_po_sol,
                        'pool_access_pi_insol' = pool_acess_pi_insol,
                        'pH_soil' = pH_soil,
                        'ph_mod' = pH_mod,
                        'root_length' = root_length, 
                        'Pdemand_canopy' = Pdemand_canopy,
                        'Pdemand_wood' = Pdemand_wood,
                        'Pdemand_roots' = Pdemand_roots,
                        'Pdemand_total' = Pdemand_total,
                        'Presorption_canopy' = Presorption_canopy,
                        'Presorption_wood' = Presorption_wood,
                        'Presorption_roots' = Presorption_roots,
                        'Presorption_total' = Presorption_total,
                        "AccessP(Soil_accessible_p)" = AccessP)
  return(results)
}






