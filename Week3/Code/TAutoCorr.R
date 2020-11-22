#set start
#setwd("~/Documents/CMEECourseWork/Week3/Code")

#load packages
require(ggplot2)

#load data
load("../Data/KeyWestAnnualMeanTemperature.RData")

#save ast plot
pdf("../Results/ast_plot.pdf")
ats_p <- ggplot(ats, aes(Year, Temp)) +
  geom_point(size=1) +
  geom_smooth(method = lm)
ats_p
graphics.off()

### autocorrelation
##observed correlation
ats <- as.matrix(ats)
Nyrs <- length(ats[,1])

#SHORT METHOD: correlation for successive timepoints
obs_corr <- cor(ats[1:Nyrs-1,2], ats[2:Nyrs,2])

#LONG METHOD: create two vectors where each element in a row is one timestep apart
#temp_t0 <- ats[1:Nyrs-1,2]
#temp_t1 <- ats[2:Nyrs,2]
#correlate the vectors
#obs_corr <- cor(temp_t0, temp_t1)

##random correlations
ran_corr <- c()
iter_counter <- 0
#repeat the correlation for successive timepoints for 10000 different samples
repeat {
  iter_counter <- iter_counter + 1
  random_T <- sample(ats[,2], 100)
  corr <- cor(random_T[1:Nyrs-1], random_T[2:Nyrs])
  ran_corr <- c(ran_corr, corr) #a lot of them are negative
  if (iter_counter==10000) { 
    break 
  }
}

#save density plot of random correlations
ran_corr <- as.data.frame(ran_corr)
pdf("../Results/ast_random_corr.pdf")
ran_corr_p <- ggplot(ran_corr, aes(x=ran_corr)) +
  geom_density() +
  geom_vline(xintercept = obs_corr, colour = "blue")
print(ran_corr_p)
graphics.off()

#calculate pvalue
pvalue <- sum(ran_corr>obs_corr)/10000 


