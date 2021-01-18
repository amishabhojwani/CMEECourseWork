# set start
# setwd("~/Documents/CMEECourseWork/CMEEMiniproject/Code")

#dependencies
require(minpack.lm)

# load data
data <- read.csv("../Data/CRat.csv")

print("Fitting three models per subset of data: quadratic, cubic and Holling Type II. For the last one we need to obtain optimal parameter estimates first. This will take about 7 minutes.")

# define function for the Holling type II model
Holl.type2 <- function(x, a, h) {
  (a*x)/(1+a*h*x)
}

AICc <- function(n, RSS, p) {
  n + 2 + n*log(2*pi/n)+n*log(RSS)+2*p
}

BIC_calc <- function(n, RSS, p) {
  n + 2 + n*log(2*pi/n)+n*log(RSS)+p*log(n)
}

results_models <- matrix(ncol = 3) #write results table for best model per subset
colnames(results_models) <- c("ID", "Agree", "Best_lm")

summary_results_quadratic <- matrix(ncol = 4)
colnames(summary_results_quadratic) <- c("ID", "R2", "AIC", "BIC")

summary_results_cubic <- matrix(ncol = 4)
colnames(summary_results_cubic) <- c("ID", "R2", "AIC", "BIC")

summary_results_Holl2 <- matrix(ncol = 4)
colnames(summary_results_Holl2) <- c("ID", "R2", "AIC", "BIC")

# fit all the models
for (iden in unique(data$ID)) {
  
  # load subsets of data and sample parameters for each data subset
  subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))
  params <- read.csv(paste("../Results/sample_params/subset_",iden, "_sample_params.csv", sep = ""))
  
  # fit quadratic model
  try(lm2fit <- lm(N_TraitValue ~ poly(x=ResDensity, degree=2, raw = TRUE), data=subdata), silent = TRUE)
  
  # fit cubic model
  try(lm3fit <- lm(N_TraitValue ~ poly(x=ResDensity, degree=3, raw = TRUE), data=subdata), silent = TRUE)
  
  # fit the holling type II model for every sampled pair of parameters
  results_Holl2 <- matrix(ncol = 2) #write a results matrix for each subset, to be able to pick out the best fit
  colnames(results_Holl2) <- c("param_row", "AIC")
  
  loop_counter <- 0
  for(ah.values in 1:nrow(params)) {
    # fit
    try({HollT2.fit <- nlsLM(N_TraitValue ~ Holl.type2(ResDensity, a, h), data = subdata, start = params[ah.values,], lower = c(0, 0))}, silent = TRUE)
    
    # calculate AIC for these starting params
    n = nrow(subdata) #sample size
    pHollT2 = length(coef(HollT2.fit)) #number of parameters
    RSS_HollT2 = sum(residuals(HollT2.fit)^2) #residual sum of squares
    AIC = n + 2 + n*log(2*pi/n)+n*log(RSS_HollT2)+2*pHollT2
    
    # write results
    results_Holl2 <- rbind(results_Holl2, c(ah.values, AIC))
    loop_counter <- loop_counter + 1
  }
  
  # output results
  results_Holl2 <- results_Holl2[-1,] #remove first row - superfluous
  write.csv(results_Holl2, file = paste("../Results/param_selection/", iden, "_paramAICs.csv"), row.names = FALSE)
  best_param_AIC <- min(results_Holl2[,2]) #find the min AIC to locate the best set of parameters
  row_best_params <- which(results_Holl2[,2] %in% best_param_AIC)
  
  # the final fit for the Holling type II model and output a data frame with which to plot
  try({HollT2.fit <- nlsLM(N_TraitValue ~ Holl.type2(ResDensity, a, h), data = subdata, start = params[row_best_params[1],], lower = c(0, 0))}, silent=TRUE) 
  testDens <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (abs(max(subdata$ResDensity))-abs(min(subdata$ResDensity)))/500)
  Pred.HollT2 <- Holl.type2(testDens, coef(HollT2.fit)["a"], coef(HollT2.fit)["h"])

  sub_df <- data.frame(testDens, Pred.HollT2)
  names(sub_df) <- c("ResDensity", "N_TraitValue")
  
  write.csv(sub_df, paste("../Results/HollT2_plotting_dfs/HollT2_dfplot_subset_", iden, sep=""), row.names = FALSE) #plotting df
  
  # compare the models and output to results table
  n = nrow(subdata)
  TSS_data = sum((subdata$N_TraitValue - mean(subdata$N_TraitValue))^2) #total sum of squares in data
  RSS_lm2 = sum(residuals.lm(lm2fit)^2) #residual sums of squares for each model that has been fitted
  RSS_lm3 = sum(residuals.lm(lm3fit)^2)
  RSS_HollT2 = sum(residuals(HollT2.fit)^2)
  
  plm2 = length(coef(lm2fit)) #number of coefficients for each model fitted
  plm3 = length(coef(lm3fit))
  pHollT2 = length(coef(HollT2.fit))
  
  Rsq_lm2 = summary(lm2fit)[["r.squared"]] #comparing models using R squared
  Rsq_lm3 = summary(lm3fit)[["r.squared"]]
  Rsq_HollT2 = 1 - (RSS_HollT2/TSS_data)
  Rsq_high <- max(Rsq_lm2, Rsq_lm3, Rsq_HollT2)
  
  if (Rsq_high==Rsq_lm2) best_Rsq = "lm2" #which model has the best R2?
  if (Rsq_high==Rsq_lm3) best_Rsq = "lm3"
  if (Rsq_high==Rsq_HollT2) best_Rsq = "HollT2"
  
  AIC_lm2 <- AICc(n, RSS_lm2, plm2) #comparing models using AICc
  AIC_lm3 <- AICc(n, RSS_lm3, plm3)
  AIC_HollT2 <- AICc(n, RSS_HollT2, pHollT2)
  AIC_low <- min(AIC_lm2, AIC_lm3, AIC_HollT2)
  
  if (AIC_low==AIC_lm2) best_AIC = "lm2" #which model has the best AICc?
  if (AIC_low==AIC_lm3) best_AIC = "lm3"
  if (AIC_low==AIC_HollT2) best_AIC = "HollT2"
  
  BIC_lm2 <- BIC_calc(n, RSS_lm2, plm2) #comparing models using BIC
  BIC_lm3 <- BIC_calc(n, RSS_lm3, plm3)
  BIC_HollT2 <- BIC_calc(n, RSS_HollT2, pHollT2)
  BIC_low <- min(BIC_lm2, BIC_lm3, BIC_HollT2)
  
  if (BIC_low==BIC_lm2) best_BIC = "lm2" #which model has the best BIC?
  if (BIC_low==BIC_lm3) best_BIC = "lm3"
  if (BIC_low==BIC_HollT2) best_BIC = "HollT2"
  
  # results for all IDs - #which model has the best model selection criteria and R2?
  if (best_AIC==best_BIC & best_AIC==best_Rsq) {
    results_models <- rbind(results_models, c(iden, 1, best_AIC)) #all information criterion agree: results_models[,2]=1
  } else results_models <- rbind(results_models, c(iden, 0, best_AIC)) #if they don't agree: results_models[,2]=0 and you choose AIC as the information criterion

  summary_results_quadratic <- rbind(summary_results_quadratic, c(iden, Rsq_lm2, AIC_lm2, BIC_lm2)) #summary of results for quadratic models
  summary_results_cubic <- rbind(summary_results_cubic, c(iden, Rsq_lm3, AIC_lm3, BIC_lm3)) #summary of results for cubic models
  summary_results_Holl2 <- rbind(summary_results_Holl2, c(iden, Rsq_HollT2, AIC_HollT2, BIC_HollT2)) #summary of results for Holling models
  
}

if (nrow(results_models)!=309) print("Failed to compare the models for all the subsets of data")
  
# output results
results_models <- results_models[-1,] #delete superfluous first row
write.csv(results_models, "../Results/modelfitting_results.csv", row.names = FALSE)

summary_results_quadratic <- summary_results_quadratic[-1,]
write.csv(summary_results_quadratic, "../Results/summary_results_quadratic.csv", row.names = FALSE)

summary_results_cubic <- summary_results_cubic[-1,]
write.csv(summary_results_cubic, "../Results/summary_results_cubic.csv", row.names = FALSE)

summary_results_Holl2 <- summary_results_Holl2[-1,]
write.csv(summary_results_Holl2, "../Results/summary_results_Holl2.csv", row.names = FALSE)

print("Done! Output 4 results tables in ../Results.")