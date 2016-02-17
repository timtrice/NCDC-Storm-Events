## ---- echo = FALSE, message = FALSE--------------------------------------
knitr::opts_chunk$set(collapse = TRUE, 
                      comment = "#>", 
                      fig.width = 7)

## ---- echo = FALSE, message = FALSE--------------------------------------
library(NCDCStormEvents)
library(data.table)
library(ggplot2)
library(maps)

## ------------------------------------------------------------------------
DT <- get_data(1965, "details")

unique(DT$CZ_TIMEZONE)

tz_to_dt(DT[, .(EVENT_ID, CZ_TIMEZONE)])

## ---- fig.asp = 0.5------------------------------------------------------
tmp <- DT[MDT, .(EVENT_ID, CZ_NAME, STATE, CZ_TIMEZONE, BEGIN_LAT, 
                 BEGIN_LON)]

US <- map_data("state")

bp <- list(geom_polygon(data = US, aes(x = long, y = lat, group = group), 
                 colour = "grey10", fill = "white"), 
           geom_point(size = 1, colour = "red"))

ggplot(tmp, aes(x = BEGIN_LON, y = BEGIN_LAT)) + bp

## ------------------------------------------------------------------------
tmp

## ---- fig.asp = 0.5------------------------------------------------------
tmp <- DT[CZ_TIMEZONE == "MDT", .(EVENT_ID, CZ_NAME, STATE, CZ_TIMEZONE, 
                                  BEGIN_LAT, BEGIN_LON)]
ggplot(tmp, aes(x = BEGIN_LON, y = BEGIN_LAT)) + bp

tmp

## ------------------------------------------------------------------------
tmp <- DT[EST, .(EVENT_ID, CZ_NAME, STATE, CZ_TIMEZONE, BEGIN_LAT, BEGIN_LON)]

ggplot(tmp, aes(x = BEGIN_LON, y = BEGIN_LAT)) + bp

## ---- fig.asp = 0.7------------------------------------------------------
tmp <- DT[CST, .(EVENT_ID, CZ_NAME, STATE, CZ_TIMEZONE, BEGIN_LAT, BEGIN_LON)]

ggplot(tmp, aes(x = BEGIN_LON, y = BEGIN_LAT)) + bp

## ---- fig.asp = 0.5------------------------------------------------------
fips <- fips_dt()

tmp <- fips[TIME_ZONE == "E", .(LAT, LON)]

ggplot(tmp, aes(x = LON, y = LAT)) + bp

## ------------------------------------------------------------------------
fips_tz_abbr()

## ------------------------------------------------------------------------
DT <- get_data(1965, type = "details")
Fips <- fips_dt()

## ------------------------------------------------------------------------
datetime_fields()

## ------------------------------------------------------------------------
vars <- c(datetime_fields(), "CZ_FIPS", "STATE_FIPS")

tmp <- DT[, vars, with = FALSE]

## ------------------------------------------------------------------------
tmp[, FIPS := sprintf("%02d%03d", STATE_FIPS, CZ_FIPS)]

## ------------------------------------------------------------------------
setkey(tmp, FIPS)
setkey(Fips, FIPS)
clean <- Fips[tmp, mult = "first"]

## ------------------------------------------------------------------------
unique(clean$TIME_ZONE)

## ------------------------------------------------------------------------
clean[TIME_ZONE %in% "MP", TIME_ZONE := "M"]
clean[TIME_ZONE %in% "CM", TIME_ZONE := "C"]

## ------------------------------------------------------------------------
clean$TIME_ZONE <- toupper(clean$TIME_ZONE)

## ------------------------------------------------------------------------
time_zones <- fips_tz_abbr()

# Not sure I like handling it this way... print str()
clean[, TZ := time_zones[TIME_ZONE]]

