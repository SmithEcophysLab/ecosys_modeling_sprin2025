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

# The function takes litter biomass, and predicts the labile, recalcitrant 
# carbon fraction, and CO2 release from soil under different
# environmental conditions
#

carbon_fraction <- function(LB = 1000,  # Litter biomass
                            r_poc = 0.4,    # Base POC to DOC rate
                            r_moc = 0.3,    # Base net DOC to MOC rate
                            r_resp = 0.2,    # DOC respiration rate
                                
                            # Environmental inputs
                            temp = 20,  # average soil temperature   
                            W = 0.25, # soil water content
                            Q10 = 2, 
                            T_ref = 20,
                            W_opt = 0.3,
                                
                            # clay content and CUE
                            clay = 0.25,     # soil clay fraction
                            k_clay = 0.15,   # clay stabilization coefficient
                            CUE = 0.4        # carbon use efficiency
) {
  # Environmental modifiers
  fT <- Q10 ^ ((temp - T_ref) / 10)
  fW <- 1 - ((W - W_opt) / W_opt)^2
  fW <- max(fW, 0)
  env_mod <- fT * fW
  
  # calculate microbial carbon modifier from CUE and respiration
  mbc_mod <- (CUE / (1 - CUE)) * r_resp  # derived from microbial C partitioning
  
  # Carbon partitioning
  LC  <- LB * 0.5  # Assumption: Average carbon content in plant litter is 50%
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
  
  result <- data.frame(
    'T' = temp,
    'W' = W,
    'litter_c' = LC,
    'microbial_carbon' = MBC,
    'CO2_release' = heter_resp,
    'labile_fraction' = labile,
    'recal_fraction' = recalcitrant,
    'clay' = clay,
    'CUE' = CUE
  )
  
  return(result)
}







