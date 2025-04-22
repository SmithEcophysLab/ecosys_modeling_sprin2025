###############################################################################
# Title: Plant Functional Group (PFG) Competition and Carbon Transfer Module
# Author: Isabella Beltran
# Date: 02/17/2025
# Updated: 02/24/2025
###############################################################################
# Description: 
# This module is designed to simulate how different plant functional groups (PFGs) compete for light, nutrients, and water, and how this competition influences carbon allocation into various ecosystem carbon pools. The PFGs represent plants with distinct resource-use strategies, affecting how much carbon is stored in biomass, soil, microbial biomass, or lost through respiration. The module focuses on understanding the dynamics of resource competition and its impact on carbon cycling in ecosystems. Competition influences species dominance, succession, and ecosystem function.

# Plant functional groups: <open for suggestions>
# - Fast-growing species
#   - Annuals (e.g., grasses, pioneer species)
# - Slow-growing species
#   - Perennials (e.g., shrubs, trees)

# Purpose:
# This module estimates carbon flux and carbon pool dynamics based on plant community composition, resource competition (light, nutrients, water), and environmental conditions such as soil moisture and temperature. It integrates inputs from other modules developed for this class, where applicable.

# Inputs:
# - Vegetation cover: Proportion of ground covered by vegetation (0-100%)
# - Soil moisture: Given in %
# - Temperature: Given in °C
# - Light availability: Incident light at the top of the canopy (µmol/m²/s)
# - Nutrient availability: Soil nitrogen and phosphorus levels (g/m²)
# - Water availability: Soil water content (%)

# Outputs:
# - Carbon flux: Estimated carbon flux between pools (gC/m²/day)
# - Carbon pools: Estimated carbon stored in biomass, soil, and microbial pools (gC/m²)
# - Resource competition: Light, nutrient, and water uptake by each PFG

# Reasoning behind
# Light competition: Taller plants shade smaller ones. This directly influences the carbon fixation (photosynthesis) of different plant functional groups. 
 
# Nutrient competition: Plants compete for soil nutrients (e.g., nitrogen, phosphorus), which are essential for growth and metabolism. This affects their biomass production and carbon allocation to roots, stems, and leaves.

# Water competition: Plants compete for soil water, which is critical for photosynthesis, nutrient transport, and cooling. Water availability influences stomatal conductance and photosynthetic rates, directly affecting carbon uptake and allocation.

# Based on: References to be added...

############################################################################### LIGHT COMPETITION
############################################################################### 
# Function to calculate light intensity at the bottom of the canopy
li_under <- function(i0 = 1000,  # Incident light at the top of the canopy (µmol/m²/s)
                     lai_sunlight = 1,  # LAI of sunlit leaves (m²/m²)
                     lai_shaded = 1,  # LAI of shaded leaves (m²/m²)
                     k = 0.5          # Light extinction coefficient (dimensionless)
) {
  
  # Light intensity for sunlit and shaded leaves
  i_sunlight = i0 * (1 - exp(-k * lai_sunlight))
  i_shaded = i0 * exp(-k * lai_sunlight) * (1 - exp(-k * lai_shaded))
  
  # Total light intensity at the bottom of the canopy
  i_total = i_sunlight + i_shaded
  
  # Output results
  results <- data.frame(
    i_sunlight = i_sunlight,
    i_shaded = i_shaded,
    i_total = i_total
  )
  
  return(results)
}

# Formula's considerations
# i0 = original incoming light intensity (µmol/m²/s)
# k = 0.5 extinction coefficient constant default, usually for grass formations
#     0.7 for herb and shrub formation 
# lai = leaf area index (m²/m²)
# 
# Based on: Monsi, M., & Saeki, T. (2005). On the factor light in plant communities and its importance for matter production. Annals of botany, 95(3), 549-567.
# Note: This formula is used in models like LPJ-DGVM and ED2
###############################################################################

plant_competition <- function(TB = 100, # Total biomass (g)
                              C = 0.7, 
                              N = 0.1, 
                              P = 0.1, 
                              K = 0.1,  # % C, N, P, K in biomass
                              moisture = 0.50,
                              light = 2000
) {
  # Soil moisture categories
  env_type <- ifelse(moisture <= 0.30, "dry",
              ifelse(moisture <= 0.70, "moderate", "wet"))
  
  # Light levels categories
  light_lvl <- ifelse(light <= 200, "low",
           ifelse(light <= 600, "medium", "high"))
  
  # Nutrient level classification
  n_level <- ifelse(N <= 0.03, "low",
                    ifelse(N <= 0.07, "moderate", "high"))
  p_level <- ifelse(P <= 0.03, "low",
                    ifelse(P <= 0.07, "moderate", "high"))
  k_level <- ifelse(K <= 0.03, "low",
                    ifelse(K <= 0.07, "moderate", "high"))
  
                     
  # Water competition
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
                                lc = 0.6, ln = 0.7, lp = 0.2, lk = 0.2,
                                sc = 0.3, sn = 0.2, sp = 0.7, sk = 0.7,
                                Re = 0.2))
  
  # Light competition
  l_params <- switch(light_lvl,
                     low = list(lc = 1.3, sc = 1.5, rc = 0.7),
                     medium = list(lc = 1.0, sc = 1.0, rc = 1.0),
                     high = list(lc = 0.8, sc = 0.7, rc = 1.2))
  
  # Nutrient-based carbon allocation modifiers
  n_params <- switch(n_level,
                     low = list(rc = 1.2, lc = 0.9, sc = 0.9),
                     moderate = list(rc = 1.0, lc = 1.0, sc = 1.0),
                     high = list(rc = 0.8, lc = 1.1, sc = 1.1))
                     
  p_params <- switch(p_level,
                     low = list(rc = 1.2, lc = 0.9, sc = 0.9),
                     moderate = list(rc = 1.0, lc = 1.0, sc = 1.0),
                     high = list(rc = 0.8, lc = 1.1, sc = 1.1))
                     
  k_params <- switch(k_level,
                     low = list(rc = 1.2, lc = 0.9, sc = 0.9),
                     moderate = list(rc = 1.0, lc = 1.0, sc = 1.0),
                     high = list(rc = 0.8, lc = 1.1, sc = 1.1))
                     
  
  # C adjustments to organs after light competition
  w_params$rc <- w_params$rc * l_params$rc
  w_params$lc <- w_params$lc * l_params$lc
  w_params$sc <- w_params$sc * l_params$sc
  
  # Nutrient-based adjustments to carbon allocation
  nutrient_rc <- mean(c(n_params$rc, p_params$rc, k_params$rc))
  nutrient_lc <- mean(c(n_params$lc, p_params$lc, k_params$lc))
  nutrient_sc <- mean(c(n_params$sc, p_params$sc, k_params$sc))
  
  w_params$rc <- w_params$rc * nutrient_rc
  w_params$lc <- w_params$lc * nutrient_lc
  w_params$sc <- w_params$sc * nutrient_sc
  
  # Calculate total remain C based on the input of biomass 
  total_C <- TB * C                 # C assimilated from photosynthesis
  lost_C <- total_C * w_params$Re   # Carbon lost to respiration
  remaining_C <- total_C - lost_C   # Carbon available for growth
  
  # Calculate the adjust C after light and nutrient interaction levels
  TC <- w_params$rc + w_params$lc + w_params$sc
  RC <- remaining_C * (w_params$rc / TC)
  LC <- remaining_C * (w_params$lc / TC)
  SC <- remaining_C * (w_params$sc / TC)
  
  # Calculate nutrient content in organs based on both water and light competition
  RB <- RC * w_params$rn * w_params$rp * w_params$rk  # Root nutrients
  LB <- LC * w_params$ln * w_params$lp * w_params$lk  # Leaf nutrients
  SB <- SC * w_params$sn * w_params$sp * w_params$sk  # Stem nutrients
  
  # Total nutrient content (sum of all organs)
  TN <- RB + LB + SB
  
  # Return results
  data.frame(
    environment = env_type,
    light = light_lvl,
    total_nutrient_content = TN,
    root_nutrient_content = RB,
    leaf_nutrient_content = LB,
    stem_nutrient_content = SB,
    C_released = lost_C,
    C_allocated_to_roots = RC,
    C_allocated_to_leaves = LC,
    C_allocated_to_stems = SC,
    total_C_allocated = RC + LC + SC  # Should equal remaining_C
  )
}
  
  
  
