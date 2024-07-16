			data {
				int<lower=0> L; //length of time series
				vector<lower=0>[L] xobs; //time series of length L
				//vector [L] mobs;//moderator timeseries
				vector[2] priorval; //specifciation of priors 
			}
			parameters {
				real<upper=.7> tau_0; //beta intercept 
			  //real tau_1; //tau for predictor
				real<lower=0> mean_rate_inputs;
				real<lower=0> precision_measerr;
				real<lower=0> inputs[L-1];
				real<lower=0> latent_initial;
			}
			transformed parameters {
				real sigma_measerr;
				real rate_inputs;
				sigma_measerr = pow(precision_measerr, -.5);
				rate_inputs = pow(mean_rate_inputs, -1);
			}
			model {
				real latent[L];
				real beta[L-1];
				latent[1] = latent_initial;
				latent_initial ~ normal(xobs[1],sigma_measerr);
				xobs[1] ~ normal(latent[1], sigma_measerr);
	
				for (t in 2:L) { //t=time
					inputs[t-1] ~ exponential(rate_inputs);
					beta[t-1] = exp(tau_0 ); //+ tau_1*mobs[t-1]
					latent[t] = latent[t-1] - beta[t-1] * latent[t-1] + inputs[t-1];
          xobs[t] ~ normal(latent[t], sigma_measerr);
					}
	
			    mean_rate_inputs ~ exponential(priorval[1]);
			    precision_measerr ~ exponential(priorval[2]);
			    tau_0 ~ normal(-.7,.7);
		      //tau_1 ~ normal(0,.001);
			}
			
			

