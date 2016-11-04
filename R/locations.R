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

#' @title get_locations
#' @description Download the locations datasets for \code{year}. 
#' @details This dataset stores some location information of an event/episode.
#'   There can be multiple events per episode. 
#'   
#'   The raw data consists of the following variables in order of appearance 
#'   with brief descriptions according to the 
#'   \href{ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/Storm-Data-Export-Format.docx}{codebook} 
#'   or, if in italics, my best guess:
#'   
#'   \itemize{
#'     \item YEARMONTH \emph{year and month of event in \%Y\%m format.}
#'     \item EPISODE_ID ID assigned by NWS to note a storm episode. Has many `EVENT_ID`
#'     \item EVENT_ID ID assigned by NWS to note an event of an `EPISODE_ID`
#'     \item LOCATION_INDEX
#'     \item RANGE
#'     \item AZIMUTH
#'     \item LOCATION
#'     \item LATITUDE
#'     \item LONGITUDE
#'     \item LAT2
#'     \item LON2
#'   }
#'   
#' @param year numeric vector of year or years
#' @param clean TRUE by default; clean and reorganize dataset.
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