###################
#Litter Biomass Conversion from NPP
#Author: Puja Roy
###################

# This model predict the fraction of NPP that turn in to litter biomass
# Average temperature (Tavg) and mean annual precipitation (MAP) are mainly the
# drivers that influence this turnover fraction. Studies in this field suggest
# that, though there is no any simple linear relationship but plant litter
# biomass is positively related to precipitation and negatively with temperature
# (de Queiroz et al., 2019; Thakur et al., 2022)

# Here,
# NPP = Net Primary production
# LB= Litterfall biomass (gram)
# MAP = Mean Annual Precipitation (mm)
# Tavg = average temperature (°C)
# a = tuning constant that control sharpness of the data ()

Litter <- function(NPP = 1000,
                   Tavg = seq(10, 35, 0.5),   
                   MAP = seq(500, 2000, 10), 
                   a = 0.05) {                
  
  grid <- expand.grid(Tavg = Tavg, MAP = MAP)
  grid$x <- exp(-a * (grid$Tavg - grid$MAP / 100)^2)
  grid$LitterBiomass <- grid$x * NPP
  return(grid)
}
df <- Litter()

# Plot
library(ggplot2)
ggplot(df, aes(x = Tavg, y = LitterBiomass, color = MAP)) +
  geom_point() +
  labs(
    title = "Impact of Temperature and Precipitation on Litter Biomass",
    x = "Average Temperature (°C)",
    y = "Litter Biomass"
  )+ theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10, face = "bold"))

#limitation of this model is it only works best in Monsoonal zones or
# Temperate/boreal systems with synchronized growth windows where average 
# temperature and precipitation has balance
