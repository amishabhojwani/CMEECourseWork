#No preallocation
NoPreallocFun <- function(x){
  a <- vector() # empty vector
  for (i in 1:x) {
    a <- c(a, i)
    print(a)
    print(object.size(a))
  }
}

system.time(NoPreallocFun(10))
system.time(a<-1:10)

#Preallocation
PreallocFun <- function(x){
  a <- rep(NA, x) # pre-allocated vector
  for (i in 1:x) {
    a[i] <- i
    print(a)
    print(object.size(a))
  }
}

system.time(PreallocFun(10))
