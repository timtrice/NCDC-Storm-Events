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
