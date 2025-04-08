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

library(R.utils)

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
      
        results <- c(C_to_fungi,C_to_fungal_biomass,C_respired)
        
           return(results)
         }

results <- mycorrhizal_fungi_module()


Active_N_uptake <- function(npp = 100, # net primary productivity
                            Cplant = 0.5 , # whole plant carbon
                            Nplant = 0.6 , # whole plant nitrogen 
                            Croot = 0.3 , # total carbon in root biomass
                            Nsoil=  0.9, # available soil nitrogen
                            Camf= 0.2,   # total carbon directed in AMF biomass
                            Cacq = 0.3, # carbon available to spend on nitrogen acquisition
                            kN = 1, # parameter that controls the cost as a function of soil N
                            kC= 1) # parameter that controls the cost as a function of root C
{ 
  # Plant Nitrogen demand 
  Ndemand <-  npp/(Cplant/Nplant)
  
  # Carbon cost to acquire nutrients from roots
  COSTact <- (kN/Nsoil) * (kC/Croot)
  
  # Plant Nitrogen uptake through roots
  Nuptake <- Cacq/COSTact
  
  # Carbon cost to acquire nutrients from AMF
  COSTamf <- (kN/Nsoil)*(kC/Camf)
  
  # Plant Nitrogen uptake through AMF
  Nuptakeamf <- Cacq/COSTamf
  
  # Total N uptake
  TotalN <- COSTact + COSTamf
  
  results <- data.frame("npp" = npp,
                        "Cplant" = Cplant,
                        "Nplant" = Nplant,
                        "Croot" = Croot,
                        "Nsoil" = Nsoil,
                        "Camf" = Camf,
                        "Cacq"= Cacq,
                        "kN"= kN,
                        "kC"= kC,
                        "Ndemand"= Ndemand,
                        "COSTact" = COSTact, 
                        "Nuptake" = Nuptake, 
                        "COSTamf" = COSTamf, 
                        "Nuptakeamf" = Nuptakeamf, 
                        "TotalN" = TotalN)
  
  return(results)
}

Active_N_uptake()

# adding random sequence to test the function

Active_N_uptake(npp = seq(0, 2000, 100))

Active_N_uptake(Camf= seq(0, 5, 0.5))

