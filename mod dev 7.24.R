# STRIPPED DOWN CODE
# GENERATE DATA 
source('PERM Functions v0.1.R')
Data <- Reservoir.Single.Generate(Len=248, Rate=.8 ,B=-.5, Err=.1, scale=NA)
x <- Data$y/Data$scale
#m <- rnorm(248,0,1)

#estimate ballpark values to inform prior distributions			
sel <-  x[-1]>x[-length(x)]
change <- x[-1]-(1-.0)*x[-length(x)]
increase <- mean(change[sel],na.rm=TRUE)
varMeasurementErr <- (var(x,na.rm=TRUE)*.25)*1
rateInput <- 2/increase	
priorval <- c(rateInput,varMeasurementErr)

if(is.na(priorval[1])) { 
  priorval[1] <- 1/mean(change + 0.5*x[-length(x)],na.rm=TRUE)
  priorval[2] <- 2 }

datalist <- list(xobs=x, L=length(x), priorval=priorval) #mobs=m,

# RUN MODEL
require(rstan)
model1 <- stan_model('PERM mod dev 7.24.stan')
options(mc.cores = parallel::detectCores())
fit1 <- sampling(model1, open_progress=FALSE, data = datalist, chains=4,cores=4,  
         iter=8000, control = list(adapt_delta = 0.9, stepsize=.8))
summary(fit1)
exp(summary(fit1)$summary[1])

traceplot(fit1, pars = c(
  'tau_0'
  , 'mean_rate_inputs'
  , 'precision_measerr'
  ,'lp__'
))

pairs(
  x = fit1
  , pars = c(
    'tau_0'
    , 'mean_rate_inputs'
    , 'precision_measerr'
    ,'lp__'
  )
)