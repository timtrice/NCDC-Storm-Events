library(tidyr)
library(data.table)
library(lubridate)

#' FIPS URL
#' 
#' This file is an ASCII "dump" in pipe ("|") delimited form, of a "master" 
#' shapefile maintained by AGMG for the maintenance of County, Public Forecast 
#' Zones, CWA boundaries, and Time zones. Each record represents a single 
#' polygon within the master file. Multiple polygons may exist for the same 
#' zone/county that contain the same attributes, but the lat and lon fields 
#' will be different as they are the centroid of the polygon. No attempt has 
#' been made to remove these seemingly duplicate entries from this text file. 
#' In addition, the coastal and offshore marine zone shapefiles are also 
#' "dumped" to this file. 
#'
#' @return url to fips dataset
#' @export
#' @examples
#' 
#' url <- fips()
#' 
fips <- function() {
    url <- "http://www.nws.noaa.gov/geodata/catalog/wsom/data/bp10nv15.dbx"
}

#' Names for fips data table
#'
#' @return a character vector, length 10, of names to assign to fips_tz_dt()
#' @export
#' @examples
#' 
#' setnames(fips_dt) <- fips_names()
#' 
fips_names <- function() {
    c("STATE", "ZONE", "CWA", "NAME", "STATE_ZONE", "COUNTYNAME", "FIPS", 
      "TIME_ZONE", "FE_AREA", "LAT", "LON")
}

#' Required fields for datetime objects
#'
#' @return a character vector of required date/time variables
#' @export
#' @examples
#' 
#' if(all(names(DT)) %in% datetime_fields())...
#' 
#' names(DT) <- datetime_fields()
#' 
datetime_fields <- function() {
    c("EVENT_ID", "YEAR", "MONTH_NAME", "BEGIN_DAY", "BEGIN_DATE_TIME", 
      "END_DAY", "END_DATE_TIME")
}

#' Required fields for timezone objects
#'
#' @return character vector of required timezone variables
#' @export
#' @examples
#' if(all(names(DT)) %in% timezone_fields())...
#' 
#' names(DT) <- timezone_fields()
#' 
timezone_fields <- function() {
    c("EVENT_ID", "CZ_TIMEZONE")
}

clean_datetime <- function(DT = NULL) {

    x <- get_data(1965, "details")

    DT <- x[, .(EVENT_ID, YEAR, MONTH_NAME, BEGIN_DAY, BEGIN_DATE_TIME, 
                END_DAY, END_DATE_TIME)]

    if(!is.data.table(DT)) stop("No data table.")
    if(!all(names(DT) %in% datetime_fields()))
        stop(paste("Expecting a data table with EVENT_ID, YEAR, MONTH_NAME,", 
                   "BEGIN_DAY, END_DAY, BEGIN_DATE_TIME and END_DATE_TIME.", 
                   sep = " "))
    
    DT <- DT[, BeginDateTime := ymd_hms(paste(paste(YEAR, MONTH_NAME, 
                                                    BEGIN_DAY, sep = "-"), 
                                              sub("[0-9A-Z-]+ ([0-9:]+)", 
                                                  "\\1", DT$BEGIN_DATE_TIME), 
                                              sep = " "))]
    DT <- DT[, EndDateTime := ymd_hms(paste(paste(YEAR, MONTH_NAME, END_DAY, 
                                                  sep = "-"), 
                                              sub("[0-9A-Z-]+ ([0-9:]+)", 
                                                  "\\1",DT$END_DATE_TIME), 
                                              sep = " "))]
}

#' Seperate timezones into data tables
#' 
#' Deprecated. Keeping for analysis of the crappy timezone data in the 
#'      dataset but provides no general use, I don't think.
#'
#' @param DT EVENT_ID and CZ_TIMEZONE field only
#' @return Creates individual data tables for each unique timezone
#' @export
#' @examples
#' tz_to_dt(DT[, .(EVENT_ID, CZ_TIMEZONE)])
#' 
tz_to_dt <- function(DT = NULL) {
    
    if(!is.data.table(DT)) stop("No data table.")
    if(!all(names(DT) %in% timezone_fields()))
        stop("Excepting only CZ_TIMEZONE.")
    
    unique_tz <- unique(DT$CZ_TIMEZONE)

    # I would like to get rid of this for loop but at the moment 
    # not having much luck. 
    # Attempted with 1965 data:
    # https://cran.r-project.org/doc/FAQ/R-FAQ.html#How-can-I-turn-a-string-into-a-variable_003f
    # varname <- c("EST", "MDT", "CST")
    # eval(substitute(DT[CZ_TIMEZONE %in% variable]), 
        # list(variable = as.name(varname[1])))
    for(tz in unique_tz){
        assign(tz, DT[CZ_TIMEZONE %in% tz], envir = .GlobalEnv)
    }

}

#' Return FIPS dataset
#'
#' See \url{http://www.nws.noaa.gov/geodata/catalog/wsom/html/cntyzone.htm}
#'
#' @return dataset of FIPS codes.
#' @export
#'
#' @examples
#' \dontrun{
#' FIPS <- fips_dt()
#' }
#' 
fips_dt <- function() {
    url <- fips()
    fips_dt <- as.data.table(readr::read_delim(url, delim = "|", 
                                               col_names = FALSE))
    setnames(fips_dt, fips_names())
    fips_dt
}

#' Return timezone abbreviations for the FIPS dataset
#'
#' See \url{http://www.nws.noaa.gov/geodata/catalog/county/html/county.htm}
#'
#' Two letters appear for the ten (10) counties which are divided by a time 
#' zone boundary, which are located in the states of AK, FL, ID, ND, NE, OR 
#' and SD. 
#' 
#' \describe{
#'      \item{V}{Atlantic Standard}
#'      \item{E}{Eastern Standard (e = advanced time not observed)}
#'      \item{C}{Central Standard}
#'      \item{M}{Mountain Standard (m = advanced time not observed)}
#'      \item{P}{Pacific Standard}
#'      \item{A}{Alaska Standard}
#'      \item{H}{Hawaii-Aleutian Standard}
#'      \item{G}{Guam & Marianas}
#'      \item{S}{Samoa Standard}
#' }
#' 
#' @return a character vector to map fips_tz_dt$TIME_ZONE to the true 
#' timezone
#' 
#' @export
#'
#' @examples
#' tz_abbr <- fips_tz_abbr()
#' 
fips_tz_abbr <- function() {
    list("V" = "AST", "E" = "EST", "C" = "CST", "M" = "MST", "P" = "PST", 
         "A" = "AKST", "H" = "HAST", "G" = "ChST", "S" = "SST")
}
