# Draw N gamma distributed values
y_rgamma <- rgamma(1000, 1, 2) 

# Print values to RStudio console
mean(y_rgamma) 

# Plot of randomly drawn gamma density
hist(y_rgamma, breaks = 500,
     main = "")

expval <- rexp(1000,1.2)
mean(expval)
hist(expval)

