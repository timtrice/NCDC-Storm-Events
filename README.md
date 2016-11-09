[![Travis-CI Build Status](https://travis-ci.org/timtrice/NCDCStormEvents.svg?branch=v0.0.0.9000)](https://travis-ci.org/timtrice/NCDCStormEvents)

# README

This R package access the [NCDC Storm Events Database](https://www.ncdc.noaa.gov/stormevents/details.jsp) and provides tool to access the numerous datasets. 

There are three core datasets: `details`, `fatatities` and `locations`. The `details` and `fatalities` dataset dates back to 1951. The `locations` dataset dates back to 1996. 

Data is organized with `EPISODE_ID` as the root variable. `EPISODE_ID` has many `EVENT_ID` which acts as the primary key in `details`. Therefore, `fatalities` and `locations` are child tables of `details`. `FATALITY_ID` is the primary key in `fatalities`. 

The datasets provide a good opportunity for those looking to learn how to clean rather large datasets. There are also cleaning functions available to retrive clean data.
