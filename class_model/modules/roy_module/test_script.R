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

library(ggplot2)

# with constant Precipitation
####################################

Litter <- function(NPP = 1000,
                   Tavg = seq(15, 25, 0.05),   
                   MAP = 2000, 
                   a = 0.05) {                
  x <- exp(-a * (Tavg - MAP/100)^2)
  LB <- x*NPP
  return(data.frame(LB = LB, Tavg = Tavg, MAP = MAP)) 
}
df <- Litter()

# Plot
ggplot(df, aes(x = Tavg, y = LB)) +geom_point() + labs(
  title = "Impact of average Temperature on Litter Biomass(MAP = constant)",
  x = "Temperature (°C)",
  y = "Litter Biomass (gram)")+theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10, face = "bold"))


# with constant Temperature
##############################
Litter <- function(NPP = 1000,
                   Tavg = 20,   
                   MAP = seq(800, 2000, 2), 
                   a = 0.05) {                
  x <- exp(-a * (Tavg - MAP/100)^2)
  LB <- x*NPP
  return(data.frame(LB = LB, Tavg = Tavg, MAP = MAP)) 
}
df <- Litter()

# Plot
ggplot(df, aes(x = MAP, y = LB)) +geom_point() + labs(
  title = "Impact of MAP on Litter Biomass(Tavg = constant)",
  x = "Precipitation (°C)",
  y = "Litter Biomass (gram)") +
  theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10, face = "bold"))

#with changing Tavg and MAP
#############################
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

