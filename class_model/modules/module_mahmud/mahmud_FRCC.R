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

FRCC_model <- function(carbon_stock = 0, moisture_loss_rate, vpd) {
  vpd_normalized <- vpd / 5 # normalized the vpd
  ignition_probability <- moisture_loss_rate * vpd_normalized
  fire_occurs <- rbinom(1, 1, ignition_probability) # weighted probability of fire occurence
  if (fire_occurs == 1) {
    biomass_loss <- (1 - moisture_loss_rate) 
    carbon_stock <- carbon_stock * (1 - biomass_loss)
  }
  return(carbon_stock)
}
