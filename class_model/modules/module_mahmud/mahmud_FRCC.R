# Azaj Mahmud

#################################################################################################
# This script is for FRCC (Fire regimes carbon cycling) model at the ecosystems scale, this model has two part, inspired
# by Akihiko (2005). In this model the fire intensity depends on the flammability of the most
# dominant plant species (Wyse et al., 2018) and and fire probability is proportional to vpd and moisture loss
# rate (Mahmud et al., In press) of that dominant plant species (This parts needs to be tested).
#################################################################################################

#################################################################################################
# Required Libraries
################################################################################################
# we will fit the fire regimes as a function of environmental variables using gam similar 
# to Pausas et al. (2022).


FRCC_model <- function(years, flammability, vpd, moisture_loss_rate) {
  carbon_stock <- 50  # Initial biomass, for now putting it as 50
  results <- numeric(years)  # Store biomass over time
  
  for (year in 1:years) {
    # Carbon increase over time
    carbon_stock <- carbon_stock + 0  # Fixed yearly growth rate, need to determine but for now it's zero
    
    # Fire probability is directly proportional to VPD and moisture loss rate of the dominant plant species
    fire_prob <- vpd[year] * moisture_loss_rate[year]  
    
    # Check for fire occurrence
    if (runif(1) > fire_prob) { # this parts needs thought since fire occurence is not deterministic
      fire_intensity <- flammability  # Fire intensity depends on the flammability of the most dominant plant species
      carbon_stock <- carbon_stock * (1 - fire_intensity)  # Biomass loss due to fire
    }
    
    results[year] <- carbon_stock
  }
  
  return(results)
}


