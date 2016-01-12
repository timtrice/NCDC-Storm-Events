library(data.table)
library(lubridate)
library(knitr)
library(tidyr)

# For the purposes of this script, only need date fields. 
details <- fread("data/details.csv", 
                 na.strings = c("NA", ""), 
                 select = c("V1", "BEGIN_YEARMONTH", "BEGIN_DAY", 
                            "END_YEARMONTH", "END_DAY","BEGIN_DATE_TIME", 
                            "CZ_TIMEZONE", "END_DATE_TIME", "CZ_NAME", "STATE"))

# Rename V1 to ID
setnames(details, "V1", "ID")

# 1BEGIN_YEARMONTH1 is a six-digit numeric field containing four-digit year and 
# two-digit month. Split into two vars
details <- separate(details, # data
                    BEGIN_YEARMONTH, # column of dataset to separate
                    c("BEGIN_Y", # first new variable for Year
                      "BEGIN_M"), # second new variable for month
                    sep=4, # will take the first four characters, assign to 
                    # BEGIN_Y, assign anything else to BEGIN_M
                    convert = TRUE, # convert two new variables accordingly
                    remove = FALSE # Do not remove BEGIN_YEARMONTH
)

details <- separate(details, # data
                    END_YEARMONTH, # column of dataset to separate
                    c("END_Y", # first new variable for Year
                      "END_M"), # second new variable for month
                    sep=4, # will take the first four characters, assign to 
                    # END_Y, assign anything else to END_M
                    convert = TRUE, # convert two new variables accordingly
                    remove = FALSE # Do not remove END_YEARMONTH
)

# Same with `BEGIN_DATE_TIME`
details <- separate(details, 
                    BEGIN_DATE_TIME, 
                    c("BEGIN_DATE_TIME_YMD", 
                      "BEGIN_DATE_TIME_HMS"), 
                    sep = " ", 
                    convert = FALSE, 
                    remove = FALSE
)

details <- separate(details, 
                    END_DATE_TIME, 
                    c("END_DATE_TIME_YMD", 
                      "END_DATE_TIME_HMS"), 
                    sep = " ", 
                    convert = FALSE, 
                    remove = FALSE
)

# I'll add BEGIN_DATE_TIME_YMD which will be a concatenation of 
# BEGIN_Y, BEGIN_M, BEGIN_DAY in %Y-%m-%d format
details <- details[, BEGIN_DATE_TIME_YMD := paste(
    BEGIN_Y, 
    sprintf("%02.0f", BEGIN_M), 
    sprintf("%02.0f", BEGIN_DAY), 
    sep = "-", 
    collapse = NULL
)]

details <- details[, END_DATE_TIME_YMD := paste(
    END_Y, 
    sprintf("%02.0f", END_M), 
    sprintf("%02.0f", END_DAY), 
    sep = "-", 
    collapse = NULL
)]

details <- details[, BEGIN_DATETIME := as.POSIXct(
    paste(
        BEGIN_DATE_TIME_YMD, 
        BEGIN_DATE_TIME_HMS, 
        sep = " ", 
        collapse = NULL), 
    format = "%Y-%m-%d %H:%M:%S", 
    usetz = TRUE
)]

details <- details[, END_DATETIME := as.POSIXct(
    paste(
        END_DATE_TIME_YMD, 
        END_DATE_TIME_HMS, 
        sep = " ", 
        collapse = NULL), 
    format = "%Y-%m-%d %H:%M:%S", 
    usetz = TRUE
)]

# Timezones
# The dates and times are local. You cannot keep multiple time zones in one 
# var. It's best to use UTC anyway as there is no time change for UTC like 
# there is with most of the timezones in this dataset. So I need to go thorugh 
# each of the timezones, make corrections where necessary and make a 
# conversion to UTC.

# What unique timezones do we have?
unique_cz_timezone <- unique(details$CZ_TIMEZONE)
print(sort(unique_cz_timezone))

# For consistency, I'll make all abbr's upper case
details <- details[, CZ_TIMEZONE := toupper(CZ_TIMEZONE)]

# Now start going through each timezone, correct inconsistencies. 
print(gmt <- details[CZ_TIMEZONE == "GMT", .(STATE, BEGIN_DATETIME)])

details[CZ_TIMEZONE == "GMT", CZ_TIMEZONE := "CST"]

print(unk <- details[CZ_TIMEZONE == "UNK", .(CZ_NAME, STATE, BEGIN_DATETIME)])

# Hampden, MA - EDT began Apr. 29, 1956
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "HAMPDEN" & 
            STATE == "MASSACHUSETTS", 
        CZ_TIMEZONE := "EDT"]

# LOVE, OK - CDT began Apr. 28, 1957
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "LOVE" & 
            STATE == "OKLAHOMA", 
        CZ_TIMEZONE := "CST"]

# Rush, IN - EDT began Apr. 30, 1967
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "RUSH" & 
            STATE == "INDIANA", 
        CZ_TIMEZONE := "EST"]

# McLennan, TX - CDT began Apr. 30, 1972
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "MCLENNAN" & 
            STATE == "TEXAS", 
        CZ_TIMEZONE := "CDT"]

# OCONEE, GA - EDT began Apr. 29, 1973
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "OCONEE" & 
            STATE == "GEORGIA", 
        CZ_TIMEZONE := "EST"]

# COLES, IL - CDT began Jan. 6, 1974 - no typo
# http://www.timeanddate.com/time/change/usa/chicago?year=1974
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "COLES" & 
            STATE == "ILLINOIS", 
        CZ_TIMEZONE := "CDT"]

# PERKINS, SD - MDT began Apr. 27, 1980
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "PERKINS" & 
            STATE == "SOUTH DAKOTA", 
        CZ_TIMEZONE := "MDT"]

# HAWAII, HAWAII - No DST
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "HAWAII" & 
            STATE == "HAWAII", 
        CZ_TIMEZONE := "HST"]

# ARMSTRONG, TEXAS - CDT began April 25, 1982
details[CZ_TIMEZONE == "UNK" & 
            CZ_NAME == "ARMSTRONG" & 
            STATE == "TEXAS", 
        CZ_TIMEZONE := "CDT"]

print(sct <- details[CZ_TIMEZONE == "SCT", .(CZ_NAME, STATE, BEGIN_DATETIME)])

details[CZ_TIMEZONE == "SCT" & 
            CZ_NAME == "SHAWANO" & 
            STATE == "WISCONSIN", 
        CZ_TIMEZONE := "CDT"]

print(sst <- details[CZ_TIMEZONE == "SST", .(CZ_NAME, STATE, BEGIN_DATETIME)])

details[CZ_TIMEZONE == "SST" & 
            STATE == "GUAM", 
        CZ_TIMEZONE := "ChST"]

details[CZ_TIMEZONE == "SST" & 
            CZ_NAME == "GUAM COASTAL WATERS", 
        CZ_TIMEZONE := "ChST"]

print(csc <- details[CZ_TIMEZONE == "CSC", .(CZ_NAME, STATE, BEGIN_DATETIME)])

details[CZ_TIMEZONE == "CSC", CZ_TIMEZONE := "CDT"]

print(gst10 <- details[CZ_TIMEZONE == "GST10", .(CZ_NAME, STATE, 
                                                 BEGIN_DATETIME)])

details[CZ_TIMEZONE == "GST10", CZ_TIMEZONE := "ChST"]

unique_cz_timezone <- unique(details$CZ_TIMEZONE)
print(sort(unique_cz_timezone))

# AKST-9 to AKST
details[CZ_TIMEZONE == "AKST-9", CZ_TIMEZONE := "AKST"]
# AST-4 to AST
details[CZ_TIMEZONE == "AST-4", CZ_TIMEZONE := "AST"]
# CST-6 to CST
details[CZ_TIMEZONE == "CST-6", CZ_TIMEZONE := "CST"]
# EST-5 to EST
details[CZ_TIMEZONE == "EST-5", CZ_TIMEZONE := "EST"]
# HST-10 to HST
details[CZ_TIMEZONE == "HST-10", CZ_TIMEZONE := "HST"]
# MST-7 to MST
details[CZ_TIMEZONE == "MST-7", CZ_TIMEZONE := "MST"]
# PST-8 to PST
details[CZ_TIMEZONE == "PST-8", CZ_TIMEZONE := "PST"]
# SST-11 to SST
details[CZ_TIMEZONE == "SST-11", CZ_TIMEZONE := "SST"]

# Look at unique timezones again
unique_cz_timezone <- unique(details$CZ_TIMEZONE)
print(sort(unique_cz_timezone))

timezones <- data.table(abbr = c("AKST", "AST", "CDT", "CST", "ChST", 
                                 "EDT", "EST", "HST", "MDT", "MST", "PDT", 
                                 "PST", "SST"), 
                        long = c("America/Anchorage", "America/Halifax", 
                                 "America/Chicago", "America/Chicago", 
                                 "Pacific/Guam", "America/New_York", 
                                 "America/New_York", "Pacific/Honolulu", 
                                 "America/Denver", "America/Denver", 
                                 "America/Los_Angeles", "America/Los_Angeles", 
                                 "Pacific/Samoa"), 
                        offset = c("-0900", "-0400", "-0500", "-0600", "+1000", 
                                   "-0400", "-0500", "-1000", "-0600", "-0700", 
                                   "-0700", "-0800", "+0800"))

kable(timezones, caption = "Timezones")

# I think we need to isolate the timezones into their own datasets before 
# performing these operations below. 
# http://stackoverflow.com/questions/24592178/r-utc-to-local-time-given-olson-timezones

akst <- details[CZ_TIMEZONE == "AKST"]
ast <- details[CZ_TIMEZONE == "AST"]
cdt <- details[CZ_TIMEZONE == "CDT"]
chst <- details[CZ_TIMEZONE == "ChST"]
cst <- details[CZ_TIMEZONE == "CST"]
edt <- details[CZ_TIMEZONE == "EDT"]
est <- details[CZ_TIMEZONE == "EST"]
hst <- details[CZ_TIMEZONE == "HST"]
mdt <- details[CZ_TIMEZONE == "MDT"]
mst <- details[CZ_TIMEZONE == "MST"]
pdt <- details[CZ_TIMEZONE == "PDT"]
pst <- details[CZ_TIMEZONE == "PST"]
sst <- details[CZ_TIMEZONE == "SST"]

details <- details[CZ_TIMEZONE == "AST", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/Halifax")]

details <- details[CZ_TIMEZONE == "CDT", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/New_York")]

details <- details[CZ_TIMEZONE == "CST", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/Chicago")]

details <- details[CZ_TIMEZONE == "ChST", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "Pacific/Guam")]

details <- details[CZ_TIMEZONE == "EDT", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/Halifax")]

details <- details[CZ_TIMEZONE == "EST", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/New_York")]

details <- details[CZ_TIMEZONE == "HST", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "Pacific/Honolulu")]

details <- details[CZ_TIMEZONE == "MDT", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/Chicago")]

details <- details[CZ_TIMEZONE == "MST", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/Denver")]

details <- details[CZ_TIMEZONE == "PDT", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/Denver")]

details <- details[CZ_TIMEZONE == "PST", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "America/Los_Angeles")]

details <- details[CZ_TIMEZONE == "SST", 
                   BEGIN_YMDHMS:= force_tz(BEGIN_DATETIME, tz = "Pacific/Honolulu")]

details <- details[CZ_TIMEZONE == "AKST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/Anchorage")]

details <- details[CZ_TIMEZONE == "AST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/Halifax")]

details <- details[CZ_TIMEZONE == "CDT", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/New_York")]

details <- details[CZ_TIMEZONE == "CST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/Chicago")]

details <- details[CZ_TIMEZONE == "ChST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "Pacific/Guam")]

details <- details[CZ_TIMEZONE == "EDT", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/Halifax")]

details <- details[CZ_TIMEZONE == "EST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/New_York")]

details <- details[CZ_TIMEZONE == "HST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "Pacific/Honolulu")]

details <- details[CZ_TIMEZONE == "MDT", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/Chicago")]

details <- details[CZ_TIMEZONE == "MST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/Denver")]

details <- details[CZ_TIMEZONE == "PDT", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/Denver")]

details <- details[CZ_TIMEZONE == "PST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "America/Los_Angeles")]

details <- details[CZ_TIMEZONE == "SST", 
                   END_YMDHMS:= force_tz(END_DATETIME, tz = "Pacific/Honolulu")]

details <- details[, BEGIN_YMDHMS_UTC := with_tz(BEGIN_YMDHMS, tz = "UTC")]
details <- details[, END_YMDHMS_UTC := with_tz(END_YMDHMS, tz = "UTC")]

details <- details[, 
                   BEGIN_TIME_DIFF := difftime(BEGIN_YMDHMS_UTC, 
                                               BEGIN_DATETIME, 
                                               units = "hours")]
details <- details[, 
                   END_TIME_DIFF := difftime(END_YMDHMS_UTC, 
                                             END_DATETIME, 
                                             units = "hours")]

y <- details[, .SD[c(1, .N)], 
             by = CZ_TIMEZONE, 
             .SDcols = c("BEGIN_DATE_TIME", 
                         "BEGIN_DATETIME", 
                         "BEGIN_YMDHMS_UTC", 
                         "BEGIN_TIME_DIFF", 
                         "END_DATE_TIME", 
                         "END_DATETIME", 
                         "END_YMDHMS_UTC", 
                         "END_TIME_DIFF")
             ][order(CZ_TIMEZONE)]

