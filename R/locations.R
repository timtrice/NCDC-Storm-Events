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

get_locations <- function(year = NULL, clean = TRUE) {
  year <- check_year(year)
  summary <- get_listings()
  requested <- summary[Type == "locations" & Year %in% year]
  dataset <- get_datasets(requested[, Name], 
                          locations_names(), 
                          locations_col_types())
  if(!clean)
    return(dataset)
  if(clean) {
    dataset <- dataset %>% 
      dplyr::select(EVENT_ID, EPISODE_ID, LOCATION_INDEX, LOCATION, RANGE, 
                    AZIMUTH, LATITUDE, LAT2, LONGITUDE, LON2)
    return(dataset)
  }
}