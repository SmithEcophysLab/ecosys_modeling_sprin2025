### Garry's Revamped Photosynthesis Module
## By Garry Garza


#The purpose of this module will be to incorperate the Johnson & Berry Cytb6f model into a module for use in our class model

#Citation for model: Johnson JE, Berry JA. The role of Cytochrome b6f in the control of steady-state photosynthesis: a conceptual and quantitative model. Photosynth Res. 2021 Jun;148(3):101-136. doi: 10.1007/s11120-021-00840-4. Epub 2021 May 17. PMID: 33999328; PMCID: PMC8292351.

# Possible Inputs: Light, Temperature, CO2
# Possible Outputs: Assimilated Carbon

garry_module <- function(par0 = 400, ### Photosynthetically Active Radiation (umol PPFD m-2 s-1)
                         temp = 25, ###  Temperature (°C)
                         CO2 = 200, ### Mesophyll CO2, ubar
                         O2 = 209, ### Atmospheric O2, mbar
                         Abs = 0.85, ### Total leaf absorptance to PAR, mol PPFD absorbed mol-1 PPFD incident
                         beta = 0.52, ### PSII fraction of total leaf absorptance, mol PPFD absorbed by PSII mol-1 PPFD absorbed
                         CB6F = ((350 / 300) / 1e6), ### Cyt b6f density, mol sites m-2
                         RUB = ((100 / 3.6) / 1e6), ### Rubisco density, mol sites m-2
                         Rds = 0.01, ### Scalar for dark respiration, dimensionless
                         Ku2 = 0e09, ### Rate constant for exciton sharing at PSII, s-1
                         theta1 = 1, ### Curvature parameter for Aj/Ac transition, dimensionless
                         eps1 = 0, ### PSI transfer function, mol PSI F to detector mol-1 PSI F emitted
                         eps2 = 1, ### PSII transfer function, mol PSII F to detector mol-1 PSII F emitted
                         alpha_opt = "static" ) ### option for static or dymanic absorption cross-sections of PSI and PSII
                         
