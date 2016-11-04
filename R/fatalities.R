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

#' @title get_fatalities
#' @description Download and, if clean is TRUE, clean fatalities datasets.
#' @details fatalities is the smallest of the datasets and thus, easiest to 
#'   clean. Originally, 11 variables are returned but many of those are related 
#'   to date or time which is included already in the FATALITY_DATE field. That 
#'   field is cleaned to a standard formatted date (%Y-%m-%d %T).
#'   
#'   Additionally, a second dataframe is generated: fatality_locations. This 
#'   dataframe can be joined to the fatalities dataframe by 
#'   `fatality_location_id`. It contains a generalized list of locations such 
#'   as business, home, golfing, in water, boating, etc. So it is a good field 
#'   to analyze where these fatalities have occurred.
#' @param year numeric vector with year(s) to retrieve data.
#' @param clean clean the data if TRUE (default). Otherwise, return as-is.
get_fatalities <- function(year = NULL, clean = TRUE) {
  year <- check_year(year)
  summary <- get_listings()
  requested <- summary[Type == "fatalities" & Year %in% year]
  dataset <- get_datasets(requested[, Name], 
                          fatalities_names(), 
                          fatalities_col_types())
  if(!clean)
    return(dataset)
  if(clean) {
    # FATALITY_DATE is in %m/%d/%Y %T format. Convert to "%Y-%m-%d %T"
    # without timezone; as.character
    dataset <- dataset %>% 
      dplyr::mutate(FATALITY_DATE = as.character(as.POSIXct(FATALITY_DATE, 
                                                            format = "%m/%d/%Y %T"), 
                                                 format = "%Y-%m-%d %T"))
    # Add dataset$fatality_location_id
    dataset <- dataset %>% 
      dplyr::bind_cols(clean_fatality_location(
        dataset %>% 
          dplyr::select(FATALITY_LOCATION)))
    
    # Return only select variables
    dataset <- dataset %>% 
      dplyr::select(EVENT_ID, FATALITY_ID, FATALITY_DATE, FATALITY_TYPE, 
                    FATALITY_AGE, FATALITY_SEX, fatality_location_id)
    
    return(dataset)
  }
}

clean_fatality_location <- function(ds) {
  df_fatality_locations <- fatality_locations()
  # Clean up some values
  ds$FATALITY_LOCATION <- gsub("Vehicle/Towed Trailer", 
                               "Vehicle and/or Towed Trailer", 
                               ds$FATALITY_LOCATION)
  ds$FATALITY_LOCATION <- gsub("Heavy Equipment/Construction", 
                               "Heavy Equip/Construction", 
                               ds$FATALITY_LOCATION)
  ds$FATALITY_LOCATION <- gsub("Other|Unknown", 
                               "Other/Unknown", 
                               ds$FATALITY_LOCATION)
  
  # Join original dataset with df_fatality_locations on FATALITY_LOCATION
  ds <- ds %>% 
    dplyr::left_join(df_fatality_locations, 
                     by = "FATALITY_LOCATION")
  
  # Select only ds$fatality_location_id
  ds <- ds %>% dplyr::select(fatality_location_id)
  
  # Make df_fatality_locations global
  assign('fatality_locations', df_fatality_locations, envir = .GlobalEnv)
  
  return(ds)
}