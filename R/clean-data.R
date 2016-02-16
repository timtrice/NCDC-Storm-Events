library(tidyr)
library(data.table)
library(lubridate)

datetime_fields <- function() {
    c("EVENT_ID", "YEAR", "MONTH_NAME", "BEGIN_DAY", "BEGIN_DATE_TIME", 
      "END_DAY", "END_DATE_TIME")
}

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
    # eval(substitute(DT[CZ_TIMEZONE %in% variable]), list(variable = as.name(varname[1])))
    for(tz in unique_tz){
        assign(tz, DT[CZ_TIMEZONE %in% tz], envir = .GlobalEnv)
    }

}
