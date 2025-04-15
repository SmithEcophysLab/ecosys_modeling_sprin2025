---
output:
  pdf_document: default
  html_document: default
  word_document: default
---
# log.md

This is a log file for manually entering weekly updates to the module.

## 2025-04-15

### Describe a plan for linking your module to the class model in your log.md file under a heading with today's date.
- The FRCC model will use inputs from the class model, specifically npp and vpd. The FRCC model will then adjusts npp based on fire occurrence. The only additional input the FRCC model needs is the moisture loss rate, which is not part of the class model. I could add one more step after line 49 in class_model.R and before the results. This step would only modify npp, while everything else remains unchanged.

### Describe the module development work you still need to complete for the final project.
- I fixed an error of my model. I used avearge value of biomass at across vpd and moisture loss rate. That's why the model output was showing that the highest amount of biomass loss would occur if the moisture loss rate is intermediate level. I could update the model to calculate the amount of debris/detritusafter fire and the amount of CO2 will be released to atmosphere.  