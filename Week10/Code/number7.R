x <- read.csv("../Data/parkgrass.csv") #Theres a problem here
species_list <- unique(x$species)

for(s in species_list){
    print(paste("there are", sum(s==x$species), "of the species", s))
}

x <- c(1, 2, 3, 4, 5, 6)
for(i in x){
    if (i >= mean(x)){
        print(i)
    }
}

c <- 1
e <- seq(0, 1, 0.01)
p <- seq(0, 1)

for(ei in e){
    dP <- c*p*(1-p) - ei*p
    print(dP) 
}

parkgrass <- read.csv("../Data/parkgrass.csv")
results <- data.frame(site=character(), count=numeric())
for(i in unique(parkgrass$plot)){
 temp_file <- subset(parkgrass, parkgrass$plot==i & parkgrass$year==2000)
 speciesrichness <- length(temp_file$species)
 temp <- data.frame(site=i, count=speciesrichness)
 results <- rbind(temp, results)
}
print(results)