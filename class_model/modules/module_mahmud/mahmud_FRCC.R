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

library(mgcv) # we will fit the fire regimes as a function of environmental variables using gam similar 
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
  
  # fitting GAM models, leave it now for simple linear relationship.
  fire_size_model <- gam(fire_size ~ temp_driest + ecosystem, data = train_data, family = gaussian)
  fire_intensity_model <- gam(fire_intensity ~ temp_driest + ecosystem, data = train_data, family = gaussian)
  fire_patchiness_model <- gam(fire_patchiness ~ temp_wettest + ecosystem, data = train_data, family = gaussian)
  fire_recurrence_model <- gam(fire_recurrence ~ temp_driest + ecosystem, data = train_data, family = gaussian)
  
  # predicting fire regimes from the train dataset to real dataset
  fire_size_pred <- predict(fire_size_model, newdata = real_data, type = "response")
  fire_intensity_pred <- predict(fire_intensity_model, newdata = real_data, type = "response")
  fire_patchiness_pred <- predict(fire_patchiness_model, newdata = real_data, type = "response")
  fire_recurrence_pred <- predict(fire_recurrence_model, newdata = real_data, type = "response")
  
  # output as data frame
  predicted_data <- data.frame(
    ecosystem = real_data$ecosystem,
    temp_driest = real_data$temp_driest,
    temp_wettest = real_data$temp_wettest,
    fire_size_pred = fire_size_pred,
    fire_intensity_pred = fire_intensity_pred,
    fire_patchiness_pred = fire_patchiness_pred,
    fire_recurrence_pred = fire_recurrence_pred
  )
  
  return(predicted_data)
}


## Dummy dataset for now to test

# Define ecosystem types
ecosystems <- c("tundra", "mediterranean", "arid", "mountains", "atlantic", "boreal", "steppic", "continental")

# train data
train_data <- data.frame(
  fire_size = c(100, 500, 1200, 3000, 4500, 2000, 750, 3200),
  fire_intensity = c(200, 800, 1500, 2800, 3500, 1800, 600, 2900),
  fire_patchiness = c(0.2, 0.5, 0.7, 0.85, 0.9, 0.6, 0.4, 0.8),
  fire_recurrence = c(3, 7, 10, 15, 20, 12, 6, 17),
  temp_driest = c(10, 15, 20, 25, 30, 18, 12, 28),
  temp_wettest = c(5, 10, 12, 18, 22, 14, 8, 20),
  ecosystem = ecosystems,
  stringsAsFactors = FALSE
)

# real dataset
real_data <- data.frame(
  temp_driest = c(12, 18, 24, 27, 33, 20, 15, 30),
  temp_wettest = c(6, 12, 15, 19, 23, 13, 10, 21),
  ecosystem = sample(ecosystems, 8, replace = TRUE),
  stringsAsFactors = FALSE
)

# Print the datasets
print(train_data)
print(real_data)

FR_model(train_data = train_data, real_data = real_data)
