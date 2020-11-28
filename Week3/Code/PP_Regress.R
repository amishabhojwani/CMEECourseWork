#set start
#setwd("~/Documents/CMEECourseWork/Week3/Code")

#dependencies
require(ggplot2)

#read data
df <- read.csv("../Data/EcolArchives-E089-51-D1.csv")

#plot and save plot
pdf("../Results/PP_plot.pdf")
p <- ggplot(df, aes(log(Prey.mass), log(Predator.mass), colour = Predator.lifestage)) +
      geom_point(shape=I(3)) +
      geom_smooth(method = "lm", fullrange=TRUE ) +
      facet_wrap(ncol = 1, Type.of.feeding.interaction ~., strip.position="right", scales = "fixed", dir="h") +
      labs(colour = "Predator.lifestage", x="Prey Mass in grams", y="Predator Mass in grams") +
      theme(legend.position="bottom") +
      guides(colour = guide_legend(nrow = 1)) +
      coord_fixed(ratio = 1/5)

p

print(p)

graphics.off()

print("Saved your plot in the Results directory as: PP_plot.pdf")

#stats and building the table
stats <- matrix(nrow = 17, ncol = 6)
colnames(stats) <- c("Interaction.Lifestage.Combination", "Intercept", "Slope", "R2", "F.statistic", "p.value") 

#name empty vectors to be filled within the for loops
rnames <- c()
slopes <- c()
intercepts <- c()
R2 <- c()
F.stats <- c()
p.values <- c()

#foor loops subsetting every combination of interaction and lifestage and running an lm
for (interac in unique(df$Type.of.feeding.interaction)) {
    z <- subset(df, df$Type.of.feeding.interaction==interac)
    z <- na.omit(z)
    for (lifestage in unique(z$Predator.lifestage)) {
      if (interac=="piscivorous" & lifestage=="postlarva/juvenile") {
        next }
      y <- subset(z, z$Predator.lifestage==lifestage)
      j <- lm(log(Predator.mass)~log(Prey.mass), data = y)
      i <- summary(j)
          
      #appending coefficients to the empty vectors
      rnames <- c(rnames, paste(interac, "_", lifestage, sep=""))
      slopes <- c(slopes, i[["coefficients"]][[2]])
      intercepts <- c(intercepts, i[["coefficients"]][[1]])
      R2 <- c(R2, i[["r.squared"]])
      F.stats <- c(F.stats, i[["fstatistic"]][[1]]) #fails in last loop
      p.values <- c(p.values, i[["coefficients"]][[8]]) #fails in 5th loop
    }
}

#after browser we see that fstat append fails in piscivorous postlarva/juvenile subset
# this lm gives all NAs - we can go past it

#assigning the now filled vectors to columns in the matrix
stats[,1] <- rnames
stats[,2] <- intercepts
stats[,3] <- slopes
stats[,4] <- R2
stats[,5] <- F.stats
stats[,6] <- p.values

#from the table we see planktivorous juvenile has NA's, we should delete the row
stats <- stats[-6,]

#writing the results file
write.csv(stats, file = "../Results/PP_Regress_Results.csv")

print("Saved your regression coefficients in your Results directory as PP_Regress_Results.csv")