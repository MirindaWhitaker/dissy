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

Sys.time()
fit_sum <- list()

for (i in 1:20){
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
                   iter=10000, control = list(adapt_delta = 0.9, stepsize=.8))
  fit_sum[i]<- fit1
}

# R PUSH BULLET
require(RPushbullet)
pbPost(type = "note", title = "done", body = "30 loop complete")

Sys.time()

# REVIEW RUNS
tau_0beta <- rep(NA, 10)
for (i in 1:10) {
  tau_0beta[i] <- exp(summary(fit_sum[[i]])$summary[[1]])
}

mean(tau_0beta)

# spot check trace plots
  traceplot(fit_sum[[1]], pars = c(
    'tau_0'
    , 'mean_rate_inputs'
    , 'precision_measerr'
    ,'lp__'
  ))


png("output_plot.png")

pairs(
  x = fit_sum[[1]]
  , pars = c(
    'tau_0'
    , 'mean_rate_inputs'
    , 'precision_measerr'
    ,'lp__'
  )
)

# Generate some example data
x <- 1:10
y1 <- x^2
y2 <- x^3

# Create plots
plot1 <- plot(x, y1, main = "Plot 1: x vs x^2")
plot2 <- plot(x, y2, main = "Plot 2: x vs x^3")

# Save plots in a list
plot_list <- list(plot1, plot2)

# Access individual plots from the list
plot_list[[1]]  # Accesses the first plot
plot_list[[2]]  # Accesses the second plot
