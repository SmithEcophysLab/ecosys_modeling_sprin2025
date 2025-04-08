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

carbon_fraction <- function (LB = 1000 , # litter biomass (both aboveground and belowground)
                             C = 0.6, # % of C content of the litter
                             a = 0.5, # % of C in litter that goes to POC
                             b = 0.3, # % of C in litter that goes to MOC
                             c = 0.4, # POC to DOC conversion rate
                             d = 0.3, # MOC to DOC conversion rate
                             e = 0.1, # proportion of DOC assimilated by microbes
                             f = 0.02, # proportion of MBC that goes back to DOC
                             h = 0.2) # % of DOC respired by microbes
{
  
  LC  <- LB * C # total C in litter
  POC <- LC * a
  MOC <- LC * b
  DOC <- LC * (1-(a+b)) + POC * c + MOC * d
  MBC <- DOC * e
  respired <- DOC * h
  labile <- DOC - respired + MBC * f # assumption: 100% MBC goes back to DOC
  recalcitrant <-  (1-c) * POC + (1-d) * MOC
  
  result <- data.frame('litter_c' = LC,
                       'labile_fraction' = labile,
                       'microbial_carbon' =  MBC,
                       "recal_frac" = recalcitrant,
                       "CO2_release" = respired)
  return(result)
}







