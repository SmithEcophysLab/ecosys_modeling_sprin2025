################################################################################
## author: monika kelley
## purpose: model module : phosphorus uptake and storage
## date: 2025/02/18
################################################################################

# description: -----------------------------------------------------------------
## Module to depict phosphorus uptake and storage within a system
## Goal is to try and model how much P is likely stored within pools, e.g., 
## plant biomass (leaf, root, wood), litter, and within soil. How P moves
## moves through a system.


# inputs and outputs: ----------------------------------------------------------
## MRK: likely inputs and outputs

## INPUTS: litterfall, resorption efficiency of P, root length density in soil
## C:P stoichiometry, phosphorous available pools. 

## OUTPUTS: remaining P pools, phosphorous uptake by plants (roots)


## model  ----------------------------------------------------------------------

kelley_module <- function (
    
    # plant inputs
    litterfall = 800,  # yearly litterfall production (kg C ha-1yr-1)
    resorp_efficiency = 0.7, # resorption efficiency, of P (global average ~65%)
    root_length = 0.5, # root length density in soil "chunk" 
    # (cm roots per cm3 of soil(cm/cm3))
    
    # biomass P demand (kg P ha-1yr-1)
    ## demand estimate of total P acquired from soil to maintain biomass 
    ## production yearly
    biomass_canopy = 1000, 
    biomass_wood = 1500,
    biomass_roots = 800, 
    
    # C:P stoichiometry (C to P ratio, unitless!)
    ## higher C:P ratio = more P resorption (needs more P its its life)
    ## lower C:P ratio = less P resorption (doesn't need as much P)
    cp_ratio_canopy = 350,
    cp_ratio_wood = 500, 
    cp_ratio_roots = 400,
    
    # phosphorous available/ the 3 main pools (kg ha-1)
    pool_pi_soluable = 30, # soluble Pi (immediately ready for plants, small #)
    pool_po_soluble = 50, # soluble Po (mineralization required convert to Pi)
    pool_pi_insoluble = 100, # insoluble Pi (very very slowly available)
    
    # soil influences
    ## pH modifies the mobility/ availability of P in soil for plant uptake
    soil_ph = 7
    
    ){
  
  
  # sub-module 1) plant P demand -----------------------------------------------
  
  ## P demand by plant component (kg P ha-1yr-1)
  ### how much P is in the biomass = how much P is needed for biomass
  p_demand_canopy = biomass_canopy / cp_ratio_canopy
  p_demand_wood = biomass_wood / cp_ratio_wood
  p_demand_roots = biomass_roots / cp_ratio_roots
  p_demand_total = p_demand_canopy + p_demand_wood + p_demand_roots
  
  ## P resorption (kg P ha-1yr-1)
  ### How much P is retained in the plant before litter falls, modifies
  ### overall demand of plants. Resorption more = less demand overall. 
  p_resorp_canopy = ((litterfall / cp_ratio_canopy ) * resorp_efficiency)
  p_resorp_wood = ((litterfall / cp_ratio_wood ) * resorp_efficiency)
  p_resorp_roots = ((litterfall / cp_ratio_roots ) * resorp_efficiency)
  p_resorption_total =  p_resorp_canopy + p_resorp_wood + p_resorp_roots

  
  # sub-module 2) plant phosphorus uptake capability ---------------------------
  
  ## beta = P uptake through roots + AMF (Reichert et al., 2023)
  beta = 0.3 
  
  ## root capacity to access P changes w/ root length. Proxy for soil
  ### exploration capacity. Diminishing return based on the root length, 
  ### short = more, long = less. (Reichert et al., 2023)
  access_of_roots= 1 - exp(-beta * root_length)
  
  
  # sub-module 3) phosphorous supply -------------------------------------------
 
  ## pH modifies P pools availability in soil. Low & High pH = less available
  pH_mod <- ifelse(soil_ph >= 6 & soil_ph <= 8, 0.5, 1) 

  ## P uptake from different pools.
  p_pool_total = pool_pi_soluable + pool_po_soluble + pool_pi_insoluble
  p_pool_total = (p_pool_total) * pH_mod # adding pH modification to soils
  
  
  # sub-module 4) calculations -------------------------------------------------
  
  ## How much P plants need (demand) and how much P is accessible to plants
  pool_acess_pi_sol = (pool_pi_soluable * 
                         (p_demand_total / p_pool_total)) * access_of_roots
  pool_acess_po_sol = (pool_po_soluble * 
                         (p_demand_total / p_pool_total)) * access_of_roots
  pool_acess_pi_insol = (pool_pi_insoluble * 
                           (p_demand_total / p_pool_total)) * access_of_roots
  pool_access_total = pool_acess_pi_sol + pool_acess_po_sol + pool_acess_pi_insol
  
  ## final results, p uptake capability of plants
  ## how much the p is available to the plant 
  p_uptake_by_plants = pool_access_total + p_resorption_total
  
  # remaining pool values
  remaining_pool_pi_soluable = pool_pi_soluable - pool_acess_pi_sol
  remaining_pool_po_soluble = pool_po_soluble - pool_acess_po_sol
  remaining_pool_pi_insoluble = pool_pi_insoluble - pool_acess_pi_insol
  remaining_p_pool_total = remaining_pool_pi_soluable + 
    remaining_pool_po_soluble +
    remaining_pool_pi_insoluble
  

  
  # output results -------------------------------------------------------------
  results <- data.frame('p_uptake_by_plants' = p_uptake_by_plants,
                        'p_pool_start_total' = p_pool_total, 
                        'p_pool_remaining_total' = remaining_p_pool_total,
                        'soil_ph' = soil_ph,
                        'ph_mod' = pH_mod,
                        'root_length' = root_length, 
                        'p_demand_canopy' = p_demand_canopy,
                        'p_demand_wood' = p_demand_wood,
                        'p_demand_roots' = p_demand_roots,
                        'p_demand_total' = p_demand_total,
                        'p_resorp_canopy' = p_resorp_canopy,
                        'p_resorp_wood' = p_resorp_wood,
                        'p_resorp_roots' = p_resorp_roots,
                        'p_resorption_total' = p_resorption_total,
                        "access_of_roots(Soil_accessible_p)" = access_of_roots)
  return(results)
}









