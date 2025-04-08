# log.md
This is the log file in which I manually enter weekly updates to my module

## 02_28_2025

1. what is the current state of your module?
My module is the early stage of development, which focused on simulate/understand competition among plant functional groups for light, water and nutrients, and how this biotic interaction affect carbon allocation. I have implemented a function that calculates light intensity at the bottom of the canopy, adding arbitrary values that could reflect real data to test the function.  

2. where are you at in the Kyker-Snowman road map?
Currently, I am at the very early stage in which I am looking references for processes relevance and representativity, but also implementing equations simultaneously to readings.

i) Assess process and potential impact: 
- light competition
  - Does the process behave consistently through space and time?
	Yes, 
  - Is the process included in a ESM already?
	Yes, it has been incorporated: LPJ-DGVM, ED2, CLM.
  - Is the process likely to impact climate on ESM-relevant space and time scales?
	Yes, as light impacts photosynthesis, then plants will impact on the carbon balance and albedo regarding the canopy. 

- nutrient competition (coming)
  - Does the process behave consistently through space and time?
  - Is the process included in a ESM already?
  - Is the process likely to impact climate on ESM-relevant space and time scales?

- water competition (coming)
  - Does the process behave consistently through space and time?
  - Is the process included in a ESM already?
  - Is the process likely to impact climate on ESM-relevant space and time scales?

ii) Test process alone 
- light competition
  - Build simple model and explore if it explains observed patterns.
	I have built a simple function to predict arbitrary values of light reaching the bottom of the canopy based on available light from the sun and the one shaded from plants. I do not know yet if it fits observed patterns.
  - Gather data to quantify and drive simple model at increasing scales.
	coming

- nutrient competition (coming)
  - Build simple model and explore if it explains observed patterns.
  - Gather data to quantify and drive simple model at increasing scales.

- water competition (coming)
  - Build simple model and explore if it explains observed patterns.
  - Gather data to quantify and drive simple model at increasing scales.

IV) Test process with ESM (coming)
- light competition
  - Connect simple model to biogeochemical cycles and process already in an ESM
  - Scale modeled process globally and evaluate its performance across multiple regions.
  - Compare new existing approaches; assess changes in global simulation.

- nutrient competition 
  - Connect simple model to biogeochemical cycles and process already in an ESM
  - Scale modeled process globally and evaluate its performance across multiple regions.
  - Compare new existing approaches; assess changes in global simulation.

- water competition 
  - Connect simple model to biogeochemical cycles and process already in an ESM
  - Scale modeled process globally and evaluate its performance across multiple regions.
  - Compare new existing approaches; assess changes in global simulation.

3. what papers have you been reading to refine your module?
- general 
	Craine, J. M., & Dybzinski, R. (2013). Mechanisms of plant competition for nutrients, water and light. Functional Ecology, 27(4), 833-840.

- light competition
	Monsi, M., & Saeki, T. (2005). On the factor light in plant communities and its importance for matter production. Annals of botany, 95(3), 549-567.

	De Pury, D. G. G., & FARQUHAR, G. D. (1997). Simple scaling of photosynthesis from leaves to canopies without the errors of big‐	leaf models. Plant, Cell & Environment, 20(5), 537-557.

	Chen, J. M., & Black, T. A. (1992). Defining leaf area index for non‐flat leaves. Plant, Cell & Environment, 15(4), 421-429.

- nutrient competition
	Coming...

- water competition
	Coming...

4. what are your goals for the upcoming week?
   -Find equations to implement for nutrient competition.
   -Keep identifying key papers for light competition and look for nutrient competition mechanisms papers. 


5. where do you need help from nick?
   -Addressing me to key literature based on my gaps. 


## 04_08_2025
Results of the sensitivity analysis:

- Evaluated inputs:
1) Total Biomass (TB) (g) – continuous input, increases from 300 to 800 g
2) Environmental Type (env_type) – categorical input with "dry", "moderate", and "wet" levels

All tests were run with constant nutrient values (N = P = K = 0.1), C is fixed at 0.7 (i.e., 70% of biomass is carbon), and fixed light level (light_lvl = "high").

For each environment (dry, moderate, wet), the model was run with increasing total biomass values. The resulting carbon allocation to roots, leaves, and stems was plotted against TB.

i) In dry environments, carbon allocation is mainly to roots, consistent with water-limited conditions.

ii) In moderate environments, allocation is more distributed to leaves and roots that to stems.

iii) In wet environments, the model shifts investment to leaves and stems, consistent with shoot-dominated growth when water is abundant.



## Upcoming updates
This is the section for upcoming updates, disregard until filled.

1. what is the current state of your module?
2. where are you at in the Kyker-Snowman road map?
i) Assess process and potential impact: 
- light competition
  - Does the process behave consistently through space and time?
  - Is the process included in a ESM already?
  - Is the process likely to impact climate on ESM-relevant space and time scales?

- nutrient competition
  - Does the process behave consistently through space and time?
  - Is the process included in a ESM already?
  - Is the process likely to impact climate on ESM-relevant space and time scales?

- water competition
  - Does the process behave consistently through space and time?
  - Is the process included in a ESM already?
  - Is the process likely to impact climate on ESM-relevant space and time scales?

ii) Test process alone 
- light competition
  - Build simple model and explore if it explains observed patterns.
  - Gather data to quantify and drive simple model at increasing scales.

- nutrient competition
  - Build simple model and explore if it explains observed patterns.
  - Gather data to quantify and drive simple model at increasing scales.

- water competition
  - Build simple model and explore if it explains observed patterns.
  - Gather data to quantify and drive simple model at increasing scales.

IV) Test process with ESM
- light competition
  - Connect simple model to biogeochemical cycles and process already in an ESM
  - Scale modeled process globally and evaluate its performance across multiple regions.
  - Compare new existing approaches; assess changes in global simulation.

- nutrient competition 
  - Connect simple model to biogeochemical cycles and process already in an ESM
  - Scale modeled process globally and evaluate its performance across multiple regions.
  - Compare new existing approaches; assess changes in global simulation.

- water competition 
  - Connect simple model to biogeochemical cycles and process already in an ESM
  - Scale modeled process globally and evaluate its performance across multiple regions.
  - Compare new existing approaches; assess changes in global simulation.

3. what papers have you been reading to refine your module?
- general 

- light competition
- nutrient competition
- water competition

4. what are your goals for the upcoming week?
5. where do you need help from nick?
