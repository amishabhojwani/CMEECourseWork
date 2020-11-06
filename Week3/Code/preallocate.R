print("No preallocation")
NoPreallocFun <- function(x){
  a <- vector() # empty vector
  for (i in 1:x) {
    a <- c(a, i)
    print(a)
    print(object.size(a))
  }
}

t<-system.time(NoPreallocFun(10))
print(t)
system.time(a<-1:10)

print("Preallocation")
PreallocFun <- function(x){
  a <- rep(NA, x) # pre-allocated vector
  for (i in 1:x) {
    a[i] <- i
    print(a)
    print(object.size(a))
  }
}

g<-system.time(PreallocFun(10))
print(g)