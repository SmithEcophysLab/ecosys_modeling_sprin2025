library(ggplot2)
library(ggpubr)

source("devkota_soilcarbon.R")

set.seed(100)
input_LB <- runif(n=200, min=10, max= 1000)
sensitivity_LB <- carbon_fraction(LB = input_LB)
sensitivity_LB$input_LB <- input_LB 

a <- 
  ggplot(sensitivity_LB, aes(x = input_LB, y = labile_fraction)) +
  geom_point() +
  geom_smooth( method = "lm") +
  theme_bw() +
  annotate("text", x = 250, y = 200,
           label = "Slope: 0.236") +
  labs(x = "Litter Biomass",
       y = "Labile Carbon");a

summary(lm(labile_fraction ~ input_LB, data = sensitivity_LB))
# slope: 0.236

b <- 
  ggplot(sensitivity_LB, aes(x = input_LB, y = recal_frac)) +
  geom_point() +
  geom_smooth( method = "lm") +
  theme_bw() + 
  annotate("text", x = 250, y = 250,
           label = "Slope: 0.306") +
  labs(x = "Litter Biomass",
       y = "Recalcitrant Carbon");b

summary(lm(recal_frac ~ input_LB, data = sensitivity_LB))

# slope: 0.306

c <- 
  ggplot(sensitivity_LB, aes(x = input_LB, y = microbial_carbon)) +
  geom_point() +
  geom_smooth( method = "lm") +
  theme_bw() +
  annotate("text", x = 250, y = 25,
           label = "Slope: 0.0296") +
  labs(x = "Litter Biomass",
       y = "Microbial Carbon");c

summary(lm(microbial_carbon ~ input_LB, data = sensitivity_LB))
# slope: 0.0294

ggarrange(a,
          b,
          c)

# sensitivity of microbial respiration
set.seed(100)
h_input <- runif(n=200, min=0.001, max= 0.9)

sensitivity_h <- carbon_fraction(h = h_input)
sensitivity_h$input_h <- h_input

d <-
  ggplot(sensitivity_h, aes(x = input_h, y = labile_fraction)) +
  geom_point() +
  geom_smooth( method = "lm") +
  theme_bw() +
  annotate("text", x = 0.2, y = 100,
           label = "Slope: -294.0") +
  labs(x = "% of C respired",
       y = "Labile Carbon");d

summary(lm(labile_fraction ~ input_h, data = sensitivity_h))
# slope: - 294.0


e <- 
  ggplot(sensitivity_h, aes(x = input_h, y = recal_frac)) +
  geom_point() +
  geom_smooth( method = "lm") +
  theme_bw() +
  annotate("text", x = 0.25, y = 305,
           label = "Slope: - 7.8e-14") +
  scale_y_continuous(limits = c(303, 308)) +
  labs(x = "% of C respired",
       y = "Recalcitrant Carbon");e

summary(lm(recal_frac ~ input_h, data = sensitivity_h))
# slope: - 7.8 e-14 (not significant)

f <- 
  ggplot(sensitivity_h, aes(x = input_h, y = microbial_carbon)) +
  geom_point() +
  geom_smooth( method = "lm") +
  theme_bw() +
  annotate("text", x = 0.25, y = 28,
           label = "Slope: -2.11e-14") +
  scale_y_continuous(limits = c(27, 32)) +
  labs(x = "% of C respired",
       y = "Microbial Carbon"); f

summary(lm(microbial_carbon ~ input_h, data = sensitivity_h))
# slope: - 2.11 e-14 (not significant)

ggarrange(d, 
          e,
          f)



