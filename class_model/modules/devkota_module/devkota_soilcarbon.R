# Title: soil carbon module for carbon cycle
# Author: Pawan Devkota

# This module incorporate different fractions of soil carbon, processes associated
# with carbon input, and conversion between fractions, and major fluxes of carbon 
# from the soil to carbon cycle model. Soil carbon will be divided into labile or
# unprotected fractions and recalcitrant or protected fraction. The  labile 
# fraction include the carbon from microbes (microbial biomass carbon), and easily 
# decomposible plant residues (low C:N ratio). The recalcitrant fraction includes
# carbon derived from residues with high C:N ratio, also carbon protected within
# the clay complex are included under recalcitrant fraction (higher clay % in the
# soil indicates greater protection from microbial decomposition). Decomposition 
# is driven by soil microbes, and soil aggregation plays an important role in
# protecting labile carbon from microbial access. Fungi have ability to decompose 
# high C:N residues. Therefore, high fungi/bacteria ratio may promote decomposition
# of stable carbon from soil. Decomposition of both labile and recalcitrant carbon
# releases C to atmosphere as CO2.
#  
# In managed ecosystem (e.g., agricultural soil), cultivation practice like 
# tillage break down the soil aggregates, thereby accelerating soil carbon loss 
# due to exposure of protected C to microbial decomposition. Therefore, crop 
# management practices such as no-till, residue retention,crop rotation, and 
# cover cropping can help to stabilize the soil aggregates as well as provide 
# additional carbon input. Crop rotation, and cover crops also increase 
# below ground diversity which can change carbon turnover rate from the soil.
# i also intend to include those management strategies in my soil carbon module.

# Possible Inputs needed for the model:
# litter biomass
# C:N ratio of litter
# microbial biomass carbon
# abundances of fungi and bacteria
# clay %
# tillage (binary variable)
# crop rotation (binary variable)
# cover crop (binary variable)


# Output
# proportion of labile and recalcitrant fraction of soil C
# C release through decomposition
# simulate whether soil acts as carbon sink or source


#############################################################

# The function takes litter biomass, percentage of carbon in litter, 
# proportion of carbon that goes to particulte organic carbon (POC),
# proportion of C assimilated by microbes, and proportion of easily decomposable
# POC as inputs. The calculates the labile and recalitrant carbon fraction based
# the input provided and results the data frame with total litter carbon, labile
# carbon and recalcitrant carbon sequestered in the soil.
#

carbon_fraction <- function(LB = 1000,  # Litter biomass
                                c = 0.4,    # Base POC to DOC rate
                                d = 0.3,    # Base MOC to DOC rate
                                f = 0.02,   # % MBC to DOC (recycling)
                                h = 0.2,    # DOC respiration rate
                                
                                # Environmental inputs
                                T = 20,       
                                W = 0.25,
                                Q10 = 2,
                                T_ref = 20,
                                W_opt = 0.3,
                                
                                # New: clay content and CUE
                                clay = 0.25,     # soil clay fraction (0–1)
                                k_clay = 0.15,   # clay stabilization coefficient
                                CUE = 0.4        # carbon use efficiency
) {
  # Environmental modifiers
  fT <- Q10 ^ ((T - T_ref) / 10)
  fW <- 1 - ((W - W_opt) / W_opt)^2
  fW <- max(fW, 0)
  env_mod <- fT * fW
  
  # Recalculate e from CUE and respiration
  e <- (CUE / (1 - CUE)) * h  # derived from microbial C partitioning
  
  # Carbon partitioning
  LC  <- LB * 0.5  # Assumption: Average carbon content in plant litter is 50%
  POC_initial <- LC * 0.40 * env_mod
  DOC_initial <- LC * 0.20 * env_mod
  CO2_initial <- LC * 0.40 * env_mod
  
  # Modify conversion rates by environment
  c_mod <- c * env_mod
  d_mod <- d * env_mod
  
  # DOC pool includes direct litter + converted POC/MOC
  DOC <- LC * (1 - (a + b)) + POC * c_mod + MOC * d_mod
  
  # Microbial uptake and respiration
  DOC_uptake <- DOC * e * env_mod
  respired <- DOC * h * env_mod
  MBC <- DOC_uptake
  
  # DOC → MOC stabilization
  DOC_to_MOC <- DOC * clay * k_clay
  
  # Final labile DOC available after respiration, recycling, and stabilization
  labile <- DOC - respired + MBC * f - DOC_to_MOC
  recalcitrant <- (1 - c_mod) * POC + (1 - d_mod) * MOC + DOC_to_MOC
  
  result <- data.frame(
    T = T,
    W = W,
    env_mod = env_mod,
    litter_c = LC,
    microbial_carbon = MBC,
    CO2_release = respired,
    DOC_to_MOC = DOC_to_MOC,
    labile_fraction = labile,
    recal_frac = recalcitrant,
    clay = clay,
    CUE = CUE
  )
  
  return(result)
}







