getRandomTimepoint <- function(dat, n) {
  start <- sample((n+1):(nrow(dat) - (n+1)), 1)
  dat2 <- dat[start:(start + n)]
  return(dat2)
}

getRandomIndex <- function(dat, n) {
  start <- sample((n+1):(nrow(dat) - (n+1)), 1)
  out <- start:(start + n)
  return(out)
}

getRandomWeek <- function(dat){
  # Remove weekends and Friday afternoons
  
  weeks <- unique(.indexweek(dat))
  randWeek <- sample(weeks[c(-1, -length(weeks))], size=1)
  out <- dat[.indexweek(dat) == randWeek][1:40, ]
  return(out)
}

randomTrading <- function(this.week, n_candles) {
  # Each turn, the play can either buy, sell, or have no position
  # permutate these possiblities to see where you land vs. randomness
  ret <- abs(as.numeric(diff(Cl(this.week)) * 1e4))
  ret <- ret[(n_candles+1):length(ret)]
  total <- c()
  for(xx in 1:1000){
    total <- c(total, sum(ret * sample(-1:1, size=length(ret), replace=TRUE)))
  }
  return(total)
}