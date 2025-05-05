###################
#Litter Biomass Conversion from NPP
#Author: Puja Roy
###################


library(ggplot2)

# with constant Precipitation
####################################

Litter <- function(NPP = 1000,
                   Tavg = seq(15, 25, 0.05),   
                   MAP = 1500, 
                   a = 0.05,
                   b = 0.01) {                
  x <- exp(-a * (Tavg - MAP*b)^2)
  LB <- x*NPP
  return(data.frame(LB = LB, Tavg = Tavg, MAP = MAP)) 
}
df <- Litter()

# Plot
ggplot(df, aes(x = Tavg, y = LB)) +geom_point() + labs(
  title = "Impact of average Temperature on Litter Biomass(MAP = constant)",
  x = "Temperature (°C)",
  y = "Litter Biomass (µmol m-2 s-1)")+theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10, face = "bold"))


# with constant Temperature
##############################
Litter <- function(NPP = 1000,
                   Tavg = 10,   
                   MAP = seq(500, 1500, 2), 
                   a = 0.05,
                   b = 0.01) {                
  x <- exp(-a * (Tavg - MAP*b)^2)
  LB <- x*NPP
  return(data.frame(LB = LB, Tavg = Tavg, MAP = MAP)) 
}
df <- Litter()

# Plot
ggplot(df, aes(x = MAP, y = LB)) +geom_point() + labs(
  title = "Impact of MAP on Litter Biomass(Tavg = constant)",
  x = "Precipitation (°C)",
  y = "Litter Biomass (µmol m-2 s-1)") +
  theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10, face = "bold"))

#with changing Tavg and MAP
#############################
Litter <- function(NPP = 1000,
                   Tavg = seq(10, 25, 0.05),   
                   MAP = seq(500, 2000, 5), 
                   a = 0.05,
                   b = 0.01) {                
  
  grid <- expand.grid(Tavg = Tavg, MAP = MAP)
  grid$x <- exp(-a * (grid$Tavg - grid$MAP*b)^2)
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
    y = "Litter Biomass (µmol m-2 s-1)"
  )+ theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10, face = "bold"))

# various tuning constant "a"

Litter <- function(NPP = 1000,
                   Tavg = 15,   
                   MAP = 800, 
                   a = seq(0.05, 1, 0.0005),
                   b = 0.01) {                
  x <- exp(-a * (Tavg - MAP*b)^2)
  LB <- x*NPP
  return(data.frame(LB = LB, Tavg = Tavg, MAP = MAP, a = a)) 
}
df <- Litter()

# Plot
ggplot(df, aes(x = a, y = LB)) +geom_point() + labs(
  title = "Impact of average Temperature on Litter Biomass(MAP = constant)",
  x = "Tuning constant (a) ",
  y = "Litter Biomass (µmol m-2 s-1)")+theme_bw() +
  theme(plot.title = element_text(size = 12, face = "bold", hjust = 0.5),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text = element_text(size = 10, face = "bold"))
