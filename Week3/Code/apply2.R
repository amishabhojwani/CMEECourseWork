SomeOperation <- function(v){ # if sum of v is positive multiply by 100
  if (sum(v) > 0){ #note that sum(v) is a single (scalar) value
    return (v * 100)
  }
  return (v)
}

M <- matrix(rnorm(100), 10, 10)
Mapply <- apply(M, 1, SomeOperation)
