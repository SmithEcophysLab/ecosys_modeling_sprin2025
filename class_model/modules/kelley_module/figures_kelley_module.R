# figures_kelley_module.R
## script for figures!

# load libraries ---------------------------------------------------------------
library(R.utils)
library(ggplot2)

# load model -------------------------------------------------------------------
source('kelley_p_uptake&storage.R')


# run model, multiple sequences ------------------------------------------------

test_roots <- kelley_module(root_length_average = seq(0.1, 1, by = 0.1))
test_ph <- modeled_soil_ph <- kelley_module(soil_ph = seq(1, 14, by = 0.5))




# figures ----------------------------------------------------------------------


plot_roots <- ggplot(test_roots, aes(x = root_length_average, y = p_uptake)) +
  geom_line(color = "forestgreen", size = 2) +
  geom_point(color = "darkgreen", size = 4) +
  labs(
    title = "Effect of Root Length on Phosphorus Uptake",
    x = "Root Length Average (m)",
    y = "P Uptake (g C m⁻² yr⁻¹)"
  )
 

plot_ph <- ggplot(test_ph, aes(x = soil_ph, y = p_uptake)) +
  geom_line(color = "steelblue", size = 2) +
  geom_point(color = "navy", size = 4) +
  labs(
    title = "Effect of Soil pH on Phosphorus Uptake",
    x = "Soil pH",
    y = "P Uptake (g C m⁻² yr⁻¹)"
  ) +
  scale_x_continuous(breaks = seq(1, 14, by = 1))


plot_soil <- ggplot(test_roots, aes(x = root_length_average, 
                                       y = p_pool_leftover)) +
  geom_line(color = "red", size = 2) +
  geom_point(size = 4, color = "darkred") +
  labs(
    title = "P Left Over vs. Root Length",
    x = "Average Root Length (m)",
    y = "P Left Over (gP m⁻² y⁻¹)"
  )


plot_roots
plot_ph
plot_soil



## saving figures --------------------------------------------------------------

ggsave(plot_roots,
       filename = "./figures/kelley_plot_rootlength.png",
       device = "png",
       height = 6, width = 9, units = "in")

ggsave(plot_ph,
       filename = "./figures/kelley_plot_pH2_updated.png",
       device = "png",
       height = 6, width = 9, units = "in")

ggsave(plot_soil,
       filename = "./figures/kelley_plot_soil_pools.png",
       device = "png",
       height = 6, width = 9, units = "in")

