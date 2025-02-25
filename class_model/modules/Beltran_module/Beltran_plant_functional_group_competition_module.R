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
li_under <- function(i0, lai, k = 0.5) {
  
  # Beer's Law formula
  i = i0 * exp(-k * lai)
  
  return(i)
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






