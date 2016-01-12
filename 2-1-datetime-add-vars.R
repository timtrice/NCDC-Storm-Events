library(data.table)
library(lubridate)
library(knitr)
library(tidyr)

# For the purposes of this script, only need date fields. 
details <- fread("data/details.csv", 
                 na.strings = c("NA", ""), 
                 select = c("V1", "BEGIN_YEARMONTH", "BEGIN_DAY", 
                            "END_YEARMONTH", "END_DAY","BEGIN_DATE_TIME", 
                            "CZ_TIMEZONE", "END_DATE_TIME", "YEAR", "MONTH_NAME", 
                            "CZ_NAME", "STATE"))

# Rename V1 to ID
setnames(details, "V1", "ID")

# Split `BEGIN_DATE_TIME` and `END_DATE_TIME` mainly to get time alone
details <- details[, 
                   c("BDT_YMD", # I won't use this; have to extract
                     "BDT_HMS") := tstrsplit(BEGIN_DATE_TIME, 
                                             split = " ", 
                                             fixed = TRUE)
                   ][, 
                     c("EDT_YMD", # I won't use this; have to extract
                       "EDT_HMS") := tstrsplit(END_DATE_TIME, 
                                               split = " ", 
                                               fixed = TRUE)
                     ][, 
                       `:=` (
                           BDT_YMD_HMS = paste(
                               paste(
                                   YEAR, 
                                   MONTH_NAME, 
                                   BEGIN_DAY, 
                                   sep = "-"
                               ), 
                               BDT_HMS, 
                               sep = " "), 
                           EDT_YMD_HMS = paste(
                               paste(
                                   YEAR, 
                                   MONTH_NAME, 
                                   END_DAY, 
                                   sep = "-"
                               ), 
                               EDT_HMS, 
                               sep = " ")
                       )]


# Now convert `BDT_YMD_HMS` and `EDT_YMD_HMS` to POSIXct var
details <- details[, 
                   `:=` (
                       BDT_POSIX = ymd_hms(BDT_YMD_HMS), 
                       EDT_POSIX = ymd_hms(EDT_YMD_HMS)
                   )]

