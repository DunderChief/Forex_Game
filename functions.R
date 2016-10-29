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
  weeks <- unique(.indexweek(dat))
  randWeek <- sample(weeks[c(-1, -length(weeks))], size=1)
  out <- dat[.indexweek(dat) == randWeek][1:25,]
  return(out)
}