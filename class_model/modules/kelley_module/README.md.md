# README.md
Read me file for the kelley module

# kelley_p_uptake&storage.R file
## description
The kelley_module is a model designed to estimate annual phosphorus (P) uptake by plants from soil, considering plant demand, soil P availability, and environmental modifiers. Plant P demand is based on three organ-specific (root, leaf, and stem) net primary productivity (NPP) and C:P stoichiometry, and estimates P availability from three different soil pools. P demand and availablity is modified soil pH and potential root exploration depth. 

## inputs
1. root_length_average: this is the average root length of the area measured in meters (m).

2. npp_leaf: Net primary productivity of the systems leaves measured in grams of carbon per square meter per year (gC m-2 y-1).

3. npp_stem: Net primary productivity of the systems stem, measured in grams of carbon per square meter per year (gC m-2 y-1).

4. npp_root = Net primary productivity of the systems root, measured in grams of carbon per square meter per year (gC m-2 y-1).

5. cp_ratio_leaf: C:P stoichiometry, how much carbon per phosphorous is in the leaves per system (average) unitless but interpreted as grams of carbon per grams of phosphorous (gC/gP).

6. cp_ratio_stem: C:P stoichiometry, how much carbon per phosphorous is in the stems per system (average) unitless but interpreted as grams of carbon per grams of phosphorous (gC/gP).

7. cp_ratio_root: C:P stoichiometry, how much carbon per phosphorous is in the roots per system (average) unitless but interpreted as grams of carbon per grams of phosphorous (gC/gP).

8. annual_p_availablity_percent: % phosphorous expected to be available, based on climate factors such as weather, and tempeature units are per year (y-1)

9. pool_pi_soluble: How much phosphorous is actively available to plants in the soluble Pi pool, units are grams of P per meter squared per year (gP m-2 y-1)

10. pool_po_soluble: How much phosphorous is actively available to plants in the soluble Po pool, units are grams of P per meter squared per year (gP m-2 y-1)

11. pool_pi_insoluble: How much phosphorous is actively available to plants in the insoluble Pi pool, units are grams of P per meter squared per year (gP m-2 y-1)

12. soil_ph: soil pH which modifies the mobility/ availability of phosphorous in soil for plant uptake.


## outputs
1.	p_uptake: Total phosphorus uptake by plants, units are measured in grams of carbon per square meter per year (gC m-2 y-1).

2.	p_uptake_v2: Alternative phosphorus uptake, units are measured in grams of carbon per square meter per year (gC m-2 y-1).

3.	root_length_average: The average root length of the area, carried over from input, measured in meters (m).

4.	p_demand_leaf: Phosphorus demand of leaves, units are measured in grams of phosphorus per square meter per year (gP m-2 y-1).

5.	p_demand_stem: Phosphorus demand of stems, measured in grams of phosphorus per square meter per year (gP m-2 y-1).

6.	p_demand_root: Phosphorus demand of roots, units are measured in grams of phosphorus per square meter per year (gP m-2 y-1).

7.	p_demand_total: Total plant phosphorus demand for all organs, units are measured in grams of phosphorus per square meter per year (gP m-2 y-1).

8.	soil_ph: Soil pH value, carried over from input.

9.	ph_mod: Soil pH modifier applied to phosphorus availability, unitless (1 if optimal pH; 0.5 if outside optimal pH).

10.	p_pool_total: Total phosphorus pool in the soil before pH adjustment, calculated as the sum of Pi soluble, Po soluble, and Pi insoluble pools, measured in grams of phosphorus per square meter (gP m-2).

11.	p_pool_total_ph_mod: Total phosphorus pool after adjustment for soil pH effects, measured in grams of phosphorus per square meter (gP m-2).

12.	root_length_mod: Modifier reflecting the proportion of roots exploration depth relative to maximum exploration depth, unitless (capped at 1).

13.	p_annual_availablity_root_mod: Annual phosphorus availability after accounting for pH and root length effects, measured in grams of phosphorus per square meter per year (gP m-2 y-1).

14.	cp_ratio_general: General C:P ratio averaged across all plant organs, unitless but interpreted as grams of carbon per gram of phosphorus (gC/gP).

15.	p_pool_total_c_equivalent: Total phosphorus pool converted to carbon-equivalent units, measured in grams of carbon per square meter per year (gC m-2 y-1).

16.	p_demand_total_c_equivalent: Total phosphorus, measured in grams of carbon per square meter per year (gC m-2y-1).

17.	p_uptake_gp: Phosphorus uptake by plants, measured in grams of phosphorus per square meter per year (gP m-2 y-1).

18.	p_annual_availablity: Annual phosphorus availability before root length modification, measured in grams of phosphorus per square meter per year (gP m-2y-1).

19.	p_pool_leftover: Remaining phosphorus in the soil after plant uptake, measured in grams of phosphorus per square meter per year (gP m-2 y-1).

# test_kelley_module.R file
## description
R script is to be used to test the “Kelley_p_uptake&storage” module. The R script currently only tests the different root length averages and soil pH. 

# Sources 
1. Reichert, T., Rammig, A., Papastefanou, P., Lugli, L. F., Darela Filho, J. P., Gregor, K., Fuchslueger, L., Quesada, C. A., & Fleischer, K. (2023). Modeling the carbon costs of plant phosphorus acquisition in Amazonian forests. Ecological Modelling, 485. 

2. Mollier, A., de Willigen, P., Heinen, M., Morel, C., Schneider, A., & Pellerin, S. (2008). A two-dimensional simulation model of phosphorus uptake including crop growth and P-response. Ecological Modelling, 210(4), 453–464.

3. Wang, Y. P., Law, R. M., & Pak, B. (2010). A global model of carbon, nitrogen and phosphorus cycles for the terrestrial biosphere. Biogeosciences, 7(7), 2261–2282.

