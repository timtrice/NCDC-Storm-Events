# Set environment variables

ncdcEnv <- new.env()
parent.env(ncdcEnv)

#' URL to access datasets
#' @name ncdcEnv$url
ncdcEnv$url <- "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"
