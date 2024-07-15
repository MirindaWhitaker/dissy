# STRIPPED DOWN CODE
# GENERATE DATA 
source('PERM Functions v0.1.R')
Data <- Reservoir.Single.Generate(Len=248, Rate=.8 ,B=-.5, Err=.1, scale=NA)
x <- Data$y/Data$scale
m <- rnorm(248,0,1)

# RUN MODEL
require(rstan)
model1 <- stan_model('PERM mod dev 7.24.stan')
datalist <- list(xobs=x, mobs=m, L=length(x))
options(mc.cores = parallel::detectCores())
fit1 <- sampling(model1, open_progress=FALSE,data = datalist, chains=4,cores=4,  
         control = list(adapt_delta = 0.99, stepsize=.8))
summary(fit1)
traceplot(fit1, pars = c(
  'tau_0'
  , 'tau_1'
  , 'mean_rate_inputs'
  , 'precision_measerr'
  ,'lp__'
))
pairs(
  x = fit1
  , pars = c(
    'tau_0'
    , 'tau_1'
    , 'mean_rate_inputs'
    , 'precision_measerr'
    ,'lp__'
  )
)