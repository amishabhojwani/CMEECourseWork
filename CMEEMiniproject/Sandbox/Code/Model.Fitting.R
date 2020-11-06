#housekeeping
setwd("~/Documents/CMEECourseWork/CMEEMiniproject/Sandbox/Code")
rm(list = ls())
graphics.off()

#dependencies
require("minpack.lm")
require("minpack.lm") # for Levenberg-Marquardt nlls fitting
library("ggplot2")

################# Model fitting in Ecology and Evolution ###################

################################################
# Model fitting using Non-linear least squares #
################################################

##########################
## Traits as an example ##
##########################

####################################
### Allometric scaling of traits ###
####################################

#create a function object for the power law model
powMod <- function(x, a, b) {
  return(a * x^b)
} 

MyData <- read.csv("../Data/GenomeSize.csv")

#we are interested in Anisoptera (dragonflies) and Zygoptera (damselflies)
Data2Fit <- subset(MyData, Suborder == "Anisoptera")
Data2Fit <- Data2Fit[!is.na(Data2Fit$TotalLength),] # remove NA's
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight) #used base package plot

# could use ggplot
# ggplot(Data2Fit, aes(x = TotalLength, y = BodyWeight)) + 
#   geom_point(size = (3),color="red") + theme_bw() + 
#   labs(y="Body mass (mg)", x = "Wing length (mm)")

#fit the data using nlls
PowFit <- nlsLM(BodyWeight ~ powMod(TotalLength, a, b), data = Data2Fit, start = list(a = .1, b = .1))
summary(PowFit) #shows coefficients as intercepts, can also get as shown below
#coef(PowFit)["a"]
#coef(PowFit)["b"]

#make a vector for x axis
Lengths <- seq(min(Data2Fit$TotalLength),max(Data2Fit$TotalLength),len=200)

#calculate predicted line
Predic2PlotPow <- powMod(Lengths,coef(PowFit)["a"],coef(PowFit)["b"])

#plot
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)

#calculate confidence intervals 
confint(PowFit)

###Exercises

########################
### Comparing models ###
########################

QuaFit <- lm(BodyWeight ~ poly(TotalLength,2), data = Data2Fit)
Predic2PlotQua <- predict.lm(QuaFit, data.frame(TotalLength = Lengths))

#plot both models
plot(Data2Fit$TotalLength, Data2Fit$BodyWeight)
lines(Lengths, Predic2PlotPow, col = 'blue', lwd = 2.5)
lines(Lengths, Predic2PlotQua, col = 'red', lwd = 2.5)

#formal comparison using R²
RSS_Pow <- sum(residuals(PowFit)^2)  # Residual sum of squares
TSS_Pow <- sum((Data2Fit$BodyWeight - mean(Data2Fit$BodyWeight))^2)  # Total sum of squares
RSq_Pow <- 1 - (RSS_Pow/TSS_Pow)  # R-squared value

RSS_Qua <- sum(residuals(QuaFit)^2)  # Residual sum of squares
TSS_Qua <- sum((Data2Fit$BodyWeight - mean(Data2Fit$BodyWeight))^2)  # Total sum of squares
RSq_Qua <- 1 - (RSS_Qua/TSS_Qua)  # R-squared value

RSq_Pow 
RSq_Qua #not useful, very similar values

#formal comparison using AIC (Akaike Information Criterion)
#long way
n <- nrow(Data2Fit) #set sample size
pPow <- length(coef(PowFit)) # get number of parameters in power law model
pQua <- length(coef(QuaFit)) # get number of parameters in quadratic model

AIC_Pow <- n + 2 + n * log((2 * pi) / n) +  n * log(RSS_Pow) + 2 * pPow
AIC_Qua <- n + 2 + n * log((2 * pi) / n) + n * log(RSS_Qua) + 2 * pQua
AIC_Pow - AIC_Qua

#short way
#AIC(PowFit) - AIC(QuaFit)

####Exercises

######################################
### Albatross Chick Growth example ###
######################################

#load and plot data
alb <- read.csv(file="../Data/albatross_grow.csv")
alb <- subset(x=alb, !is.na(alb$wt))
plot(alb$age, alb$wt, xlab="age (days)", ylab="weight (g)", xlim=c(0, 100))

#define functions for two models
logistic1<-function(t, r, K, N0){
  N0*K*exp(r*t)/(K+N0*(exp(r*t)-1))
}

vonbert.w<-function(t, Winf, c, K){
  Winf*(1 - exp(-K*t) + c*exp(-K*t))^3
}

#the third model is a scaled data lm
scale<-4000
alb.lin<-lm(wt/scale~age, data=alb)

#fit the other two models
alb.log<-nlsLM(wt/scale~logistic1(age, r, K, N0), start=list(K=1, r=0.1, N0=0.1), data=alb)
alb.vb<-nlsLM(wt/scale~vonbert.w(age, Winf, c, K), start=list(Winf=0.75, c=0.01, K=0.01), data=alb)

#calculate predictions
ages<-seq(0, 100, length=1000)
pred.lin<-predict(alb.lin, newdata = list(age=ages))*scale
pred.log<-predict(alb.log, newdata = list(age=ages))*scale
pred.vb<-predict(alb.vb, newdata = list(age=ages))*scale

#plot the three models
plot(alb$age, alb$wt, xlab="age (days)", ylab="weight (g)", xlim=c(0,100))
lines(ages, pred.lin, col=2, lwd=2)
lines(ages, pred.log, col=3, lwd=2)
lines(ages, pred.vb, col=4, lwd=2)
legend("topleft", legend = c("linear", "logistic", "Von Bert"), lwd=2, lty=1, col=2:4)

#examine the residuals of all three models
par(mfrow=c(3,1), bty="n")
plot(alb$age, resid(alb.lin), main="LM resids", xlim=c(0,100))
plot(alb$age, resid(alb.log), main="Logisitic resids", xlim=c(0,100))
plot(alb$age, resid(alb.vb), main="VB resids", xlim=c(0,100))

#compare the three models with Sums of Squared Errors (SSE's)
n<-length(alb$wt)
list(lin=signif(sum(resid(alb.lin)^2)/(n-2 * 2), 3), 
     log= signif(sum(resid(alb.log)^2)/(n-2 * 3), 3), 
     vb= signif(sum(resid(alb.vb)^2)/(n-2 * 3), 3))          

####Exercises

###############################
### Aedes fecundity example ###
##############################

#obtain and plot data
aedes<-read.csv(file="../Data/aedes_fecund.csv")
plot(aedes$T, aedes$EFD, xlab="temperature (C)", ylab="Eggs/day")

#define non-linear models
quad1 <- function(T, T0, Tm, c){
  c*(T-T0)*(T-Tm)*as.numeric(T<Tm)*as.numeric(T>T0)
}

briere <- function(T, T0, Tm, c){
  c*T*(T-T0)*(abs(Tm-T)^(1/2))*as.numeric(T<Tm)*as.numeric(T>T0)
}

#third model will be a scaled lm
scale <- 20
aed.lin <- lm(EFD/scale~T, data=aedes)
aed.quad <- nlsLM(EFD/scale~quad1(T, T0, Tm, c), start=list(T0=10, Tm=40, c=0.01), data=aedes)
aed.br <- nlsLM(EFD/scale~briere(T, T0, Tm, c), start=list(T0=10, Tm=40, c=0.1), data=aedes)

####Exercises

##############################
## Abundances as an example ##
##############################

###############################
### Population growth rates ###
###############################

#generate the data
t <- seq(0, 22, 2)
N <- c(32500, 33000, 38000, 105000, 445000, 1430000, 3020000, 4720000, 5670000, 5870000, 5930000, 5940000)
set.seed(1234) # set seed to ensure you always get the same random sequence with rnorm
data <- data.frame(t, N + rnorm(length(time),sd=.1)) # add some random error
names(data) <- c("Time", "N")
head(data)

#plot the data
ggplot(data, aes(x = Time, y = N)) + 
  geom_point(size = 3) +
  labs(x = "Time (Hours)", y = "Population size (cells)")

#############################
### Basic linear approach ###
#############################

#linear model approach for an exponentially growing population requires the
#log transformation of data to calculate the growth rate parameter

data$LogN <- log(data$N)

#plot the transformation
ggplot(data, aes(x = t, y = LogN)) + 
  geom_point(size = 3) +
  labs(x = "Time (Hours)", y = "log(cell number)")

#in the plot, hours 4-10 look almost linear, so we can use them to determine r with a linear approach
(data[data$Time == 10,]$LogN - data[data$Time == 4,]$LogN)/(10-4)

#drawing a straight line through the linear part of the data - using a linear model
#the above approach doesnt account for error in measurement whereas a linear model does
lm_growth <- lm(LogN ~ Time, data = data[data$Time > 2 & data$Time < 12,])
summary(lm_growth)

#this growth rate is still not accurate enough, we guessed it by eye
#using NLLS instead

#############################################
### Fitting NLM's for growth trajectories ###
#############################################

#a somewhat mechanistic, classic model is the logistic equation
#define the function
logistic_model <- function(t, r_max, N_max, N_0){ # The classic logistic equation
  return(N_0 * N_max * exp(r_max * t)/(N_max + N_0 * (exp(r_max * t) - 1)))
} 

#we need some starting parameters to fit the model
N_0_start <- min(data$N) # lowest population size
N_max_start <- max(data$N) # highest population size
r_max_start <- 0.62 # use our linear estimate from before

#fit the data
fit_logistic <- nlsLM(N ~ logistic_model(t = Time, r_max, N_max, N_0), data,
                      list(r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))

summary(fit_logistic)

#plot the fit (non-transformed)
timepoints <- seq(0, 22, 0.1)
logistic_points <- logistic_model(t = timepoints, r_max = coef(fit_logistic)["r_max"], N_max = coef(fit_logistic)["N_max"], N_0 = coef(fit_logistic)["N_0"])
df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic equation"
names(df1) <- c("Time", "N", "model")

ggplot(data, aes(x = Time, y = N)) +
  geom_point(size = 3) +
  geom_line(data = df1, aes(x = Time, y = N, col = model), size = 1) +
  theme(aspect.ratio=1)+ # make the plot square 
  labs(x = "Time", y = "Cell number")

#plot the fit (log-transformed)
ggplot(data, aes(x = Time, y = LogN)) +
  geom_point(size = 3) +
  geom_line(data = df1, aes(x = Time, y = log(N), col = model), size = 1) +
  theme(aspect.ratio=1)+ 
  labs(x = "Time", y = "log(Cell number)")

#four growth models defnied, two of them related to define tlag
#lets specify the functions for the models
gompertz_model <- function(t, r_max, N_max, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(log(N_max / N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/log(N_max / N_0) + 1)))
}
gompertz_model2 <- function(t, r_max, N_max, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(log(N_0) + (log(N_max) - log(N_0)) * exp(-exp(r_max * exp(1) * (t_lag - t)/((log(N_max) - log(N_0)) * log(10)) + 1)))
}
baranyi_model <- function(t, r_max, N_max, N_0, t_lag){  # Baranyi model (Baranyi 1993)
  return(N_max + log10((-1+exp(r_max*t_lag) + exp(r_max*t))/(exp(r_max*t) - 1 + exp(r_max*t_lag) * 10^(N_max-N_0))))
}
buchanan_model <- function(t, r_max, N_max, N_0, t_lag){ # Buchanan model - three phase logistic (Buchanan 1997)
  return(N_0 + (t >= t_lag) * (t <= (t_lag + (N_max - N_0) * log(10)/r_max)) * r_max * (t - t_lag)/log(10) + (t >= t_lag) * (t > (t_lag + (N_max - N_0) * log(10)/r_max)) * (N_max - N_0))
}

#generate starting values
N_0_start <- min(data$N)
N_max_start <- max(data$N)
t_lag_start <- data$Time[which.max(diff(diff(data$LogN)))]
r_max_start <- max(diff(data$LogN))/mean(diff(data$Time))

#fit the models
fit_logistic <- nlsLM(N ~ logistic_model(t = Time, r_max, N_max, N_0), data,
                      list(r_max=r_max_start, N_0=N_0_start, N_max=N_max_start))
fit_gompertz <- nlsLM(LogN ~ gompertz_model2(t = Time, r_max, N_max, N_0, t_lag), data,
                      list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))
fit_baranyi <- nlsLM(LogN ~ baranyi_model(t = Time, r_max, N_max, N_0, t_lag), data,
                      list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))
fit_buchanan <- nlsLM(LogN ~ buchanan_model(t = Time, r_max, N_max, N_0, t_lag), data,
                      list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, N_max = N_max_start))

#summaries
summary(fit_logistic)
summary(fit_baranyi)
summary(fit_buchanan)
summary(fit_gompertz)

#plot the fits
timepoints <- seq(0, 24, 0.1)
logistic_points <- logistic_model(t = timepoints, r_max = coef(fit_logistic)["r_max"], N_max = coef(fit_logistic)["N_max"], N_0 = coef(fit_logistic)["N_0"])
baranyi_points <- baranyi_model(t = timepoints, r_max = coef(fit_baranyi)["r_max"], N_max = coef(fit_baranyi)["N_max"], N_0 = coef(fit_baranyi)["N_0"], t_lag = coef(fit_baranyi)["t_lag"])
buchanan_points <- buchanan_model(t = timepoints, r_max = coef(fit_buchanan)["r_max"], N_max = coef(fit_buchanan)["N_max"], N_0 = coef(fit_buchanan)["N_0"], t_lag = coef(fit_buchanan)["t_lag"])
gompertz_points <- gompertz_model(t = timepoints, r_max = coef(fit_gompertz)["r_max"], N_max = coef(fit_gompertz)["N_max"], N_0 = coef(fit_gompertz)["N_0"], t_lag = coef(fit_gompertz)["t_lag"])
df1 <- data.frame(timepoints, logistic_points)
df1$model <- "Logistic"
names(df1) <- c("t", "LogN", "model")
df2 <- data.frame(timepoints, baranyi_points)
df2$model <- "Baranyi"
names(df2) <- c("t", "LogN", "model")
df3 <- data.frame(timepoints, buchanan_points)
df3$model <- "Buchanan"
names(df3) <- c("t", "LogN", "model")
df4 <- data.frame(timepoints, gompertz_points)
df4$model <- "Gompertz"
names(df4) <- c("t", "LogN", "model")

model_frame <- rbind(df1, df2, df3, df4)

ggplot(data, aes(x = t, y = LogN)) +
  geom_point(size = 3) +
  geom_line(data = model_frame, aes(x = t, y = LogN, col = model), size = 1) +
  theme_bw() + # make the background white
  theme(aspect.ratio=1)+ # make the plot square 
  labs(x = "Time", y = "log(Abundance)")
