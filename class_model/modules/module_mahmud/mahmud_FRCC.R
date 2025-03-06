# Azaj Mahmud

#################################################################################################
# This script is for FRCC (Fire regimes carbon cycling) model at the ecosystems scale, this model has two part, inspired
# by Akihiko (2005). First, we model the fire regimes which has two parts as well. First part is a train dataset and
# we will data from Pausas et al. (2022). This train dataset has fire regimes components and they were modelled
# based on the two environmental variables. Later, this train data will be used to predict the fire regimes 
# components using only two environmental variables: maximum temperaure of the driest and the weetest
# month of an ecosystems. Both the train and real dataset will have another column name ecosytems.
#################################################################################################

#################################################################################################
# Required Libraries
################################################################################################
# we will fit the fire regimes as a function of environmental variables using gam similar 
# to Pausas et al. (2022).


FR_model <- function(train_data, real_data) { # two dataset as input
  
  # making sure the required column name exists in the dataset
  required_cols <- c("fire_size", "fire_intensity", "fire_patchiness", "fire_recurrence", 
                     "temp_driest", "temp_wettest", "ecosystem")
  
  if (!all(required_cols %in% colnames(train_data))) {
    stop("Train data must contain columns: fire_size, fire_intensity,
         fire_patchiness, fire_recurrence, temp_driest, temp_wettest, and ecosystem")
  }
  
  if (!all(required_cols[-c(1:4)] %in% colnames(real_data))) {
    stop("Real data must contain columns: temp_driest, temp_wettest, and ecosystem")
  }
  
  train_data$ecosystem <- as.factor(train_data$ecosystem)
  real_data$ecosystem <- as.factor(real_data$ecosystem)
  
  
}


