#' @title locations_col_types
#' @description return column types for readr::read_csv
locations_col_types <- function() {
  # separated by line break based on fatalities_names() for legibility
  x <- paste0("iiiin", 
              "ccnnii")
  return(x)
}

#' @title locations_names
#' @description return column names for readr::read_csv
locations_names <- function() {
  x <- c("YEARMONTH", "EPISODE_ID", "EVENT_ID", "LOCATION_INDEX", "RANGE", 
         "AZIMUTH", "LOCATION", "LATITUDE", "LONGITUDE", "LAT2", "LON2")
  return(x)
}

get_locations <- function() {
  ds_locations <- get_datasets(requested[Type == "locations", Name], 
                               locations_names(), 
                               locations_col_types())
}