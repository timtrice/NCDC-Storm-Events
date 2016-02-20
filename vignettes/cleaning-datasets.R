## ---- echo = FALSE, message = FALSE--------------------------------------
knitr::opts_chunk$set(collapse = TRUE, 
                      comment = "#>", 
                      fig.width = 7)

## ---- echo = FALSE, message = FALSE--------------------------------------
library(data.table)
library(ggplot2)
library(knitr)
library(lubridate)
library(maps)
library(NCDCStormEvents)

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

DT <- DT[, vars, with = FALSE]

## ------------------------------------------------------------------------
LUDT <- add_fips(DT[, .(EVENT_ID, CZ_FIPS, STATE_FIPS)])

str(LUDT)

head(LUDT)

## ------------------------------------------------------------------------
setkey(LUDT, FIPS)
setkeyv(Fips, c("FIPS", "TIME_ZONE"))
tmp <- Fips[LUDT, .(EVENT_ID, FIPS, TIME_ZONE), mult = "first"]
unique(tmp$TIME_ZONE)

## ------------------------------------------------------------------------
tmp[TIME_ZONE %in% "MP", TIME_ZONE := "M"]
tmp[TIME_ZONE %in% "CM", TIME_ZONE := "C"]

## ------------------------------------------------------------------------
tmp$TIME_ZONE <- toupper(tmp$TIME_ZONE)

## ------------------------------------------------------------------------
time_zones <- fips_tz_abbr()

tmp[, TZ := as.character(time_zones[TIME_ZONE]), by = TIME_ZONE]

## ------------------------------------------------------------------------
LUDT <- add_tz(tmp[, .(EVENT_ID, TZ)])
str(LUDT)

## ------------------------------------------------------------------------
tmp <- merge(LUDT[, .(EVENT_ID, TZ)], 
             DT[, c("CZ_FIPS", "STATE_FIPS") := NULL], by = "EVENT_ID")

## ------------------------------------------------------------------------
LUDT <- add_datetime(tmp)

## ------------------------------------------------------------------------
DT <- get_data(1965, "details")
tmp <- merge(LUDT[, .(EVENT_ID, TZ, BEGIN_DATE, END_DATE)], 
             DT[, .(EVENT_ID, BEGIN_DATE_TIME, END_DATE_TIME, STATE, 
                    CZ_NAME)], by = "EVENT_ID")

set.seed(1)
kable(tmp[, .SD[sample(.N, min(.N, 2))], by = "TZ"])

## ------------------------------------------------------------------------
kable(DT[EVENT_ID == 10148785 | EVENT_ID == 10065754, .(CZ_FIPS, 
                                                        STATE_FIPS)])

