# SENSITIVITY ANALYSIS
# Required Libarary

library(ggplot2)

#source("./mahmud_module/mahmud_FRCC.R")


# Setting up the pqarameters

moisture_loss_rate_values <- seq(0, 1, by = 0.1)
vpd_values <- seq(0, 5, by = 0.5)
initial_carbon_stock_values <- c(500, 5000)  # Corrected to just two values
n_simulations <- 100


# empty data frame to store the results
results <- data.frame()

# Loop over each combination of inputs
for (c in initial_carbon_stock_values) {
  for (m in moisture_loss_rate_values) {
    for (v in vpd_values) {
      carbon_stock_values <- numeric(n_simulations)
      for (i in 1:n_simulations) {
        carbon_stock_values[i] <- FRCC_model(carbon_stock = c, moisture_loss_rate = m, vpd = v)
      }
      mean_carbon_stock <- mean(carbon_stock_values)
      results <- rbind(results, data.frame(initial_carbon_stock = c,
                                           moisture_loss_rate = m,
                                           vpd = v,
                                           carbon_stock = mean_carbon_stock))
    }
  }
}

# Heatmap of Average Carbon Stock Sensitivity
figure1 <- ggplot(results, aes(x = vpd, y = moisture_loss_rate, fill = carbon_stock)) +
  geom_tile() +
  facet_wrap(~ initial_carbon_stock, labeller = label_both) +
  labs(title = "Average Carbon Stock Sensitivity", x = "Vapor pressure deficit (kPa)", y = "Moisture loss rate (%/hr)") +
  theme_bw() +
  theme(axis.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 10, face = "bold"),
        plot.title = element_text(hjust = 0.5))

figure1

ggsave("./module_mahmud/figure1.pdf", plot = figure1,
       height = 7.25, width = 7.25, units = "in", dpi = 300)

# Plot of Carbon Stock vs. Moisture Loss Rate with changing VPD
figure2 <- ggplot(results, aes(x = moisture_loss_rate, y = carbon_stock, color = factor(vpd))) +
  geom_line() +
  facet_wrap(~ initial_carbon_stock, labeller = label_both) +
  labs(title = "Carbon Stock vs. Moisture Loss Rate", x = "Moisture loss rate (%/hr)", y = "Carbon stock", 
       color = "Vapor pressure deficit (kPa)") +
  theme_bw() +
  theme(axis.title = element_text(size = 12, face = "bold"),
        strip.text = element_text(size = 10, face = "bold"),
        plot.title = element_text(hjust = 0.5))

figure2

ggsave("./module_mahmud/figure2.pdf", plot = figure2,
       height = 7.25, width = 7.25, units = "in", dpi = 300)