# set start
# setwd("~/Documents/CMEECourseWork/CMEEMiniproject/Code")

#dependencies
require(minpack.lm)
require(ggplot2)

# load data
data <- read.csv("../Data/CRat.csv")

#########################
# Holling Type II model #
#########################

# define function for the model
Holl.type2 <- function(x, a, h) {
  (a*x)/(1+h*a*x)
}

# test a fitting process
####AIC values dont change for different fits considering different starting params
for (iden in unique(data$ID)) {
  iden="39953"
  loop_counter <- 0
  
  #iden = "39840"
  #try({
  
  # load subsets of data and sample parameters for each data subset
  subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))
  params <- read.csv(paste("../Results/sample_params/subset_",iden, "_sample_params.csv", sep = ""))
  
  results <- matrix(ncol = 2) #write a results matrix for each subset
  colnames(results) <- c("param_row", "AIC")
  
  for (ah.val in 1:nrow(params)) { #fit for every sampled pair of parameters
    try(HollT2.fit <- nlsLM(ResDensity ~ Holl.type2(N_TraitValue, a, h), data = subdata, start = params[ah.val,]), silent = TRUE) #fit the model
    
    # calculate AIC for these starting params
    RSS_HollT2 = sum(residuals(HollT2.fit)^2)
    n = nrow(subdata)
    pHollT2 = length(coef(HollT2.fit))
    AIC = n + 2 + n*log(2*pi/n)+n*log(RSS_HollT2)+2*pHollT2
    
    # write results
    results <- rbind(results, c(ah.val, AIC))
    #browser()
    loop_counter <- loop_counter + 1
    
    # plot the fit for every starting parameter pair for every iden
    # testDens <- seq(min(subdata$ResDensity), max(subdata$ResDensity), 0.5)
    # Pred.HollT2 <- Holl.type2(testDens, coef(HollT2.fit)["a"], coef(HollT2.fit)["h"])
    # jpeg(paste("../Results/testing/subset_", iden, "_", loop_counter, sep=""))
    # plot(log(subdata$ResDensity), log(subdata$N_TraitValue))
    # lines(testDens, Pred.HollT2, col = "blue", lwd = 2.5)
    # graphics.off()
  }
  
  results <- results[-1,]
  best_AIC <- min(results[,2])
  row_best_params <- which(results[,2] %in% best_AIC)
  
  # plot model with starting parameters that gave the best AIC
  p.upper=params[row_best_params,]*1.1
  p.lower=params[row_best_params,]*0.9
  HollT2.fit <- nlsLM(ResDensity ~ Holl.type2(N_TraitValue, a, h), data = subdata, start = params[row_best_params,], lower=c(p.lower[[1]], p.lower[[2]]), upper=c(p.upper[[1]], p.upper[[2]]))
  testDens <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (abs(max(subdata$ResDensity))-abs(min(subdata$ResDensity)))/500)
  Pred.HollT2 <- Holl.type2(testDens, coef(HollT2.fit)["a"], coef(HollT2.fit)["h"])
  sub_df <- data.frame(testDens, Pred.HollT2)
  names(sub_df) <- c("ResDensity", "N_TraitValue")
  jpeg(paste("../Results/testing/subset_", iden, "_loop_", loop_counter, ".jpeg", sep="")) #save in jpeg for now
  p <- ggplot(subdata, aes(x=ResDensity, y=N_TraitValue)) +
    geom_point() +
    geom_line(data=sub_df, aes(x=ResDensity, y=N_TraitValue))
  p
  graphics.off()
  # 
  #write.csv(results, paste("../Results/HollT2_AICs/subset_", iden, "_HollT2_AIC.csv", sep=""), row.names = FALSE)
  #}, silent = FALSE) #end try
}

# subset
iden="40010"
subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))
params <- read.csv(paste("../Results/sample_params/subset_",iden, "_sample_params.csv", sep = ""))

#test fit
for (ah.val in 1:nrow(params)) {
HollT2.fit <- nlsLM(ResDensity ~ Holl.type2(N_TraitValue, a, h), data = subdata, start = list(a=0.1, h=0.001))
testDens <- seq(min(subdata$ResDensity), max(subdata$ResDensity), (abs(max(subdata$ResDensity))-abs(min(subdata$ResDensity)))/500)
Pred.HollT2 <- Holl.type2(x=testDens, a=coef(HollT2.fit)["a"], h=coef(HollT2.fit)["h"])

# plot the test fit
plot(subdata$ResDensity, subdata$N_TraitValue)
lines(testDens, Pred.HollT2, col = "blue", lwd = 2.5)
}
