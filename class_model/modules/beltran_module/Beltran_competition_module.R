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

plant_competition <- function (TB = 100, # Total biomass assimilated through photosynthesis
                               C = 0.7, # % of carbon (C) content in TB
                               N = 0.1, # % of nitrogen (N) content in TB
                               P = 0.1, # % of phosphorus (P) content in TB
                               K = 0.1, # % of potassium (K) content in TB
                               rc = 0.3, # % of C transferred to roots 
                               rn = 0.1, # % of N transferred to roots 
                               rp = 0.1, # % of P transferred to roots 
                               rk = 0.1, # % of K transferred to roots 
                               lc = 0.5, # % of C transferred to leaves 
                               ln = 0.2, # % of N transferred to leaves
                               lp = 0.1, # % of P transferred to leaves 
                               lk = 0.1, # % of K transferred to leaves 
                               sc = 0.8, # % of C transferred to stems 
                               sn = 0.1, # % of N transferred to stems 
                               sp = 0.2, # % of P transferred to stems 
                               sk = 0.2, # % of K transferred to stems 
                               Re = 0.3) # % of C lost through respiration
{
  TN <- TB * C * N * P * K # Total nutrient (TN) content in the TB 
  RB <- TN * rc * rn * rp * rk # TN content in the root biomass (RB)
  LB <- TN * lc * ln * lp * lk # TN content in the leaf biomass (LB)
  SB <- TN * sc * sn * sp * sk # TN content in the stem biomass (SB)
  LOC <- TB * C * Re # Total C lost (LOC) through respiration  
  
  result <- data.frame("total_nutrient_content" = TN,
                       "root_nutrient_content" = RB,
                       "leaf_nutrient_content" = LB,
                       "stem_nutrient_content" = SB,
                       "Carbon_released" = LOC)
  return(result)
}
  

  
  
  
  
  
  
  
  
  
  
  
  
  
                               
                               



