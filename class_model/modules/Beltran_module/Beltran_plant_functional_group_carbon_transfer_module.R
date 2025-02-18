###############################################################################
# Title: Plant Functional Group (PFG) Carbon Transfer Module
# Author: Isabella Beltran
# Date: 02/17/2025
###############################################################################
#
# Description: This module is an effort to understand how different plant functional groups (PFGs) influence carbon allocation into various ecosystem carbon pools. The PFGs represent plants with distinct carbon-use strategies, affecting how much carbon is stored in biomass, soil, microbial biomass, or lost through respiration. 
#
#Plant functional groups: <open for suggestions>
# - Fast-growing species
#   - annuals
# _ Slow-growing species
#   - perennials
# 
# Purpose:
# This module estimates carbon flux based on plant communities cover, soil moisture, temperature and higly probably inputs comming from other modules developed for this calss, but it remains TBD. 
# 
# Inputs:
# - vegetation cover: proportion of ground covered by vegetation (0-100)
# - soil_moisture data: given in %
# - temperature data: given in °C
# - ...
# 
# Outputs:
# - carbon flux: estimated carbon flux
# - carbon pool: estimated carbon by pool 
#
# Based on: checking on references ...
