#' @title clean_locations
#' @description "Clean" locations dataset
#' @details Nothing is cleaned at the moment; it is just reorganized. EPISODE_ID 
#' is dropped as it is redundant (in `details`).
#' 
#' I cannot find any documentation on what the purpose of LAT2 and LON2 is 
#' therefore it is untouched for the moment. No other values require cleaning 
#' at this time.
#' @param df Raw locations dataset
#' @return df Reorganized raw dataset
#' @export
clean_locations <- function(df) {
  df <- df %>% 
    dplyr::select(EVENT_ID, LOCATION_INDEX, LOCATION, RANGE, 
                  AZIMUTH, LATITUDE, LAT2, LONGITUDE, LON2)
  return(df)
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
#' @return dataframe Raw if clean is FALSE, reorganized if TRUE (default)
#' @export
get_locations <- function(year = NULL, clean = TRUE) {
  year <- .check_year(year)
  summary <- get_listings()
  requested <- summary %>% 
    dplyr::filter(Dataset == "locations", 
           Year %in% year)
  df <- .get_datasets(gz_names = requested$Name, 
                          cn = .locations_names(), 
                          ct = .locations_col_types())
  if(clean) {
    df <- clean_locations(df)
    assign("c.locations", df, envir = .GlobalEnv)
  } else {
    assign("locations", df, envir = .GlobalEnv)
  }
  return(TRUE)
}

#' @title .locations_col_types
#' @description return column types for readr::read_csv
.locations_col_types <- function() {
  # separated by line break based on fatalities_names() for legibility
  x <- paste0("iiiin", 
              "ccnnii")
  return(x)
}

#' @title .locations_names
#' @description return column names for readr::read_csv
.locations_names <- function() {
  x <- c("YEARMONTH", "EPISODE_ID", "EVENT_ID", "LOCATION_INDEX", "RANGE", 
         "AZIMUTH", "LOCATION", "LATITUDE", "LONGITUDE", "LAT2", "LON2")
  return(x)
}
