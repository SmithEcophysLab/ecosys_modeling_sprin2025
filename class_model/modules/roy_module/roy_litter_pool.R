###################
#Changes in litter pool after drought
#Author: Puja Roy
###################

#I want to look at how the litter pool changes after drought in a particular
#terrestrial ecosystem
#To start with a simple form of function, I am taking plant green and brown
# biomass as input and their fraction as output

## biomass: Given two numeric arguments gbm and lbm referring the mass of  
## green biomass and litter biomass in gram
##     Args:
##       gbm and lbm = numeric argument 
##     Returns:
##      a numeric component representing the fraction of gbm and lbm

biomass <- function(gbm = 200, lbm = 350){
  fraction <- (gbm/lbm)
  return(fraction)
}

# Example
biomass()
# [1] 0.5714286 #default
biomass(400, 600)
# [1] 0.6666667

