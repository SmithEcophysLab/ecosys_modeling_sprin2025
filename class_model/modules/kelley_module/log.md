# log.md
Weekly log file for tracking updates to kelley_module

## 2025/04/08
1. Sensitivity analysis
    - Variables: Tested 2 variabels "soil pH" and "root length" to see how it influences phoshorous (P) uptake of plants. 
    - Results: Soil pH apparently has no effect on P uptake, which I think might be because a formula is wrong somewhere. On the other hand with increasing root length there is increased phosphorus uptake in plants.
    - figure pH: https://github.com/SmithEcophysLab/ecosys_modeling_sprin2025/blob/kelley_branch/class_model/modules/kelley_module/figures/kelley_plot_pH2.png
    - figure root length: https://github.com/SmithEcophysLab/ecosys_modeling_sprin2025/blob/kelley_branch/class_model/modules/kelley_module/figures/kelley_plot_rootlength2.png 

2. Current papers
    - Reichert, T., Rammig, A., Papastefanou, P., Lugli, L. F., Darela Filho, J. P., Gregor, K., Fuchslueger, L., Quesada, C. A., & Fleischer, K. (2023). Modeling the carbon costs of plant phosphorus acquisition in Amazonian forests. Ecological Modelling, 485. https://doi.org/10.1016/j.ecolmodel.2023.110491
    - Mollier, A., de Willigen, P., Heinen, M., Morel, C., Schneider, A., & Pellerin, S. (2008). A two-dimensional simulation model of phosphorus uptake including crop growth and P-response. Ecological Modelling, 210(4), 453–464. 
    - Wang, Y. P., Law, R. M., & Pak, B. (2010). A global model of carbon, nitrogen and phosphorus cycles for the terrestrial biosphere. Biogeosciences, 7(7), 2261–2282. https://doi.org/10.5194/bg-7-2261-2010 


## 2025/04/01
1. what is the current state of your module? Kyker-Snowman road map?
    - Assess process, looking at exisitng models + improving understanding of the process mechanisms

2. what papers have you been reading to refine your module?
    - Mollier, A., de Willigen, P., Heinen, M., Morel, C., Schneider, A., & Pellerin, S. (2008). A two-dimensional simulation model of phosphorus uptake including crop growth and P-response. Ecological Modelling, 210(4), 453–464. 

    - Wang, Y. P., Law, R. M., & Pak, B. (2010). A global model of carbon, nitrogen and phosphorus cycles for the terrestrial biosphere. Biogeosciences, 7(7), 2261–2282. https://doi.org/10.5194/bg-7-2261-2010 

3. what are your goals for the upcoming week?
    - Improve the formulas going in, mainly just trying to understand what is "ideal" to incorporate and how feasable it is. 

4. where do you need help from nick?
    - When is the best time to separate out functions/ calculations from your module. 
    - Any tips on how to include time/ date-ranges? Is it a good idea to include specific dates since we want models to be more general than specific. 

## 2025/03/25
* What is the current state of the module? 
"Assess process" stage of the Kyker-Snowman raod map. 

* Papers reading to refine module:
1) Lincy Davis, P., Panneerselvam, S., Subramanian, K. S., Sandeep, S., Kannan, B., Shoba, N., & Maheswarappa, H. P. (2017). The CENTURY Model as a Tool to Study Soil Carbon Dynamics of Coconut Ecosystem in the Western Zone of Tamil Nadu, India. International Journal of Current Microbiology and Applied Sciences, 6(12), 3467–3476. https://doi.org/10.20546/ijcmas.2017.612.403
2) Parton, W. J. (1996). The CENTURY model. In Evaluation of soil organic matter models: Using existing long-term datasets (pp. 283-291). Berlin, Heidelberg: Springer Berlin Heidelberg.
3) Radcliffe, D. E., Reid, D. K., Blombäck, K., Bolster, C. H., Collick, A. S., Easton, Z. M., Francesconi, W., Fuka, D. R., Johnsson, H., King, K., Larsbo, M., Youssef, M. A., Mulkey, A. S., Nelson, N. O., Persson, K., Ramirez-Avila, J. J., Schmieder, F., & Smith, D. R. (2015). Applicability of Models to Predict Phosphorus Losses in Drained Fields: A Review. Journal of Environmental Quality, 44(2), 614–628. https://doi.org/10.2134/jeq2014.05.0220

* Goals for upcoming week. 
1) Incorporating feedback from module proposal


* Help from Nick? 
non yet


## 2025/02/27
* What is the current state of the module? 
"Assess process" stage of the Kyker-Snowman raod map. 

* Papers reading to refine module:
1) Lincy Davis, P., Panneerselvam, S., Subramanian, K. S., Sandeep, S., Kannan, B., Shoba, N., & Maheswarappa, H. P. (2017). The CENTURY Model as a Tool to Study Soil Carbon Dynamics of Coconut Ecosystem in the Western Zone of Tamil Nadu, India. International Journal of Current Microbiology and Applied Sciences, 6(12), 3467–3476. https://doi.org/10.20546/ijcmas.2017.612.403
2) Parton, W. J. (1996). The CENTURY model. In Evaluation of soil organic matter models: Using existing long-term datasets (pp. 283-291). Berlin, Heidelberg: Springer Berlin Heidelberg.
3) Radcliffe, D. E., Reid, D. K., Blombäck, K., Bolster, C. H., Collick, A. S., Easton, Z. M., Francesconi, W., Fuka, D. R., Johnsson, H., King, K., Larsbo, M., Youssef, M. A., Mulkey, A. S., Nelson, N. O., Persson, K., Ramirez-Avila, J. J., Schmieder, F., & Smith, D. R. (2015). Applicability of Models to Predict Phosphorus Losses in Drained Fields: A Review. Journal of Environmental Quality, 44(2), 614–628. https://doi.org/10.2134/jeq2014.05.0220

* Goals for upcoming week. 
1) Reading and reviewing CENTURY model/ others to refine phosphorus goal for module. 
2) Looking into mathmatical formulas baked into CENTURY model for potential additon into kelley_module

* Help from Nick? 
Currently okay, likely will have questions after this week/ weekend. 