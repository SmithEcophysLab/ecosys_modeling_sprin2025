# figures_kelley_module.R
## script for figures!

# load libraries ---------------------------------------------------------------
library(R.utils)
library(ggplot2)
library(patchwork)

# load model -------------------------------------------------------------------
source('kelley_p_uptake&storage.R')


# run model, multiple sequences ------------------------------------------------

test_roots <- lapply(seq(0.1, 1, by = 0.1), function(x) 
  kelley_module(root_length_average = x))

test_roots_df <- do.call(rbind, test_roots)
test_roots_df

test_ph <- lapply(seq(1, 14, by = 1), function(x) 
  kelley_module(soil_ph = x))

test_ph_df <- do.call(rbind, test_ph)
test_ph_df

# figures ----------------------------------------------------------------------



plot_roots <- ggplot(test_roots_df, aes(x = root_length_average, y = p_uptake)) +
  geom_line(color = "forestgreen", size = 2) +
  geom_point(color = "darkgreen", size = 4) +
  labs(
    title = "Effect of Root Length on Phosphorus Uptake",
    x = "Root Length Average (m)",
    y = "P Uptake (g C m⁻² yr⁻¹)"
  ) +
  theme_minimal()
 

plot_ph <- ggplot(test_ph_df, aes(x = soil_ph, y = p_uptake)) +
  geom_line(color = "steelblue", size = 2) +
  geom_point(color = "navy", size = 4) +
  labs(
    title = "Effect of Soil pH on Phosphorus Uptake",
    x = "Soil pH",
    y = "P Uptake (g C m⁻² yr⁻¹)"
  ) +
  theme_minimal()


plot_soil <- ggplot(test_roots_df, aes(x = root_length_average, y = p_pool_leftover)) +
  geom_line(color = "red", size = 2) +
  geom_point(size = 4, color = "darkred") +
  labs(
    title = "P Left Over vs. Root Length",
    x = "Average Root Length (m)",
    y = "P Left Over (gP m⁻² y⁻¹)"
  ) +
  theme_minimal()




## saving figures --------------------------------------------------------------
# 
# # mrk - add save to a specific folder later
# ggsave(plot_roots,
#        filename = "../class_model/modules/kelley_module/figures/kelley_plot_rootlength_v3.png",
#        device = "png",
#        height = 6, width = 9, units = "in")
# 
# ggsave(plot_ph,
#        filename = "../class_model/modules/kelley_module/figures/kelley_plot_pH2_updated_v3.png",
#        device = "png",
#        height = 6, width = 9, units = "in")
# 
# ggsave(plot_soil,
#        filename = "../class_model/modules/kelley_module/figures/kelley_plot_soil_pools_v3.png",
#        device = "png",
#        height = 6, width = 9, units = "in")

