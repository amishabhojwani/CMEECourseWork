require(tidyverse)

#read and explore data
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv")
str(MyDF)
MyDF$Type.of.feeding.interaction <- as.factor(MyDF$Type.of.feeding.interaction)
levels(MyDF$Type.of.feeding.interaction)

#subset per level of feeding interaction
pred.pisc<-subset(MyDF, Type.of.feeding.interaction=="predacious/piscivorous")
pisc<-subset(MyDF, Type.of.feeding.interaction=="piscivorous")
pred<-subset(MyDF, Type.of.feeding.interaction=="predacious")
plank<-subset(MyDF, Type.of.feeding.interaction=="planktivorous")
insec<-subset(MyDF, Type.of.feeding.interaction=="insectivorous")

#work on Predators
pdf("../Results/Pred_Subplots.pdf", 11.7, 8.3)
par(mfrow=c(3,2))
hist(log(pred.pisc$Predator.mass), xlab = "log of Predator Mass", main="Predacious / piscivorous")
hist(log(pred$Predator.mass), xlab = "log of Predator Mass", main="Predacious")
hist(log(pisc$Predator.mass), xlab = "log of Predator Mass", main="Piscivorous")
hist(log(plank$Predator.mass), xlab = "log of Predator Mass", main="Planktivorous")
hist(log(insec$Predator.mass), xlab = "log of Predator Mass", main="Insectivorous")
graphics.off()

#work on Prey
pdf("../Results/Prey_Subplots.pdf", 11.7, 8.3)
par(mfrow=c(3,2))
hist(log(pred.pisc$Prey.mass), xlab = "log of Prey Mass", main="Predacious / piscivorous")
hist(log(pred$Prey.mass), xlab = "log of Prey Mass", main="Predacious")
hist(log(pisc$Prey.mass), xlab = "log of Prey Mass", main="Piscivorous")
hist(log(plank$Prey.mass), xlab = "log of Prey Mass", main="Planktivorous")
hist(log(insec$Prey.mass), xlab = "log of Prey Mass", main="Insectivorous")
graphics.off()

#work on SizeRatio
pdf("../Results/SizeRatio_Subplots.pdf", 11.7, 8.3)
par(mfrow=c(3,2))
hist(log(pred.pisc$Predator.mass/pred.pisc$Prey.mass), xlab = "Size ratio (pred/prey)", main="Predacious / piscivorous")
hist(log(pred$Predator.mass/pred$Prey.mass), xlab = "Size ratio (pred/prey)", main="Predacious")
hist(log(pisc$Predator.mass/pisc$Prey.mass), xlab = "Size ratio (pred/prey)", main="Piscivorous")
hist(log(plank$Predator.mass/plank$Prey.mass), xlab = "Size ratio (pred/prey)", main="Planktivorous")
hist(log(insec$Predator.mass/insec$Prey.mass), xlab = "Size ratio (pred/prey)", main="Insectivorous")
graphics.off()

# pp_results.csv
Results <- MyDF %>%
  group_by(Type.of.feeding.interaction) %>%
  summarise(mean(log(Predator.mass)),
            median(log(Predator.mass)),
            mean(log(Prey.mass)),
            median(log(Prey.mass)),
            mean(log(Prey.mass/Predator.mass)),
            median(log(Prey.mass/Predator.mass)))

# name the columns
names(Results) <- c("Type.of.feeding.interaction",
                  "Mean_log.predator.mass",
                  "Median_log.predator.mass",
                  "Mean_log.prey.mass",
                  "Median_log.prey.mass",
                  "Mean_log.size.ratio",
                  "Median_log.size.ratio")
# write to csv
write.csv(Results, "../Results/PP_Results.csv")