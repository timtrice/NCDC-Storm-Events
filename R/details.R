#' @title details_col_types
#' @description return column types for readr::read_csv
details_col_types <- function() {
  # separated by line break based on details_names() for legibility
  x <- paste0("iiii", 
              "iiiic", 
              "iiccc", 
              "icccc", 
              "cii", 
              "iicc", 
              "cncci", 
              "cnnc", 
              "cic", 
              "icci", 
              "ccnnn", 
              "nccc")
  return(x)
}

#' @title details_names
#' @description return column names for readr::readr_csv
details_names <- function() {
  x <- c("BEGIN_YEARMONTH", "BEGIN_DAY", "BEGIN_TIME", "END_YEARMONTH", 
         "END_DAY", "END_TIME", "EPISODE_ID", "EVENT_ID", "STATE", 
         "STATE_FIPS", "YEAR", "MONTH_NAME", "EVENT_TYPE", "CZ_TYPE", 
         "CZ_FIPS", "CZ_NAME", "WFO", "BEGIN_DATE_TIME", "CZ_TIMEZONE", 
         "END_DATE_TIME", "INJURIES_DIRECT", "INJURIES_INDIRECT", 
         "DEATHS_DIRECT", "DEATHS_INDIRECT", "DAMAGE_PROPERTY", "DAMAGE_CROPS", 
         "SOURCE", "MAGNITUDE", "MAGNITUDE_TYPE", "FLOOD_CAUSE", "CATEGORY", 
         "TOR_F_SCALE", "TOR_LENGTH", "TOR_WIDTH", "TOR_OTHER_WFO", 
         "TOR_OTHER_CZ_STATE", "TOR_OTHER_CZ_FIPS", "TOR_OTHER_CZ_NAME", 
         "BEGIN_RANGE", "BEGIN_AZIMUTH", "BEGIN_LOCATION", "END_RANGE", 
         "END_AZIMUTH", "END_LOCATION", "BEGIN_LAT", "BEGIN_LON", "END_LAT", 
         "END_LON", "EPISODE_NARRATIVE", "EVENT_NARRATIVE", "DATA_SOURCE")
  return(x)
}

get_details <- function() {
  dataset <- get_datasets(requested[Type == "details", Name], 
                          details_names(), 
                          details_col_types())
}

