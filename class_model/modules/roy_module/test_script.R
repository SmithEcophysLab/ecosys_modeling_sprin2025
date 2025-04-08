litterbio <- function(Tmax = 35, 
                      P = 100,
                      Tavg = 25, 
                      Vforest = 1.5, 
                      a = 0.5, 
                      b = 0.2, 
                      c = 0.3, 
                      d = 10){ 
  L <- ((a*Tmax+b*P)*Vforest+(c*Tavg)+d) #put the constant value of d
  return(L) 
}

#test1
litterbio()
#[1] 73.75