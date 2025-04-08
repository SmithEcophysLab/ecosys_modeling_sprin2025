# SENSITIVITY ANALYSIS
# Required Libarary

library(ggplot2)
library(reshape2)


#source("./mahmud_FRCC.R")

# Setting up the pqarameters

moisture_loss_rate_values <- seq(0, 1, by = 0.1)
vpd_values <- seq(0, 5, by = 0.5)
initial_carbon_stock_values <- c(500, 5000)  # Corrected to just two values
n_simulations <- 100


# Prepare an empty data frame to store simulation results
results <- data.frame()

# Loop over each combination of parameters
for (i in initial_carbon_stock_values) {
  for (i in moisture_loss_rate_values) {
    for (i in vpd_values) {
      sim_values <- numeric(n_simulations)
      for (i in 1:n_simulations) {
        sim_values[i] <- FRCC_model(carbon_stock = initial, moisture_loss_rate = m, vpd = v)
      }
      avg_carbon <- mean(sim_values)
      results <- rbind(results, data.frame(InitialCarbonStock = initial,
                                           MoistureLossRate = m,
                                           VPD = v,
                                           CarbonStock = avg_carbon))
    }
  }
}

# Heatmap of Average Carbon Stock Sensitivity
figure1 <- ggplot(results, aes(x = VPD, y = MoistureLossRate, fill = CarbonStock)) +
  geom_tile() +
  facet_wrap(~ InitialCarbonStock, labeller = label_both) +
  labs(title = "Average Carbon Stock Sensitivity", x = "VPD (kPa)", y = "Moisture Loss Rate") +
  theme_bw()

figure1

#ggsave("./module_mahmud/figure1.pdf", plot = figure1,
       #height = 7.25, width = 7.25, units = "in", dpi = 300)

# plot of Carbon Stock vs. Moisture Loss Rate to changing VPD
figure2 <- ggplot(results, aes(x = MoistureLossRate, y = CarbonStock, color = factor(VPD))) +
  geom_line() +
  facet_wrap(~ InitialCarbonStock, labeller = label_both) +
  labs(title = "Carbon Stock vs. Moisture Loss Rate", x = "Moisture Loss Rate", y = "Average Carbon Stock", 
       color = "VPD (kPa)") +
  theme_bw()

figure2
#ggsave("./module_mahmud/figure2.pdf", plot = figure2,
      # height = 7.25, width = 7.25, units = "in", dpi = 300)
