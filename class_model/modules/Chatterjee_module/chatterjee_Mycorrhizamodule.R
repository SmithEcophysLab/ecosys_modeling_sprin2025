#Title- Mycorrhizal fungi module
# Snehanjana Chatterjee

# Description of the module- I plan on incorporating Mycorrhizal fungi for my module
# to understand the movement of carbon through the interactions between plant roots 
# and the fungi. Mycorrhizal fungi here accounts for only endo (Arbuscular mycorrhizal
# fungi) and ectomycorrhiza. I have not thought about incorporating ericoid,
# arbutoid, orchid and monotropoid mycorrhiza. 

# Carbon input in my module will be from the photosynthates (sugar)
# made by the plants that is transferred to the fungi. A part of the carbon is
# lost into the soil through root exudates as well which might be used by the fungi.

# Carbon output- Most of the photosynthates transferred to the fungi is used to 
# increase fungal biomass. The hyphae secrete a glycoprotein called glomalin related 
# soil protein (GSRP) that helps in soil aggregation. It acts as a glue by forming
# microaggregates and macroaggregates.GSRP also prevents high loss of carbon 
# through hyphal respiration. But a part of the carbon is lost through hyphal 
# respiration as well. In forests, mycorrhiza maintain a common mycorrhizal network
# with different fungal species associated with nearby plant species. The carbon can
# be transported through that network to other fungal species if they are cheating or
# being parasitic. Soil organic matter is the largest pool of carbon that is formed
# due to decomposition by protozoa, protists and bacteria.



mycorrhizal_fungi_module <- function(carbon_fixed = 100,  # amount of carbon fixed by plants
                                    fungal_transfer_rate = 0.2, # percentage of C transferred to mycorrhiza
                                    fungal_biomass_rate = 0.7,  # percentage of C used to make fungal biomass
                                    fungal_respiration_rate = 0.3) # percentage of C lost by hyphal respiration
     {
       # Amount of carbon transferred to fungi
        C_to_fungi <- carbon_fixed * fungal_transfer_rate
        
       # Amount of carbon allocated to fungal biomass and respiration
       C_to_fungal_biomass <- C_to_fungi * fungal_biomass_rate
       C_respired <- C_to_fungi * fungal_respiration_rate
      
        results <- list(C_to_fungi,C_to_fungal_biomass,C_respired)
        
           return(results)
         }

results <- mycorrhizal_fungi_module()






