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