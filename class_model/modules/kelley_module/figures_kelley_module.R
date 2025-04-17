# figures_kelley_module.R
## script for figures!

# load libraries ---------------------------------------------------------------
library(R.utils)
library(ggplot2)
library(patchwork)

# load model -------------------------------------------------------------------
source('kelley_p_uptake&storage.R')


# run model, multiple sequences ------------------------------------------------
modeled_root_length <- kelley_module(root_length = seq(0.1, 1, by = 0.1))
modeled_soil_ph <- kelley_module(soil_ph = seq(1, 14, by = 0.5))


# figures from model -----------------------------------------------------------

## Root length
plot_rootlength <- 
  ggplot(modeled_root_length, aes (x = root_length, y = p_uptake_by_plants)) +
  geom_line( color = "brown", size = 2) +
  labs(title = "Effect of Root Length on Phosphorus Uptake", 
       x = expression("Root Length Average in Soil (cm/cm"^3*")"), 
       y = "Phosphorus Uptake (kg/ha/year)")


## pH P uptake by plants
plot_pH <- 
  ggplot(modeled_soil_ph, aes (x = soil_ph, y = p_uptake_by_plants)) +
  geom_line(color = "#071f35", size = 2) +
  labs(title = "Effect of pH on Phosphorus Uptake", 
       x = "Soil pH", 
       y = "Phosphorus Uptake (kg/ha/year)") +
  scale_x_continuous(breaks = seq(1, 14, by = 1))


### add the pools later
# 
# ## pH influence on remaining pi soluble pool
# plot_pi_sol <- ggplot(modeled_soil_ph, 
#                       aes (x = soil_ph, y = pool_pi_sol_after)) +
#   geom_line(color = "pink", size = 2) +
#   labs(title = "Effect of pH on Remaining Pool of Soluble Inorganic P", 
#        x = "Soil pH", 
#        y = expression("Soluble Inorganic P Pool (kg ha"^{-1}*")")) +
#   scale_x_continuous(breaks = seq(1, 14, by = 1))
# 
# ## pH influence on remaining po soluble pool
# plot_po <- ggplot(modeled_soil_ph, aes (x = soil_ph, y = pool_po_after)) +
#   geom_line(color = "lightblue", size = 2) +
#   labs(title = "Effect of pH on Remaining Pool of Soluble Organic P", 
#        x = "Soil pH", 
#        y = expression("Soluble Organic P Pool (kg ha"^{-1}*")")) +
#   scale_x_continuous(breaks = seq(1, 14, by = 1))
# 
# ## pH influence on remaining pi insoluble pool
# plot_pi_insol <- ggplot(modeled_soil_ph, 
#                         aes (x = soil_ph, y = pool_pi_insol_after)) +
#   geom_line(color = "darkred", size = 2) +
#   labs(title = "Effect of pH on Remaining Pool of Insoluable Inorganic P", 
#        x = "Soil pH", 
#        y = expression("Insoluable Inorganic P (kg ha"^{-1}*")")) +
#   scale_x_continuous(breaks = seq(1, 14, by = 1))
# 
# 
# ## combining the soil plots together
# combined_soil_plots <- plot_pi_sol + plot_pi_insol + plot_po

## saving images ---------------------------------------------------------------

# mrk - add save to a specific folder later
# ggsave(plot_rootlength,
#        filename = "kelley_plot_rootlength2.png",
#        device = "png",
#        height = 6, width = 9, units = "in")
# 
# ggsave(plot_pH,
#        filename = "kelley_plot_pH2_updated.png",
#        device = "png",
#        height = 6, width = 9, units = "in")
# 
# ggsave(combined_soil_plots,
#        filename = "./figures/kelley_plot_soil_pools.png",
#        device = "png",
#        height = 6, width = 9, units = "in")
