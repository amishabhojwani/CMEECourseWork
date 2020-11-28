################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################

require(tidyverse)

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../Data/PoundHillData.csv", header = FALSE))

# header = true because we do have metadata headers
MyMetaData <- read.csv("../Data/PoundHillMetaData.csv", header = TRUE, sep = ";")

############# Inspect the dataset ###############
head(MyData)
dim(MyData)
dplyr::glimpse(MyData)
#utils::View(MyData) #you can also do this
#utils::View(MyMetaData)

############# Transpose ###############
# To get those species into columns and treatments into rows 
MyData <- t(MyData) 
head(MyData)
colnames(MyData) #there's no column names, just "data"
dim(MyData)

############# Replace species absences with zeros ###############
MyData[MyData == ""] = 0

############# Convert raw matrix to data frame ###############

TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F) #stringsAsFactors = F is important!
colnames(TempData) <- MyData[1,] # assign column names from original data
head(TempData)
rownames(TempData) <- NULL #get rid of row names
head(TempData)

############# Convert from wide to long format  ###############
MyWrangledData <- TempData %>%
  pivot_longer(5:45, names_to = "Species", values_to = "Count") %>% #could use gather also, make it long from wide
  mutate(Cultivation = as.factor(Cultivation)) %>% #change variables to factors
  mutate(Block = as.factor(Block)) %>%
  mutate(Plot = as.factor(Plot)) %>%
  mutate(Quadrat = as.factor(Quadrat)) %>%
  mutate(Count = as.integer(Count)) %>% #only integer variable
  mutate(Species = as.factor(Species))

dplyr::glimpse(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

############# Exploring the data ###############
require(tidyverse)
tibble::as_tibble(MyWrangledData) # convert to a tibble, which is like a data frame but more manipulable
dplyr::glimpse(MyWrangledData) #like str(), but nicer!
utils::View(MyWrangledData) #same as fix() or View()
dplyr::filter(MyWrangledData, Count>100) #like subset(), but nicer!
dplyr::slice(MyWrangledData, 10:15) # Look at an arbitrary set of data rows
