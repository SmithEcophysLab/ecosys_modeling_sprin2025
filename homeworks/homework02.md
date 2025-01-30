# Homework 2
To continue approaching our class goal of creating a collective terrestrial ecosystem model,
we will make sure that everyone is comfortable using R.

1. Download R and (if desired) R Studio.

2. Somewhere on your computer, create a folder titled "biol6301_homework02"

3. Within your biol6301_homework02 folder on your computer, create a folder titled "data"

4. Download the [homework02_data.csv](../data/homework02_data.csv) file from the data folder on the class
website and place it in your biol6301_homework02/data folder that you created on your 
computer in the previous step. For questions about the dataset, please refer to the
[homework02_metadata.csv](../data/homework02_metadata.csv) file.

5. Within your biol6301_homework02 folder on your computer, create a folder titled "scripts"

6.  Within the biol6301_homework02/scripts folder that you created on your 
computer in the previous step create a file called homework02_script.R.

7. Modify your homework02_script.R script on your computer to load the tidyverse library

8. Modify your homework02_script.R script on your computer to read your
homework02_data.csv file in a way that is not specific to your system. Note that the common
computational assumption is that your working directory for any script, is the directory
that your script is in. Name this object "homework02_data"

9. Now your homework02_script.R script on your computer to
	- calculate vapor pressure deficit as a new variable in your homework02_data dataframe
	- calculate gross ecosystem production (gep) as net ecosystem production plus ecosystem respiration
	as a new variable in your homework02_data dataframe
	- plot gep as a function of temperature using closed red triangles 
	with appropriate axis titles (including units)
	- plot nep as a function of gep using closed red triangles 
	with appropriate axis titles (including units)
	- plot nep as a function of gep using open blue squares in units of µmolC m-2 s-1
	with appropriate axis titles (including units)

When completed, email your R script to [Nick](mailto:nick.smith@ttu.edu).

The assignment is due by the start of next class period.