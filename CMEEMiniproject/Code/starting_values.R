# set start
# setwd("~/Documents/CMEECourseWork/CMEEMiniproject/Code")

# load data
data <- read.csv("../Data/CRat.csv")

######################################
# get sample params for every subset #
######################################

success_counter <- c()

for (iden in unique(data$ID)) {
  #load subset
  #iden="40010"
  subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))
  
  # splitting the curve to get starting values for a and h
  # first fit a line through a whole dataset (wide range)
  lmfit <- lm(N_TraitValue ~ ResDensity, data=subdata) #fit lm
  
  # now fit a line through the predicted growth phase (small range)
  growth.subdata = subset(subdata, subdata$ResDensity < mean(range(subdata$ResDensity)))
  lm1fit <- lm(N_TraitValue ~ ResDensity, data=growth.subdata) #fit lm1
  
  # see how it fits
  p <- ggplot(subdata, aes(x=ResDensity, y=N_TraitValue)) +
    geom_point() +
    geom_smooth(method = lm, formula = y ~ x, se=FALSE, colour = "blue") +
    geom_smooth(data = growth.subdata, method = lm, formula = y ~ x, se=FALSE, colour = "blue")
  p
  
  # code for the best fit (pick which range better represents growth in the curve) and estimate params
  if (is.na(summary(lmfit)[["adj.r.squared"]]) | is.na(summary(lm1fit)[["adj.r.squared"]])) {
    next
  }
  
  if (summary(lmfit)[["adj.r.squared"]] > summary(lm1fit)[["adj.r.squared"]]) {
    a.est = coef(lmfit)[[2]]
  } else a.est = coef(lm1fit)[[2]] #a
  
  h.est = 1/max(subdata$N_TraitValue) #h
  
  if (a.est-abs(a.est*0.5)<0 | h.est-abs(h.est*0.5)<0) {
    next
  }
  
  # introduce variation into these parameters through random sampling
  # set.seed(1234)
  a = runif(1000, min = a.est - abs(a.est*0.5), max = a.est + abs(a.est*0.5))
  h = runif(1000, min = h.est - abs(h.est*0.5), max = h.est + abs(h.est*0.5))
  sample.params = cbind(a, h)
  
  write.csv(sample.params, paste("../Results/sample_params/subset_", iden, "_sample_params.csv", sep=""), row.names = FALSE)
  success_counter <- append(success_counter, iden)
  
}

# check which subsets have failed
IDs <- unique(data$ID)
failed_loops <- setdiff(IDs, success_counter)
