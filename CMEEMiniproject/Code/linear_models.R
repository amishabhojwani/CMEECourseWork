#################
# prep the data #
#################

# load data
data <- read.csv("../Data/CRat.csv")

# create data subsets for each ID (iden=identity)
for (iden in unique(data$ID)) {
  subdata <- subset(data, data$ID == iden)
  write.csv(subdata, paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))
}

#################
# model fitting #
#################

results_lms <- matrix(ncol = 3) #write results table
colnames(results_lms) <- c("ID", "Agree", "Best_lm")
for (iden in unique(data$ID)) {
  # load data subset
  #iden="40008"
  subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read subset
  
  #fit linear model
  try(lm1fit <- lm(N_TraitValue ~ ResDensity, data=subdata), silent=TRUE)
  
  # fit quadratic model
  try(lm2fit <- lm(N_TraitValue ~ poly(x=ResDensity, degree=2, raw = TRUE), data=subdata), silent = TRUE)
  
  # fit cubic model
  try(lm3fit <- lm(N_TraitValue ~ poly(x=ResDensity, degree=3, raw = TRUE), data=subdata), silent = TRUE)
  
  # comparing models
  n = nrow(subdata)
  RSS_lm = sum(residuals.lm(lm1fit)^2)
  RSS_lm2 = sum(residuals.lm(lm2fit)^2)
  RSS_lm3 = sum(residuals.lm(lm3fit)^2)
  # TSS_data = sum((subdata$N_TraitValue - mean(subdata$N_TraitValue))^2)
  plm = length(coef(lm1fit))
  plm2 = length(coef(lm2fit))
  plm3 = length(coef(lm3fit))
  
  Rsq_lm = summary(lm1fit)[["r.squared"]]
  Rsq_lm2 = summary(lm2fit)[["r.squared"]] #using R-squared
  Rsq_lm3 = summary(lm3fit)[["r.squared"]]
  Rsq_high <- min(c(Rsq_lm, Rsq_lm2, Rsq_lm3))
  if (Rsq_high==Rsq_lm) best_Rsq = "lm"
  if (Rsq_high==Rsq_lm2) best_Rsq = "lm2"
  if (Rsq_high==Rsq_lm3) best_Rsq = "lm3"

  # Rsq_lm2 = 1 - (RSS_lm2/TSS_data) #using R-squared (not adjusted) ##use this code for nlls
  # Rsq_lm3 = 1 - (RSS_lm3/TSS_data)
  # Rsq_high <- min(c(Rsq_lm2, Rsq_lm3))
  # if (Rsq_high==Rsq_lm2) { #pick the best model according to AIC
  #   best_Rsq = "lm2"
  # } else best_Rsq = "lm3"
  
  AIC_lm <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm)+2*plm
  AIC_lm2 <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm2)+2*plm2 #using AIC
  AIC_lm3 <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm3)+2*plm3
  AIC_low <- min(c(AIC_lm2, AIC_lm3))
  if (AIC_low==AIC_lm) best_AIC = "lm"
  if (AIC_low==AIC_lm2) best_AIC = "lm2"
  if (AIC_low==AIC_lm3) best_AIC = "lm3"
  
  BIC_lm <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm)+plm*log(n)
  BIC_lm2 <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm2)+plm2*log(n) #using BIC
  BIC_lm3 <- n + 2 + n*log(2*pi/n)+n*log(RSS_lm3)+plm3*log(n)
  BIC_low <- min(c(BIC_lm2, BIC_lm3))
  if (BIC_low==BIC_lm) best_BIC = "lm"
  if (BIC_low==BIC_lm2) best_BIC = "lm2"
  if (BIC_low==BIC_lm3) best_BIC = "lm3"
  
  # results
  if (best_AIC==best_BIC & best_AIC==best_Rsq) {
    results_lms <- rbind(results_lms, c(iden, 1, best_AIC)) #all information criterion agree: results_lms[,2]=1
  } else results_lms <- rbind(results_lms, c(iden, 0, best_AIC)) #if they don't agree: results_lms[,2]=0 and you choose AIC

}


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
pdf(file = paste("../Results/lms_compare.pdf", sep="")) #write pdf
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
