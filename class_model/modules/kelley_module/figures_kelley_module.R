# figures_kelley_module.R
## script for figures!

# load libraries ---------------------------------------------------------------
library(R.utils)
library(ggplot2)


# load model -------------------------------------------------------------------
source('kelley_p_uptake&storage.R')


# run model, multiple sequences ------------------------------------------------
modeled_root_length <- kelley_module(root_length = seq(0.1, 1, by = 0.1))
modeled_pH_soil <- kelley_module(pH_soil = seq(1, 14, by = 0.5))


# figures from model ------------------------------------------------------------

## Root length
plot_rootlength <- 
  ggplot(modeled_root_length, aes (x = root_length, y = p_uptake_by_plants)) +
  geom_line( color = "brown", size = 2) +
  labs(title = "Effect of Root Length on Phosphorus Uptake", 
       x = expression("Root Length Average in Soil (cm/cm"^3*")"), 
       y = "Phosphorus Uptake (kg/ha/year)") +
  theme_minimal()


## pH P uptake by plants
plot_pH <- 
  ggplot(modeled_pH_soil, aes (x = pH_soil, y = p_uptake_by_plants)) +
  geom_line(color = "#071f35", size = 2) +
  labs(title = "Effect of pH on Phosphorus Uptake", 
       x = "Soil pH", 
       y = "Phosphorus Uptake (kg/ha/year)") +
  scale_x_continuous(breaks = seq(1, 14, by = 1)) +
  theme_minimal()



### add the pools later, get those units

## pH influence on remaining pi soluble pool
ggplot(modeled_pH_soil, aes (x = pH_soil, y = remaining_pool_pi_sol)) +
  geom_line(color = "#24496b", size = 2) +
  labs(title = "Effect of pH on Remaining Pool of Pi soluable", 
       x = "Soil pH", 
       y = "pool _________") +
  scale_x_continuous(breaks = seq(1, 14, by = 1)) +
  theme_minimal()

## pH influence on remaining po soluble pool
ggplot(modeled_pH_soil, aes (x = pH_soil, y = remaining_pool_po_sol)) +
  geom_line(color = "#446d92", size = 2) +
  labs(title = "Effect of pH on Phosphorus Uptake", 
       x = "Soil pH", 
       y = "pool ______ ") +
  scale_x_continuous(breaks = seq(1, 14, by = 1)) +
  theme_minimal()

## pH influence on remaining pi insoluble pool
ggplot(modeled_pH_soil, aes (x = pH_soil, y = remaining_pool_pi_insol)) +
  geom_line(color = "#98b1c8", size = 2) +
  labs(title = "Effect of pH on Phosphorus Uptake", 
       x = "Soil pH", 
       y = "pool ______ )") +
  scale_x_continuous(breaks = seq(1, 14, by = 1)) +
  theme_minimal()



## saving images ---------------------------------------------------------------

## mrk - add save to a specific folder later
# ggsave(plot_rootlength, 
#        filename = "kelley_plot_rootlength.png", 
#        device = "png",
#        height = 6, width = 9, units = "in")
# 
# ggsave(plot_pH, 
#        filename = "kelley_plot_pH.png", 
#        device = "png",
#        height = 6, width = 9, units = "in")
