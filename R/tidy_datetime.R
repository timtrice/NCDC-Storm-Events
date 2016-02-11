library(data.table)
library(lubridate)
library(knitr)
library(tidyr)

# For the purposes of this script, only need date fields. 
details <- fread("data/details.csv", 
                 na.strings = c("NA", ""), 
                 select = c("V1", "BEGIN_DAY", "END_DAY", "BEGIN_DATE_TIME", 
                            "CZ_TIMEZONE", "END_DATE_TIME", "YEAR", 
                            "MONTH_NAME", "CZ_NAME", "STATE"))

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

# For consistency, I'll make all abbr's upper case
details <- details[, CZ_TIMEZONE := toupper(CZ_TIMEZONE)]

# Update GMT timezone to CST
details[CZ_TIMEZONE == "GMT", CZ_TIMEZONE := "CST"]

# Hampden, MA
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "HAMPDEN" & STATE == "MASSACHUSETTS", 
        CZ_TIMEZONE := "EST"]

# LOVE, OK
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "LOVE" & STATE == "OKLAHOMA", 
        CZ_TIMEZONE := "CST"]

# Rush, IN
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "RUSH" & STATE == "INDIANA", 
        CZ_TIMEZONE := "EST"]

# McLennan, TX
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "MCLENNAN" & STATE == "TEXAS", 
        CZ_TIMEZONE := "CST"]

# OCONEE, GA
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "OCONEE" & STATE == "GEORGIA", 
        CZ_TIMEZONE := "EST"]

# COLES, IL
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "COLES" & STATE == "ILLINOIS", 
        CZ_TIMEZONE := "CST"]

# PERKINS, SD
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "PERKINS" & STATE == "SOUTH DAKOTA", 
        CZ_TIMEZONE := "MST"]

# HAWAII, HAWAII
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "HAWAII" & STATE == "HAWAII", 
        CZ_TIMEZONE := "HST"]

# ARMSTRONG, TEXAS
details[CZ_TIMEZONE == "UNK" & CZ_NAME == "ARMSTRONG" & STATE == "TEXAS", 
        CZ_TIMEZONE := "CST"]

# Shawano, WI
details[CZ_TIMEZONE == "SCT" & CZ_NAME == "SHAWANO" & STATE == "WISCONSIN", 
        CZ_TIMEZONE := "CST"]

# Guam
details[CZ_TIMEZONE == "SST" & STATE == "GUAM", 
        CZ_TIMEZONE := "ChST"]

# Guam Coastal Waters
details[CZ_TIMEZONE == "SST" & CZ_NAME == "GUAM COASTAL WATERS", 
        CZ_TIMEZONE := "ChST"]

# Correct typo
details[CZ_TIMEZONE == "CSC", CZ_TIMEZONE := "CST"]

# Convert Guam time to ChSt
details[CZ_TIMEZONE == "GST10", CZ_TIMEZONE := "ChST"]

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

# For shorter code in 2-3-datetime-timezones.R
# CDT to CST
details[CZ_TIMEZONE == "CDT", CZ_TIMEZONE := "CST"]

# EDT to EST
details[CZ_TIMEZONE == "EDT", CZ_TIMEZONE := "EST"]

# MDT to MST
details[CZ_TIMEZONE == "MDT", CZ_TIMEZONE := "MST"]

# PDT to PST
details[CZ_TIMEZONE == "PDT", CZ_TIMEZONE := "PST"]


# Start assigning timezones by CZ_TIMEZONE
details <- details[CZ_TIMEZONE == "AKST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX,
                                              tz = "America/Anchorage")]
details <- details[CZ_TIMEZONE == "AKST", 
                   END_YMDHMS_L := force_tz(EDT_POSIX, 
                                            tz = "America/Anchorage")]

details <- details[CZ_TIMEZONE == "AST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/Halifax")]
details <- details[CZ_TIMEZONE == "AST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                           tz = "America/Halifax")]

details <- details[CZ_TIMEZONE == "CST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/Chicago")]
details <- details[CZ_TIMEZONE == "CST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                           tz = "America/Chicago")]

details <- details[CZ_TIMEZONE == "ChST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "Pacific/Guam")]
details <- details[CZ_TIMEZONE == "ChST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                           tz = "Pacific/Guam")]

details <- details[CZ_TIMEZONE == "EST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/New_York")]
details <- details[CZ_TIMEZONE == "EST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                           tz = "America/New_York")]

details <- details[CZ_TIMEZONE == "HST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "Pacific/Honolulu")]
details <- details[CZ_TIMEZONE == "HST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                           tz = "Pacific/Honolulu")]

details <- details[CZ_TIMEZONE == "MST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/Denver")]
details <- details[CZ_TIMEZONE == "MST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                           tz = "America/Denver")]

details <- details[CZ_TIMEZONE == "PST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "America/Los_Angeles")]
details <- details[CZ_TIMEZONE == "PST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                           tz = "America/Los_Angeles")]

details <- details[CZ_TIMEZONE == "SST", 
                   BEGIN_YMDHMS_L := force_tz(BDT_POSIX, 
                                              tz = "Pacific/Samoa")]
details <- details[CZ_TIMEZONE == "SST", 
                   END_YMDHMS_L:= force_tz(EDT_POSIX, 
                                           tz = "Pacific/Samoa")]

details <- details[, BEGIN_YMDHMS_UTC := with_tz(BEGIN_YMDHMS_L, tz = "UTC")]
details <- details[, END_YMDHMS_UTC := with_tz(END_YMDHMS_L, tz = "UTC")]


# Now that we have clean data, bind back into complete dataset and drop other vars
# At this point I've already sampled the data for accuracy. 

# Drop all but the two vars we need, our completed datetime UTC vars
details <- details[, .(ID, BEGIN_YMDHMS_UTC, END_YMDHMS_UTC)]

# Read in our original datasets::
dt <- fread("data/details.csv", na.strings = c("NA", ""))
setnames(dt, "V1", "ID")

# We'll drop the vars we don't need anymore
dt <- dt[, c("BEGIN_YEARMONTH", "BEGIN_DAY", "BEGIN_TIME", 
             "END_YEARMONTH", "END_DAY", "END_TIME", "YEAR", 
             "MONTH_NAME", "BEGIN_DATE_TIME", "CZ_TIMEZONE", 
             "END_DATE_TIME") := NULL]

# And now combine datasets. 
setkey(details, ID)
setkey(dt, ID)
final <- details[dt]

# Drop ID which was just row numbers; not needed anymore
final <- final[, c("ID") := NULL]

rm(dt)
rm(details)


# Write final dataset

# CSV
write.csv(final, "data/clean-details.csv", row.names = FALSE)

# RDS
saveRDS(final, "data/clean-details.rds")
