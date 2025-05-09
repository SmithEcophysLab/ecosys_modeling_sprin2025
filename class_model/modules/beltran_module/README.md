Plant Competition Module

Plants compete for three primary resources that constrain growth, fitness, and survival: water, nutrients, and light. Among these, water is the foundational requirement for physiological function, and plants exhibit strong responses to its availability. When water is no longer limiting, resource allocation priorities shift toward acquiring other essential resources, such as soil nutrients and light. As a reflection of their resource acquisition strategies and ecological priorities, plants allocate assimilated carbon (C) to different organs (e.g., roots, leaves, stems) in patterns that enhance their ability to capture limiting resources (Reich 2014; Díaz et al. 2016).

The "plant_competition" module simulates how plants allocate assimilated C to roots, leaves, and stems based on total biomass and internal nutrient content. The allocation strategy is influenced by environmental conditions (soil moisture and light availability) and plant tissue stoichiometry (C, N, P, K proportions). This model helps explore trait-mediated responses to abiotic gradients and supports trait-based ecosystem modeling.


Inputs:

- TB: Total plant biomass
	Units: grams (g)

- C: Proportional carbon of the total biomass
	Units: 	g C per g biomass (0–1)

- N, P, K: Proportions of biomass composed of nitrogen, phosphorus, and potassium
	Units: g nutrient per g biomass (0–1)

- moisture: Soil moisture availability
	Units: 0–1 (fraction) - continue variable (Rodriguez-Iturbe & Porporato 2004) 

- light: Light availability
	Units: µmol m⁻² s⁻¹ - continue variable (Lambers et al., 2008)

Outputs: 

- environment: Categorical soil moisture (dry (≤0.3), moderate (0.3–0.7), wet (>0.7))

- light: Categorical light level (low (≤200), medium (200–600), high (>600) µmol m⁻² s⁻¹)

- C_allocated_to_roots, C_allocated_to_leaves, C_allocated_to_stems: Carbon allocated to each organ
	Units: gC

- root_nutrient_content, leaf_nutrient_content, stem_nutrient_content: Total nutrient content (based on internal tissue NPK and C allocation)
	Units: g

- total_nutrient_content: Sum of all nutrient content across organs
	Units: g


Assumptions
1) According to eco-evolutionary theory, plants present within a given ecosystem are adapted to its environmental conditions, and their traits reflect selective pressures by those conditions.

2) Nutrient levels (N, P, K) reflect plant tissue composition, not soil availability.

3) Model does not simulate nutrient uptake or photosynthesis.

4) Carbon and nutrients are allocated, not produced, therefore, this is a post-assimilation allocation model.


How does it work:

i) Environmental classification
	- Soil moisture
		dry (≤ 0.30)
		moderate (> 0.30 to ≤ 0.70)
		wet (> 0.70)
	- Light
		low (≤ 200 µmol m⁻² s⁻¹)
		medium (> 200 to ≤ 600)
		high (> 600)

ii) C allocation adjustments 
	- Water: plant allocate a greater proportion to roots under dry conditions 
	- Light: High light conditions promote greater investment to leaves and stems to photosynthesize (abovegroung growth)
	- Nutrient: N, P, and K are available in the total biomass proportion. Each nutrient modifies C allocation to organs
		- Low nutrient content (≤ 0.03): increases root allocation
		- Moderate nutrient content (0.04 - 0.06): balanced allocation to all organs 
		-  High nutrient content (≥ 0.07): increases leaf and stem allocation
			- As a result: the final C weight for each organ is a product of water, light, and nutrient (averaged across N, P, and K) as the main modifiers of C allocation .

iii) Respiration 
A fraction of the C assimilated is lost by respiration, which depends on soil moisture, whith higuer losses under drier conditions to reflect the cost of maitaning physiological and structural processes (Atkin et al. 2015). 

iv) C allocation 
Remaining C is allocated to all organs accoring to the modifiers (moisture, light, and nutrient)

v) Nutrient assimilation
From the proportion of each nutrient in the total biomass, then the model predicts after environmental interactions how much of them go to all organs. 


Example: 
library(R.utils)

source('Beltran_competition_module.R')

plant_competition(TB = 100, C = 0.7, N = 0.05, P = 0.05, K = 0.05, moisture = 0.5, light = 500)


References:

Atkin, O. K., Bloomfield, K. J., Reich, P. B., Tjoelker, M. G., Asner, G. P., Bonal, D., ... & Zaragoza‐Castells, J. (2015). Global variability in leaf respiration in relation to climate, plant functional types and leaf traits. New Phytologist, 206(2), 614-636.

Díaz, S., Kattge, J., Cornelissen, J. H., Wright, I. J., Lavorel, S., Dray, S., ... & Gorné, L. D. (2016). The global spectrum of plant form and function. Nature, 529(7585), 167-171.

Lambers, H., Chapin III, F. S., & Pons, T. L. (2008). Plant physiological ecology. Springer Science & Business Media.

Reich, P. B. (2014). The world‐wide ‘fast–slow’plant economics spectrum: a traits manifesto. Journal of ecology, 102(2), 275-301.

Rodríguez-Iturbe, I., & Porporato, A. (2007). Ecohydrology of water-controlled ecosystems: soil moisture and plant dynamics. Cambridge University Press.

