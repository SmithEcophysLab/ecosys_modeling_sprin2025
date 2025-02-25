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


# Homework # 05 : --------------------------------------------------------------
# Create a function for a simple process that you feel might be necessary for
# your module within this R script

## MRK 2024/02/24
## using mostly arbitrary numbers and limited processes

kelley_module <- function (
    # p influence 
    temp_max = 25, # air temperature, influences plant nutrient uptake
    plant_p = 10, # phosphorous amount in plants
    atmo_n = 5, # influences phosphorous uptake and availability to plants
    soil_texture = -5, # soil texture influences phosphorous availability
    precipitation = -10, # general proxy for "weathering" right now
    # p into system
    soil_fertilizer_p = 20, # soil fertilization, agriculture 
    soil_p_start = 20 # initial phosphorous in soil
    ){
  
  # phosphorous in
  p_in <- soil_p_start + soil_fertilizer_p # p into a system
  
  # phosphorous out
  p_influence_neg <- soil_texture + precipitation # neg. influence P in systems
  p_influence_pos <- atmo_n + temp_max # pos. influence P in systems
  p_out <- plant_p * (p_influence_pos + p_influence_neg) # total influences
  
  # total p in system
  total_p <- p_in - p_out # calculate total P

  # output results
  results <- data.frame('temp_max' = temp_max,
                        'plant_p' = plant_p,
                        'atmospheric_n' = atmo_n,
                        'soil_p_start' = soil_p_start,
                        'soil_texture' = soil_texture,
                        'precipitation' = precipitation,
                        'soil_fertilizer_p' = soil_fertilizer_p,
                        'p_in' = p_in,
                        'p_out' = p_out,
                        'total_p_in_system' = total_p)
  results
  
  
}

## testing module ---------------------------------------------------
kelley_module() # 🎇 IT WORKS, real simple but works 🎇

## testing w/ modified temp. 
kelley_module(temp_max = 45)
kelley_module(temp_max = seq(25, 45, 5))

# sources: ---------------------------------------------------------------------

## specific models: CASACNP & CENTURY

## 1
# Wang, Y. P., Law, R. M., & Pak, B. (2010). A global model of carbon, nitrogen
# and phosphorus cycles for the terrestrial biosphere. Biogeosciences, 7(7),
# 2261–2282. https://doi.org/10.5194/bg-7-2261-2010

## 2 
# Radcliffe, D. E., Reid, D. K., Blombäck, K., Bolster, C. H., Collick, A. S.,
# Easton, Z. M., Francesconi, W., Fuka, D. R., Johnsson, H., King, K., Larsbo,
# M., Youssef, M. A., Mulkey, A. S., Nelson, N. O., Persson, K., Ramirez-Avila,
# J. J., Schmieder, F., & Smith, D. R. (2015). Applicability of Models to
# Predict Phosphorus Losses in Drained Fields: A Review. Journal of
# Environmental Quality, 44(2), 614–628. https://doi.org/10.2134/jeq2014.05.0220

## 3
# https://swroc.cfans.umn.edu/research/soil-water/phosphorus-cycle

## 4
# https://www2.cgd.ucar.edu/vemap/abstracts/CENTURY.html 