rm(list = ls())
graphics.off()
source("data_prep.R")
source("starting_values.R")
source("model_fitting.R")
source("plotting.R")

# #finding min and max subset nrows
# min = 500
# max = 0
# for (iden in unique(data$ID)) {
#   c <- count(data$ID==iden)
#   if (c<min) min = c
#   if (c>max) max = c
# }

# small_subsets <- c()
# for (iden in unique(data$ID)) {
#   if (count(data$ID==iden)==4) {
#     c(small_subsets, iden)
#   }
# }






