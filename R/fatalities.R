#' @title clean_fatalities
#' @description Clean the fatalities dataset
#' @details Minor changes. 
#' 
#' FATALITY_DATE is reformatted to '%Y-%m-%d %Y' format. 
#' FATALITY_LOCATION is cleaned up to match 
#' \href{NWS Instruction 10-1605, March 23, 2016}{http://www.nws.noaa.gov/directives/sym/pd01016005curr.pdf}
#' Section 2.6.1.2, p. 11
#' 
#' Varaiables removed:
#' \itemize{
#'   \item FAT_YEARMONTH
#'   \item FAT_DAY
#'   \item FAT_TIME
#'   \item EVENT_YEARMONTH
#' }
#' @param df Raw fatalities dataset
#' @return df[,c("EVENT_ID", "FATALITY_ID", "FATALITY_DATE", "FATALITY_TYPE", "FATALITY_AGE", "FATALITY_SEX", "FATALITY_LOCATION")]
#' @export
clean_fatalities <- function(df) {
  # FATALITY_DATE is in %m/%d/%Y %T format. Convert to "%Y-%m-%d %T"
  # without timezone; as.character
  df <- df %>% 
    dplyr::mutate(FATALITY_DATE = as.character(as.POSIXct(FATALITY_DATE, 
                                                          format = "%m/%d/%Y %T"), 
                                               format = "%Y-%m-%d %T"))
  
  # Clean FATALITY_LOCATION
  fatality_locations <- fatalities_fatality_location(
    df %>% dplyr::select(FATALITY_ID, FATALITY_LOCATION))
  
  df$FATALITY_LOCATION <- NULL
  df <- df %>% dplyr::left_join(fatality_locations, by = "FATALITY_ID")
  
  # Return only select variables
  df <- df %>% 
    dplyr::select(EVENT_ID, FATALITY_ID, FATALITY_DATE, FATALITY_TYPE, 
                  FATALITY_AGE, FATALITY_SEX, FATALITY_LOCATION)
  return(df)
}

#' @title fatalities_fatality_location
#' @description Clean FATALITY_LOCATION to match NWS specifications.
#' @details See 
#' \href{NWS Instruction 10-1605, March 23, 2016}{http://www.nws.noaa.gov/directives/sym/pd01016005curr.pdf}
#' Section 2.6.1.2, p. 11 for valid fatality locations.
#' @param df[,c("FATALITY_ID", "FATALITY_LOCATION")]
#' @return df Clean dataframe
#' @export
fatalities_fatality_location <- function(df) {
  df_fatality_locations <- dff_fatality_locations()
  # Clean up some values
  df$FATALITY_LOCATION <- gsub("Vehicle/Towed Trailer", 
                               "Vehicle and/or Towed Trailer", 
                               df$FATALITY_LOCATION)
  df$FATALITY_LOCATION <- gsub("Heavy Equipment/Construction", 
                               "Heavy Equip/Construction", 
                               df$FATALITY_LOCATION)
  df$FATALITY_LOCATION <- gsub("Other|Unknown", 
                               "Other/Unknown", 
                               df$FATALITY_LOCATION)
  
  # Join original dataset with df_fatality_locations on FATALITY_LOCATION
  df <- df %>% 
    dplyr::left_join(df_fatality_locations, 
                     by = "FATALITY_LOCATION")
  # Drop fatality_location_id
  df$fatality_location_id <- NULL
  return(df)
}

#' @title .fatalities_col_types
#' @return string Return string as column classes for readr::read_csv
.fatalities_col_types <- function() {
  # separated by line break based on fatalities_names() for legibility
  x <- paste0("iiiii", 
              "ccic", 
              "ci")
  return(x)
}

#' @title .fatalities_names
#' @return x Character vector of column names for readr::read_csv
.fatalities_names <- function() {
  x <- c("FAT_YEARMONTH", "FAT_DAY", "FAT_TIME", "FATALITY_ID", "EVENT_ID", 
         "FATALITY_TYPE", "FATALITY_DATE", "FATALITY_AGE", "FATALITY_SEX", 
         "FATALITY_LOCATION", "EVENT_YEARMONTH")
  return(x)
}

#' @title get_fatalities
#' @description Download and, if clean is TRUE, clean fatalities datasets.
#' @details In this dataset, FATALITY_ID is the primary key. EVENT_ID is the 
#' foreign key to JOIN to the details or locations dataset.
#' @param year numeric vector with year(s) to retrieve data.
#' @param clean clean the data if TRUE (default). Otherwise, return as-is.
#' @examples 
#' \dontrun{
#' # Clean fatalities
#' get_fatalities(2015)
#' }
#' \dontrun{
#' # Raw fatalities
#' get_fatalities(2015, clean = FALSE)
#' }
#' @return dataframe fatalities dataset
#' @export
get_fatalities <- function(year = NULL, clean = TRUE) {
  year <- .check_year(year)
  summary <- get_listings()
  requested <- summary %>% 
    dplyr::filter(Dataset == "fatalities", 
           Year %in% year)
  df <- .get_datasets(gz_names = requested$Name, 
                          cn = .fatalities_names(), 
                          ct = .fatalities_col_types())
  if(clean) {
    df <- clean_fatalities(df)
    assign("c.fatalities", df, envir = .GlobalEnv)
  } else {
    assign("fatalities", df, envir = .GlobalEnv)
  }
  return(TRUE)
}
