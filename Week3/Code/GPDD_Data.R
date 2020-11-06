#dependency
require(maps)

#load data
load("../Data/GPDDFiltered.RData")

#worldview using maps
map(database = "world", fill = TRUE, col = "grey", 
         bg = "white", border = "black",) #load world map

points(x = gpdd$long, y = gpdd$lat, col = "orange", 
       pch = 16, cex = 0.7) #superimpose points

#western view - zoom into north america and europe
#map(database = "world", fill = TRUE, col = "forestgreen", bg = "lightblue",
    #border = "darkgreen", xlim = c(-150,50), ylim = c(20,90))
#points(x = gpdd$long, y = gpdd$lat, col = gpdd$common.name, pch = 16, cex = 0.9)

#################
#### Biases ####
################

# Most of the data represented on the world map is for North America and
# Northern Europe, with an exception in South Africa and another in Japan.
# This means that any analyses conducted on this set of data would not be
# representative of a world sample.