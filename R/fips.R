#' @title cpfz
#' @description County-Public Forecast Zones Correlation File
#' @details This file is an ASCII "dump" in pipe ("|") delimited form, of a "master" 
#'   shapefile maintained by AGMG for the maintenance of County, Public Forecast 
#'   Zones, CWA boundaries, and Time zones. Each record represents a single 
#'   polygon within the master file. Multiple polygons may exist for the same 
#'   zone/county that contain the same attributes, but the lat and lon fields 
#'   will be different as they are the centroid of the polygon. No attempt has 
#'   been made to remove these seemingly duplicate entries from this text file. 
#'   In addition, the coastal and offshore marine zone shapefiles are also 
#'   "dumped" to this file. 
#' @source \url{http://www.nws.noaa.gov/geodata/catalog/wsom/html/cntyzone.htm}
#' @return dataframe
#' @export
cpfz <- function() {
  cpfz <- as.data.frame(readr::read_delim(.cpfz_url(), delim = "|", 
                                          col_names = .cpfz_names(), 
                                          col_types = .cpfz_col_types()))
  cpfz <- .cpfz_correction(cpfz)
  assign("cpfz", cpfz, envir = .GlobalEnv)
  return(TRUE)
}

#' @title .cpfz_col_types
#' @description Declare column types for cpfz dataframe
.cpfz_col_types <- function() {
  x <- c(paste0("cicccciccnn"))
  return(x)
}

#' @title .cpfz_correction
#' @description Correct cpfz input
#' @details Fix issues in cpfz()
#' Issues:
#' \describe{
#'   \item{Row 272}{Expects FIPS but FIPS is missing}
#' }
#' @param df Dataframe created from cpfz()
.cpfz_correction <- function(df) {
  if(.cpfz_url() != "http://www.nws.noaa.gov/geodata/catalog/wsom/data/bp01nv16.dbx")
    return(df)
  
  # Fix "1 parsing failure, row 272, col FIPS, expecting integer
  # FIPS value is missing from dataset.
  df$TIME_ZONE[df$STATE_ZONE == "VA515" & is.na(df$FIPS)] <- "E"
  df$FE_AREA[df$STATE_ZONE == "VA515" & is.na(df$FIPS)] <- "cc"
  df$LAT[df$STATE_ZONE == "VA515" & is.na(df$FIPS)] <- 37.529281
  df$LON[df$STATE_ZONE == "VA515" & is.na(df$FIPS)] <- -77.475408
  message("Parsing error for FIPS, row 272 is corrected.")
  return(df)
}

#' @title .cpfz_names
#' @description Column names for County-Public Forecast Zones Correlation File
#' @return character vector
.cpfz_names <- function() {
  x <- c("STATE", "ZONE", "CWA", "NAME", "STATE_ZONE", "COUNTYNAME", "FIPS", 
         "TIME_ZONE", "FE_AREA", "LAT", "LON")
  return(x)
}

#' @title cpfz_tz_abbr
#' @description Return timezone abbreviations for the cpfz dataframe
#' @details Two letters appear for the ten (10) counties which are divided by a time 
#' zone boundary, which are located in the states of AK, FL, ID, ND, NE, OR 
#' and SD. 
#' \describe{
#'   \item{A}{Alaska Standard}
#'   \item{C}{Central Standard}
#'   \item{E}{Eastern Standard (e = advanced time not observed)}
#'   \item{G}{Guam & Marianas}
#'   \item{H}{Hawaii-Aleutian Standard}
#'   \item{M}{Mountain Standard (m = advanced time not observed)}
#'   \item{P}{Pacific Standard}
#'   \item{S}{Samoa Standard}
#'   \item{V}{Atlantic Standard}
#' }
#' @return a list to map cpfz_tz_dt$TIME_ZONE to the true timezone
#' @source \url{http://www.nws.noaa.gov/geodata/catalog/county/html/county.htm}
#' @export
cpfz_tz_abbr <- function() {
  list("A" = "America/Anchorage", 
       "C" = "America/Chicago", 
       "E" = "America/New_York", 
       "G" = "Pacific/Guam", 
       "H" = "Pacific/Honolulu", 
       "M" = "America/Denver", 
       "P" = "America/Los_Angeles", 
       "S" = "Pacific/Samoa", 
       "V" = "America/Halifax")
}

#' @title .cpfz_url 
#' @description County-Public Forecast Zones Correlation File URL
#' @source \url{http://www.nws.noaa.gov/geodata/catalog/wsom/html/cntyzone.htm}
#' @return url
.cpfz_url <- function() {
  url <- "http://www.nws.noaa.gov/geodata/catalog/wsom/data/bp01nv16.dbx"
  return(url)
}
