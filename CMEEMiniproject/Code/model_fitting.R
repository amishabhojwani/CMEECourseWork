# set start
# setwd("~/Documents/CMEECourseWork/CMEEMiniproject/Code")

# load data
data <- read.csv("../Data/CRat.csv")

#############################
# comparing lms graphically #
#############################
for (iden in unique(data$ID)) {
  
  #load data subset
  subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read subset
  
  #quadratic model
  lm2fit <- lm(log(N_TraitValue) ~ poly(x=log(ResDensity), degree=2, raw = TRUE), data=subdata) #fit lm2
  testDens <- seq(min(subdata$ResDensity), max(subdata$ResDensity), 0.5)
  predlm2fit <- predict.lm(lm2fit) #predict values from lm2
  
  #cubic model
  lm3fit <- lm(log(N_TraitValue) ~ poly(x=log(ResDensity), degree=3, raw = TRUE), data=subdata) #fit lm3
  predlm3fit <- predict.lm(lm3fit) #predict values from lm3
  
  #plot them
  pdf(file = paste("../Results/lm_compare_plots/subset_", iden, "_plot.pdf", sep="")) #write pdf
  plot(log(subdata$ResDensity), log(subdata$N_TraitValue), xlab="log Resource Density", ylab="log Trait Value per Individual")
  lines(log(subdata$ResDensity), predlm2fit, col = "green") #plot predicted quadratic lm values against data
  lines(log(subdata$ResDensity), predlm3fit, col = "blue") #plot predicted cubic lm values against data
  legend("topleft", legend=c("Quadratic lm", "Cubic lm"), col=c("green", "blue"), lty=1, cex=0.8)
  graphics.off() #save plot in pdf
  
}

#########################################
# plot each data subset and write a pdf #
#########################################

# for (iden in unique(data$ID)) {
#   subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read subset
#   pdf(file = paste("../Results/subset_plots/subset_", iden, "_plot.pdf", sep="")) #write pdf
#   plot(log(subdata$ResDensity), log(subdata$N_TraitValue), xlab="log Resource Density", ylab="log Trait Value per Individual")
#   graphics.off()
# }

# Test with:
# iden="40078"
# subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))
# pdf(file = paste("../Results/subset_plots/subset_", iden, "_plot.pdf", sep=""))
# plot(log(subdata$ResDensity), log(subdata$N_TraitValue), xlab="log Resource Density", ylab="log Trait Value per Individual")
# graphics.off()

#####################################################
# compute and plot quadratic lm to each data subset #
#####################################################

# for (iden in unique(data$ID)) {
#   subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read subset
#   lmfit <- lm(log(N_TraitValue) ~ poly(log(ResDensity),2), data=subdata) #fit lm
#   predlmfit <- predict.lm(lmfit) #predict values from lm
#   pdf(file = paste("../Results/lm2_plots/subset_", iden, "_plot.pdf", sep="")) #write pdf
#   plot(log(subdata$ResDensity), log(subdata$N_TraitValue), xlab="log Resource Density", ylab="log Trait Value per Individual") 
#   lines(log(subdata$ResDensity), predlmfit) #plot predicted lm values against data
#   graphics.off() #save plot in pdf
# }

# Test with:
# iden="39901"
# subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read subset
# lmfit <- lm(log(N_TraitValue) ~ poly(log(ResDensity),2), data=subdata)
# predlmfit <- predict.lm(lmfit)
# pdf(file = paste("../Results/subset_plots/subset_", iden, "_plot.pdf", sep="")) #write pdf
# plot(log(subdata$ResDensity), log(subdata$N_TraitValue), xlab="log Resource Density", ylab="log Trait Value per Individual")
# lines(log(subdata$ResDensity), predlmfit)
# graphics.off()

#################################################
# compute and plot cubic lm to each data subset #
#################################################

# for (iden in unique(data$ID)) {
#   subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read subset
#   lmfit <- lm(log(N_TraitValue) ~ poly(log(ResDensity), 3, raw = TRUE), data=subdata) #fit lm
#   predlmfit <- predict.lm(lmfit) #predict values from lm
#   pdf(file = paste("../Results/lm3_plots/subset_", iden, "_plot.pdf", sep="")) #write pdf
#   plot(log(subdata$ResDensity), log(subdata$N_TraitValue), xlab="log Resource Density", ylab="log Trait Value per Individual")
#   lines(log(subdata$ResDensity), predlmfit) #plot predicted lm values against data
#   graphics.off() #save plot in pdf
# }

#########################
# Holling Type II model #
#########################

# define function
Holl.type2 <- function(x, a, h) {
  return((a*x)/(1+h*a*x))
}

# test a fitting process
params <- read.csv("../Results/sample_params/subset_40095_sample_params.csv")
loop_counter <- 0

for (ah.val in 1:nrow(params)) {
    try(HollT2.fit <- nlsLM(log(ResDensity) ~ Holl.type2(log(N_TraitValue), a, h), data = subdata, start = list(params[ah.val]), lower = c(0,0)), silent = TRUE)
    testDens <- seq(min(subdata$ResDensity), max(subdata$ResDensity), 0.5)
    Pred.HollT2 <- Holl.type2(testDens, coef(HollT2.fit)["a"], coef(HollT2.fit)["h"])
    
    loop_counter <- loop_counter + 1
    jpeg(paste("../Results/testing/subset_", iden, "_", loop_counter, sep=""))
    plot(log(subdata$ResDensity), log(subdata$N_TraitValue))
    lines(testDens, Pred.HollT2, col = "blue", lwd = 2.5)
    graphics.off()
}

# subset
iden="40095"
subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))

#test fit
HollT2.fit <- nlsLM(log(ResDensity) ~ Holl.type2(log(N_TraitValue), a, h), data = subdata, start = list(a = -1, h = 0.33))
testDens <- seq(min(subdata$ResDensity), max(subdata$ResDensity), 0.5)
Pred.HollT2 <- Holl.type2(testDens, coef(HollT2.fit)["a"], coef(HollT2.fit)["h"])

# plot the test fit
plot(log(subdata$ResDensity), log(subdata$N_TraitValue))
lines(testDens, Pred.HollT2, col = "blue", lwd = 2.5)

