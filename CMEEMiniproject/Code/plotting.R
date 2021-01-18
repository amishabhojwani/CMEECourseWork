# set start
# setwd("~/Documents/CMEECourseWork/CMEEMiniproject/Code")

#dependencies
require(ggplot2)

# load data
data <- read.csv("../Data/CRat.csv")

print("Plotting model curves on the data and saving pdf files for each subset. This will take about 1 minute.")

#plotting
for (iden in unique(data$ID)) {
  pdf(file = paste("../Results/plots/", iden,"_plot.pdf", sep="")) #write pdf with all plots

  subdata <- read.csv(paste("../Data/data_subsets/subset_", iden, ".csv", sep="")) #read full subset
  sub_df <- read.csv(paste("../Results/HollT2_plotting_dfs/HollT2_dfplot_subset_", iden, sep="")) #read Holling subset
  
  p <- ggplot(subdata, aes(x=ResDensity, y=N_TraitValue)) + geom_point() +
    geom_smooth(method = lm, formula = y ~ poly(x, degree = 2, raw = TRUE), se=FALSE, aes(colour = "blue")) +
    geom_smooth(method = lm, formula = y ~ poly(x, degree = 3, raw = TRUE), se=FALSE, aes(colour = "red")) +
    geom_smooth(data=sub_df, method=loess, formula = y ~ x, aes(x=ResDensity, y=N_TraitValue , colour = "green")) +
    labs(x="Resource Density", y="Individual Trait Value", title = paste("Functional Response Models between \n", subdata$ConTaxaStage, " (consumer) and\n", subdata$ResTaxaStage, " (resource)", sep="")) +
    theme(plot.title = element_text(hjust = 0.5, size = "15"), legend.position = "bottom") +
    scale_color_manual(name = NULL, values = c("blue", "red", "green"), labels = c("Quadratic model", "Cubic model", "Holling Type II model"))
  
  print(p)
  graphics.off() #save plot in pdf
  
}

print("Finished plotting and saving the .pdf's to ../Results/plots")
