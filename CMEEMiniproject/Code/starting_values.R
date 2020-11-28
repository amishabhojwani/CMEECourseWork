# set start
# setwd("~/Documents/CMEECourseWork/CMEEMiniproject/Code")

# load data
data <- read.csv("../Data/CRat.csv")

######################################################
# test starting value estimates with one data subset #
######################################################

# # subset data
# iden = "39965"
# subdata <- subset(data, data$ID==iden)
# 
# # splitting the curve to get starting values for a and h
# 
# # we will compare to possible values for a, one will be with a wider range of x values and one with a smaller
# # first fit a line through a whole dataset (wide range)
# lmfit <- lm(log(N_TraitValue) ~ log(ResDensity), data=subdata) #fit lm
# summlm <- summary(lmfit)
# 
# # now fit a line through the predicted growth phase (small range)
# growth.subdata = subset(subdata, subdata$ResDensity < mean(range(subdata$ResDensity)))
# lm1fit <- lm(log(N_TraitValue) ~ log(ResDensity), data=growth.subdata) #fit lm1
# summlm1 <- summary(lm1fit)
# 
# # compute the best fit (pick which range better represents growth in the curve)
# if (summary(lmfit)[["adj.r.squared"]] > summary(lm1fit)[["adj.r.squared"]]) {
#   a.est = coef(lmfit)[[2]]
# } else a.est = coef(lm1fit)[[2]]
# 
# # predict values from both fits to plot - visualise the best fit
# # predlmfit <- predict.lm(lmfit) #predict values from lm
# # predlm1fit <- predict.lm(lm1fit) #predict values from lm1
# 
# # # plot them both to compare ## they are quite different - measure this with R2
# # plot(log(subdata$ResDensity), log(subdata$N_TraitValue), xlab="log Resource Density", ylab="log Trait Value per Individual")
# # lines(log(subdata$ResDensity), predlmfit, col = "green")
# # lines(log(growth.subdata$ResDensity), predlm1fit, col = "blue")
# # legend("topleft", legend=c("all of the data", "growth phase"), col=c("green", "blue"), lty=1, cex=0.8)
# 
# # from this analysis we get:
# a.est #a
# # from the max of the data we get:
# h.est = 1/max(log(subdata$N_TraitValue)) #h
# 
# # now we introduce variation into these parameters:
# set.seed(1234)
# a.samples = rnorm(100, a.est, 1000)
# h.samples = rnorm(100, h.est, 1000)
# sample.param = cbind(a.samples, h.samples)
# 
# # Now we try an NLLS fit for each pairwise combination:
# require(minpack.lm)
# # define function
# Holl.type2 <- function(x, a, h) {
#   (a*x)/(1+h*a*x)
# }
# 
# # test a fitting process:
# HollT2.fit <- nlsLM(log(ResDensity) ~ Holl.type2(log(N_TraitValue), a, h), data = subdata, start = list(a=sample.param[[1,1]], h =sample.param[[1,2]]))
# testDens <- seq(min(log(subdata$ResDensity)), max(log(subdata$ResDensity)), 0.1)
# Pred.HollT2 <- Holl.type2(testDens, coef(HollT2.fit)["a"], coef(HollT2.fit)["h"])
# 
# # plot the test fit
# plot(log(subdata$ResDensity), log(subdata$N_TraitValue))
# lines(testDens, Pred.HollT2, col = "blue", lwd = 2.5)

######################################
# get sample params for every subset #
######################################

success_counter <- c()

for (iden in unique(data$ID)) {
  try({ #trying everything even if it gives an error, 102 IDs now don't have a list of sample params
  subdata <- subset(data, data$ID==iden)
  
  # splitting the curve to get starting values for a and h
  # first fit a line through a whole dataset (wide range)
  lmfit <- lm(log(N_TraitValue) ~ log(ResDensity), data=subdata) #fit lm
  
  # now fit a line through the predicted growth phase (small range)
  growth.subdata = subset(subdata, subdata$ResDensity < mean(range(subdata$ResDensity)))
  ##### if (nrow(growth.subdata) < 3) {
  ##### next #avoids some empty lm1fits where n is too small
  ##### } #not needed if using try - but of course then don't know what type of errors we are getting
  lm1fit <- lm(log(N_TraitValue) ~ log(ResDensity), data=growth.subdata) #fit lm1
  
  # code for the best fit (pick which range better represents growth in the curve) and estimate params
  if (summary(lmfit)[["adj.r.squared"]] > summary(lm1fit)[["adj.r.squared"]]) {
    a.est = coef(lmfit)[[2]]
  } else a.est = coef(lm1fit)[[2]] #a
  
  h.est = 1/max(log(subdata$N_TraitValue)) #h
  
  # introduce variation into these parameters through random sampling
  set.seed(1234)
  a = rnorm(100, a.est, 0.5*a.est)
  h = rnorm(100, h.est, 0.5*h.est)
  sample.params = cbind(a, h)
  
  write.csv(sample.params, paste("../Results/sample_params/subset_", iden, "_sample_params.csv", sep=""))
  success_counter <- append(success_counter, iden)
  browser()
  
  }, silent = TRUE) #ending try expression
}

# check which subsets have failed
IDs <- unique(data$ID)
failed_loops <- setdiff(IDs, success_counter)
