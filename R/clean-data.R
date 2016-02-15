library(tidyr)
library(data.table)
library(lubridate)

clean_datetime <- function(DT = NULL) {
    if(!is.data.table(DT)) stop("No data table.")
    
    DT <- get_data(2000:2001, "details")
    DT <- DT[, BeginDateTime := ymd_hms(paste(paste(YEAR, MONTH_NAME, BEGIN_DAY, sep = "-"), 
                                              sub("[0-9A-Z-]+ ([0-9:]+)", "\\1", DT$BEGIN_DATE_TIME), 
                                              sep = " "))]
    DT <- DT[, EndDateTime := ymd_hms(paste(paste(YEAR, MONTH_NAME, END_DAY, sep = "-"), 
                                              sub("[0-9A-Z-]+ ([0-9:]+)", "\\1", DT$END_DATE_TIME), 
                                              sep = " "))]
}

clean_timezones <- function(timezones = NULL) {
    if(!is.list(timezones)) stop("No timezones.")
    
}