#' NCDCStormEvents: Download and clean datasets from the NCDC Storm Events Database
#'
#' The NCDC Storm Events Database is a collection of datasets from 1951 displaying 
#' storm-related information. There are three core datasets: details, fatalities 
#' and locations. The details dataset is considered the root dataset. Both 
#' fatalities and locations are children datasets.
#' 
#' 'EVENT_ID' is the foreign key variable and also the primary key variable in 
#' details. 'FATALITY_ID' is the primary key in fatalities. 
#' 
#' Each dataset contains numerous variables that are redundant; specifically 
#' date/time variables. These datasets can be returned filtered (clean) or as-is
#' (raw).
#' 
#' @docType package
#' @name NCDCStormEvents
NULL
