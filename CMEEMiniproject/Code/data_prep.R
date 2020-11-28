# set start
# setwd("~/Documents/CMEECourseWork/CMEEMiniproject/Code")

# load data
data <- read.csv("../Data/CRat.csv")

# explore data
# str(data) #ID is integer, N_TraitValue is num, ResDensity is num
# Look at where there are NA's:
# NAcols <- apply(data, 2, anyNA)
# which(NAcols == TRUE) #located NAs, not in any of our columns of interest
# NaNcols <- apply(data, 2, function(x) sum(is.nan(x)))
# which(NaNcols > 0) #no NaNs
# nIDs <- length(unique(data$ID)) #308 IDs

# create data subsets for each ID (iden=identity)
for (iden in unique(data$ID)) {
  subdata <- subset(data, data$ID == iden)
  write.csv(subdata, paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))
}

# Testing with:
# iden="40053"
# subdata <- subset(data, data$ID==iden)
# subdata <- subdata[!is.na(subdata$ResDensity),]
# subdata <- subdata[!is.na(subdata$N_TraitValue),]
# write.csv(subdata, paste("../Data/data_subsets/subset_", iden, ".csv", sep=""))