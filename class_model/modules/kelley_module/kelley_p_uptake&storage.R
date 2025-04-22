################################################################################
## author: monika kelley
## purpose: model module : phosphorus uptake and storage
## date: 2025/02/18
################################################################################

# description: -----------------------------------------------------------------
## Module to depict phosphorus uptake and storage within a system
## Goal is to try and model how much P is likely stored within pools, e.g., 
## plant biomass (leaf, root, wood), litter, and within soil. How P moves
## moves through a system.


# inputs and outputs: ----------------------------------------------------------
## MRK: likely inputs and outputs

## INPUTS: litterfall, resorption efficiency of P, root length density in soil
## C:P stoichiometry, phosphorous available pools. 

## OUTPUTS: remaining P pools, phosphorous uptake by plants (roots)


## model  ----------------------------------------------------------------------

kelley_module <- function (
    
    ## root length average of soil 
    ### units m
    root_length_average = 0.25,
    
    ## Net Primary Productivity
    ### (gC m-2 y-1), grams of carbon per square meter per year
    npp_leaf = 1000, 
    npp_stem = 1500,
    npp_root = 800, 
    
    ## C:P stoichiometry (how much C per P is in the organ)
    ### Unit less, but interpreted as gC/gP
    ### diff. organs have diff. P demand for the same C gain
    cp_ratio_leaf = 350,
    cp_ratio_stem = 500, 
    cp_ratio_root = 400,
    
    ## % P is expected to be available this year, based on climate factors
    ### such as weather, and temp. (random value)
    ### y-1
    annual_p_availablity_percent = 0.2,
    
    ## P available/ the 3 main pools 
    ### (gP m-2 y-1) grams P per meter squared
    pool_pi_soluble = 30, # soluble Pi (immediately ready for plants, small #)
    pool_po_soluble = 50, # soluble Po (mineralization required convert to Pi)
    pool_pi_insoluble = 100, # insoluble Pi (very very slowly available)
    
    
    # soil influences
    ## pH modifies the mobility/ availability of P in soil for plant uptake
    soil_ph = 7
    
    ){
  
  
  # sub-module 1) plant P demand -----------------------------------------------
  
  ## P demand, how much C to P is in the organ based per NPP
  ### units gP m-2 y-1
  p_demand_leaf = npp_leaf / cp_ratio_leaf
  p_demand_stem = npp_stem / cp_ratio_stem
  p_demand_root = npp_root / cp_ratio_root
  p_demand_total = p_demand_leaf + p_demand_stem + p_demand_root

  
  # sub-module 2) P availability  ----------------------------------------------
  
  ## P in soil
  ### units gP m-2
  ph_mod <- ifelse(soil_ph >= 6 & soil_ph <= 8, 1, 0.5) 
  p_pool_total = pool_pi_soluble + pool_po_soluble + pool_pi_insoluble
  p_pool_total_ph_mod = (p_pool_total) * ph_mod # adding pH modification to soils
  
  ## P available per year
  ### gP m-2 y-1
  p_annual_availablity <- p_pool_total_ph_mod * annual_p_availablity_percent
  
  ## root length modifier, further modifying the p_annual_availability
  explore_depth <- 1.0 # max exploration depth of roots (units in meters)
  root_length_mod <- pmin(root_length_average / explore_depth, 1) #units cancel
  p_annual_availablity_root_mod <- p_annual_availablity * root_length_mod
  
  
  ### General CP ratio expected for whole area based on all the organs
  ## units gC/gP
  cp_ratios_all_organs <- c(cp_ratio_leaf, cp_ratio_stem, cp_ratio_root)
  cp_ratio_general <- mean(cp_ratios_all_organs)
  
  ## Converting P pool (g P m-2) to C equivalent (gC m-2 yr-1)
  ### units in g C m-2 yr-1
  p_pool_total_c_equivalent <- p_annual_availablity_root_mod * cp_ratio_general
  
  ## Converting P demand () to C equivalent (gC m-2 yr-1)
  p_demand_total_c_equivalent <- p_demand_total * cp_ratio_general 
  
  
  # sub-module 3) p uptake -----------------------------------------------------
  
  
  if(p_demand_total_c_equivalent < p_pool_total_c_equivalent){

    p_uptake <- p_demand_total_c_equivalent

  }else{

    p_uptake <- p_pool_total_c_equivalent

  }
  
  p_uptake_v2 <- p_pool_total_c_equivalent - p_demand_total
  
  ## how much of the P pool remains after uptake? 
  # Convert p_uptake back to P units (gP m-2 y-1)
  p_uptake_gp <- p_uptake / cp_ratio_general
  # Subtract P taken up from the available P
  p_pool_leftover <- p_annual_availablity_root_mod - p_uptake_gp
  
  # output results -------------------------------------------------------------
  results <- data.frame('p_uptake' = p_uptake,
                        'p_uptake_v2' = p_uptake_v2,
                        'root_length_average' = root_length_average, 
                        'p_demand_leaf' = p_demand_leaf,
                        'p_demand_stem' = p_demand_stem,
                        'p_demand_root' = p_demand_root,
                        'p_demand_total' = p_demand_total, 
                        'soil_ph' = soil_ph,
                        'ph_mod' = ph_mod,
                        'p_pool_total' = p_pool_total,
                        'p_pool_total_ph_mod' = p_pool_total_ph_mod,
                        'p_annual_availablity' = p_annual_availablity,
                        'root_length_mod' = root_length_mod,
                        'p_annual_availablity_root_mod', p_annual_availablity_root_mod,
                        'cp_ratio_general' = cp_ratio_general,
                        'p_pool_total_c_equivalent' = p_pool_total_c_equivalent,
                        'p_demand_total_c_equivalent' = p_demand_total_c_equivalent,
                        'p_pool_leftover' = p_pool_leftover)
  return(results)
}



# Testing ----------------------------------------------------------------------
## for some reason not pulling over to test function, and have to modify seq.
## using lapply... ugh. for now use here. 

kelley_module()

test_roots <- lapply(seq(0.1, 1, by = 0.1), function(x) 
  kelley_module(root_length_average = x))

test_roots_df <- do.call(rbind, test_roots)
test_roots_df

test_ph <- lapply(seq(1, 14, by = 1), function(x) 
  kelley_module(soil_ph = x))

test_ph_df <- do.call(rbind, test_ph)
test_ph_df



# Figures ----------------------------------------------------------------------

library(ggplot2)

plot_roots <- ggplot(test_roots_df, aes(x = root_length_average, y = p_uptake_v2)) +
  geom_line(color = "forestgreen", size = 1.2) +
  geom_point(color = "darkgreen", size = 2) +
  labs(
    title = "Effect of Root Length on Phosphorus Uptake",
    x = "Root Length Average (m)",
    y = "P Uptake (g C m⁻² yr⁻¹)"
  ) +
  theme_minimal()


plot_ph <- ggplot(test_ph_df, aes(x = soil_ph, y = p_uptake)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_point(color = "navy", size = 2) +
  labs(
    title = "Effect of Soil pH on Phosphorus Uptake",
    x = "Soil pH",
    y = "P Uptake (g C m⁻² yr⁻¹)"
  ) +
  theme_minimal()


plot_soil <- ggplot(test_roots_df, aes(x = root_length_average, y = p_pool_leftover)) +
  geom_line(color = "red", size = 1.2) +
  geom_point(size = 3, color = "darkred") +
  labs(
    title = "P Left Over vs. Root Length",
    x = "Average Root Length (m)",
    y = "P Left Over (gP m⁻² y⁻¹)"
  ) +
  theme_minimal()


## saving figures

# mrk - add save to a specific folder later
ggsave(plot_roots,
       filename = "../class_model/modules/kelley_module/figures/kelley_plot_rootlength_v3.png",
       device = "png",
       height = 6, width = 9, units = "in")

ggsave(plot_ph,
       filename = "../class_model/modules/kelley_module/figures/kelley_plot_pH2_updated_v3.png",
       device = "png",
       height = 6, width = 9, units = "in")

ggsave(plot_soil,
       filename = "../class_model/modules/kelley_module/figures/kelley_plot_soil_pools_v3.png",
       device = "png",
       height = 6, width = 9, units = "in")
