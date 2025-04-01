################################################################################
## author: monika kelley
## purpose: model module : phosphorus uptake and storage
## date: 2025/02/18
################################################################################

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
#   p_influence_neg <- soil_texture + precipitation # neg. influence P in systems
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

## V2: applied literature --------------------------------------

kelley_module <- function (par0 = 400, # photo. active radiation µmol m-2 s-1
                           temp_max = 25, # max air temp. during biomass 1 & 2
                           temp_min = 5, # min air temp. during biomass 1 & 2
                           tbase = 0, # temp. plants stop growing
                           lai = 3, #leaf area index, range typically 0.5 - 5.0
                           biomass1 = 10, # biomass measured start 1 g/m^2
                           biomass2 = 50, # biomass measured, last g/m^2
                           #doy_start = 80, # doy started growing (Spring), potential time range? 
                           #doy_end = 263, # doy end growing (Fall), potential time range? 
                           plant_p = 10, # phosphorous amount in plants
                           #atmo_n = 5, # atmospheric N
                           soil_texture = -5, # soil texture 
                           soil_p_addition = 20, # P addition to soil (agriculture)
                           soil_p_start = 20 # initial P in soil
                           ){
  
  # conversions
  par <- par0 * 0.0002176 # converts µmol m-2 s-1 to MJm-2 
  
  # sub-module 1) plant demand
  ## MRK 03/28: messy, clean this up by using functions, add LAI + uptake
  biomass_delta = biomass2 - biomass1 # biomass change over time
  RUE = biomass_delta / par # radiation use efficiency
  gdd = ((temp_max + temp_min)/2) - tbase # growing degree days
  hungry_plants = (RUE * par) / gdd # total biomass increment rate

  
  # sub-module 2) phosphorous supply
  ## MRK 03/31: needs work, Pi in soil, and P replenish rates? 
  p_supply = soil_p_start + soil_p_addition - soil_texture

  # sub-module 3) plant phosphorus uptake capability
  ## MRK 03/31: needs work, roots? water? temp? 
  total_p <- p_supply - (plant_p - hungry_plants) # calculate total P
  
  
  # output results
  results <- data.frame('p_uptake_by_plants' = total_p)
  
  results
  
  
}

