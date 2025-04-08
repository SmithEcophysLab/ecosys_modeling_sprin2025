source("~/Documents/git/ecosys_modeling_sprin2025/class_model/modules/Chatterjee_module/chatterjee_Mycorrhizamodule.R")

# running sensitivity analysis by adding sequence for npp
Input_npp <- seq(0, 2000, 5)
output_npp <- Active_N_uptake(npp=  Input_npp)
output_npp$input <- Input_npp 


ggplot(output_npp, aes(x = input, y = COSTamf)) + geom_point()


# running sensitivity analysis by adding sequence for Nsoil
Input_Nsoil <- seq(0, 100, 0.2)
output_npp <- Active_N_uptake(Nsoil=  Input_Nsoil)
output_npp$input <- Input_Nsoil 

ggplot(output_npp, aes(x = input, y = COSTamf)) + geom_point()

# running sensitivity analysis by adding sequence for Croot
Input_Croot <- seq(0, 100, 0.2)
output_npp <- Active_N_uptake(Croot=  Input_Croot)
output_npp$input <- Input_Croot 

ggplot(output_npp, aes(x = input, y = COSTamf)) + geom_point()

# running sensitivity analysis by adding sequence for Croot & Nsoil
Input_Croot <- seq(0, 100, 0.2)
Input_Nsoil <- seq(0, 100, 0.2)
output <- Active_N_uptake(Croot= Input_Croot, Nsoil = Input_Nsoil)
output$Input_Croot <- Input_Croot 
output$Input_Nsoil <- Input_Nsoil 


# Plots showing how increase in soil nitrogen affects nitrogen uptake,
# Carbon cost to acquire nutrients from roots & carbon cost to acquire nutrients 
# from AMF
ggplot(output, aes(x = Input_Nsoil, y = COSTact)) + geom_point()
ggplot(output, aes(x = Input_Nsoil, y = Nuptake)) + geom_point()
ggplot(output, aes(x = Input_Nsoil, y = COSTamf)) + geom_point()


# Plots showing how increase in carbon content in roots affects nitrogen uptake,
# Carbon cost to acquire nutrients from roots & carbon cost to acquire nutrients 
# from AMF
ggplot(output, aes(x = Input_Croot, y = COSTact)) + geom_point()
ggplot(output, aes(x = Input_Croot, y = Nuptake)) + geom_point()
ggplot(output, aes(x = Input_Croot, y = COSTamf)) + geom_point()



