#' @title fatalities_col_types
#' @description return column types for readr::read_csv
fatalities_col_types <- function() {
  # separated by line break based on fatalities_names() for legibility
  x <- paste0("iiiii", 
              "ccic", 
              "ci")
  return(x)
}

#' @title fatalities_names
#' @description return column names for readr::read_csv
fatalities_names <- function() {
  x <- c("FAT_YEARMONTH", "FAT_DAY", "FAT_TIME", "FATALITY_ID", "EVENT_ID", 
         "FATALITY_TYPE", "FATALITY_DATE", "FATALITY_AGE", "FATALITY_SEX", 
         "FATALITY_LOCATION", "EVENT_YEARMONTH")
  return(x)
}

get_fatalities <- function() {
  ds_fatalities <- get_datasets(requested[Type == "fatalities", Name], 
                                fatalities_names(), 
                                fatalities_col_types())
}