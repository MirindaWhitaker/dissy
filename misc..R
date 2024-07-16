# potential values for beta to inform tau_0
log(.001) #very low beta
log(.1) #low beta
log(1) # high beta
log(2) # very high beta

norman <- rnorm(1000,-.7,.7)
hist(norman) 
