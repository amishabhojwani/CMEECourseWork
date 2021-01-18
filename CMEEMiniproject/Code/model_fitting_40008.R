#################
# prep the data #
#################

# load data
data <- read.csv("../Data/CRat.csv")
iden="40010"
subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read subset


# write results table for all of the subsets and their best fit model
results_lms <- matrix(ncol = 3)
colnames(results_lms) <- c("ID", "Agree", "Best_lm")

# fit linear model
try(lm1fit <- lm(N_TraitValue ~ ResDensity, data=subdata), silent=TRUE)
  
# fit quadratic model
try(lm2fit <- lm(N_TraitValue ~ poly(x=ResDensity, degree=2, raw = TRUE), data=subdata), silent = TRUE)

# fit cubic model
try(lm3fit <- lm(N_TraitValue ~ poly(x=ResDensity, degree=3, raw = TRUE), data=subdata), silent = TRUE)

# fit the holling type II model
## define holling type II eq
Holl.type2 <- function(x, a, h) {
  (a*x)/(1+a*h*x)
}

## starting values for holling type II
### calculate Fmax and Nhalf
Fmax=max(subdata$N_TraitValue)
halfFmax.index=which.min(abs(subdata$N_TraitValue-(0.5*Fmax)))
Nhalf=subdata$ResDensity[4]

### calculate parameter estimates
h.est=1/Fmax
a.est=Fmax/Nhalf

### sample the estimates
a = runif(1000, min = a.est - abs(a.est*0.1), max = a.est + abs(a.est*0.1))
h = runif(1000, min = h.est - abs(h.est*0.1), max = h.est + abs(h.est*0.1))
params = cbind(a, h)

## fitting
results <- matrix(ncol = 2) #write a results table
colnames(results) <- c("param_row", "AIC")
for(ah.values in 1:nrow(params)) {
  # fit
  HollT2.fit <- nlsLM(N_TraitValue ~ Holl.type2(ResDensity, a, h), data = subdata, start = params[ah.values,])
  
  # calculate AIC for these starting params
  n = nrow(subdata)
  pHollT2 = length(coef(HollT2.fit))
  RSS_HollT2 = sum(residuals(HollT2.fit)^2)
  AIC = n + 2 + n*log(2*pi/n)+n*log(RSS_HollT2)+2*pHollT2
  
  # write results
  results <- rbind(results, c(ah.values, AIC))
}

results <- results[-1,] #append to results
best_AIC <- min(results[,2])
row_best_params <- which(results[,2] %in% best_AIC)

# plot it
# HollT2.fit <- nlsLM(N_TraitValue ~ Holl.type2(ResDensity, a, h), data = subdata, start = params[row_best_params,])
# testDens <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (abs(max(subdata$ResDensity))-abs(min(subdata$ResDensity)))/500)
# Pred.HollT2 <- Holl.type2(testDens, coef(HollT2.fit)["a"], coef(HollT2.fit)["h"])
# 
# sub_df <- data.frame(testDens, Pred.HollT2)
# names(sub_df) <- c("ResDensity", "N_TraitValue")
# 
# p <- ggplot(subdata, aes(x=ResDensity, y=N_TraitValue)) +
#   geom_point() +
#   geom_line(data=sub_df, aes(x=ResDensity, y=N_TraitValue))
# p

# comparing models
n = nrow(subdata)
TSS_data = sum((subdata$N_TraitValue - mean(subdata$N_TraitValue))^2)
RSS_lm = sum(residuals.lm(lm1fit)^2)
RSS_lm2 = sum(residuals.lm(lm2fit)^2)
RSS_lm3 = sum(residuals.lm(lm3fit)^2)
RSS_HollT2 = sum(residuals.lm(HollT2.fit)^2)

plm = length(coef(lm1fit))
plm2 = length(coef(lm2fit))
plm3 = length(coef(lm3fit))
pHollT2 = length(coef(HollT2.fit))

Rsq_lm = summary(lm1fit)[["r.squared"]]
Rsq_lm2 = summary(lm2fit)[["r.squared"]] #using R-squared
Rsq_lm3 = summary(lm3fit)[["r.squared"]]
Rsq_high <- min(c(Rsq_lm, Rsq_lm2, Rsq_lm3))
Rsq_HollT2 = 1 - (RSS_HollT2/TSS_data)
if (Rsq_high==Rsq_lm) best_Rsq = "lm"
if (Rsq_high==Rsq_lm2) best_Rsq = "lm2"
if (Rsq_high==Rsq_lm3) best_Rsq = "lm3"
if (Rsq_high==Rsq_lm3) best_Rsq = "HollT2"

AIC_lm <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm)+2*plm
AIC_lm2 <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm2)+2*plm2 #using AIC
AIC_lm3 <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm3)+2*plm3
AIC_HollT2 <- n + 2 + n*log(2*pi/n)+n*log(RSS_HollT2)+2*pHollT2
AIC_low <- min(c(AIC_lm2, AIC_lm3))
if (AIC_low==AIC_lm) best_AIC = "lm"
if (AIC_low==AIC_lm2) best_AIC = "lm2"
if (AIC_low==AIC_lm3) best_AIC = "lm3"
if (AIC_low==AIC_HollT2) best_AIC = "HollT2"
  
BIC_lm <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm)+plm*log(n)
BIC_lm2 <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm2)+plm2*log(n) #using BIC
BIC_lm3 <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm3)+plm3*log(n)
BIC_HollT2 <- n + 2 + n*log(2*pi/n)+n*log(RSS_HollT2)+pHollT2*log(n)
BIC_low <- min(c(BIC_lm2, BIC_lm3))
if (BIC_low==BIC_lm) best_BIC = "lm"
if (BIC_low==BIC_lm2) best_BIC = "lm2"
if (BIC_low==BIC_lm3) best_BIC = "lm3"
if (BIC_low==BIC_HollT2) best_BIC = "HollT2"

# results
if (best_AIC==best_BIC & best_AIC==best_Rsq) {
    results_lms <- rbind(results_lms, c(iden, 1, best_AIC)) #all information criterion agree: results_lms[,2]=1
  } else results_lms <- rbind(results_lms, c(iden, 0, best_AIC)) #if they don't agree: results_lms[,2]=0 and you choose AIC

# output results
results_lms <- results_lms[-1,]
write.csv(results_lms, "../Results/lm_results.csv", row.names = FALSE)
# nrow(results_lms)
# results_lms[,2] <- as.integer(results_lms[,2])
# sum(results_lms[,2]) 
# sum(results_lms$Best_lm=="lm2")

###################
# plot the models #
###################

#dependencies
require(ggplot2)

#plotting
pdf(file = paste("../Results/all_models.pdf", sep="")) #write pdf
for (iden in unique(data$ID)) {
  #iden="39911"
  subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read subset
  
  p <- ggplot(subdata, aes(x=ResDensity, y=N_TraitValue)) +
    geom_point() +
    labs(x="Resource Density", y="Individual Trait Value", title = paste("ID = ", iden, sep="")) +
    theme(plot.title = element_text(hjust = 0.5)) +
    geom_smooth(method = lm, formula = y ~ x, se=FALSE, colour="green") +
    geom_smooth(method = lm, formula = y ~ poly(x, degree = 2, raw = TRUE), se=FALSE, colour = "blue") +
    geom_smooth(method = lm, formula = y ~ poly(x, degree = 3, raw = TRUE), se=FALSE, colour = "red")
  
  print(p)
  
}
graphics.off() #save plots in pdf
