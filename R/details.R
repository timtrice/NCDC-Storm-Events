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

#' @title get_details
#' @description Download the details datasets for \code{year}. 
#' @param year numeric vector with year(s) to retrieve data. Can be time-consuming.
#' @param clean clean the data if TRUE (default). Otherwise, return as-is.
#' @export
get_details <- function(year = NULL, clean = TRUE) {
  year <- check_year(year)
  summary <- get_listings()
  requested <- summary[Type == "details" & Year %in% year]
  dataset <- get_datasets(requested[, Name], 
                          details_names(), 
                          details_col_types())
  if(!clean)
    return(dataset)
  if(clean) {
    
    ## EPISODE_NARRATIVE
    # Extract dataset$EPISODE_NARRATIVE
    df_episode_narrative <- dataset %>% 
      dplyr::select(EVENT_ID, EPISODE_NARRATIVE)
    # Remove NAs
    df_episode_narrative <- df_episode_narrative[complete.cases(df_episode_narrative),]
    # Remove EPISODE_NARRATIVE from dataset
    dataset <- dplyr::select(dataset, -EPISODE_NARRATIVE)
    # Move to global environment
    assign("df_episode_narrative", df_episode_narrative, envir = .GlobalEnv)
    
    ## EVENT NARRATIVE
    df_event_narrative <- dataset %>% 
      dplyr::select(EVENT_ID, EVENT_NARRATIVE)
    # Remove NAs
    df_event_narrative <- df_event_narrative[complete.cases(df_event_narrative),]
    # Remove EVENT_NARRATIVE from dataset
    dataset <- dplyr::select(dataset, -EVENT_NARRATIVE)
    # Move to global environment
    assign("df_event_narrative", df_event_narrative, envir = .GlobalEnv)
    
    # Now focus on BEGIN_DATE_TIME and END_DATE_TIME. These variables will 
    # hold the properly-formatted date strings as characters since CZ_TIMEZONE 
    # is highly inaccurate.
    
    # I will pull year and month from BEGIN_YEARMONTH and date from BEGIN_DAY. 
    # I will pull time from BEGIN_DATE_TIME. New value in tmp variable `bdt`
    dataset <- dataset %>% 
      dplyr::mutate(bdt = as.character(
        paste(
          paste(
            stringr::str_extract(BEGIN_YEARMONTH, 
                                 pattern = "^[[:digit:]]{4}"), 
            stringr::str_extract(BEGIN_YEARMONTH, 
                                 pattern = "[[:digit:]]{2}$"), 
            stringr::str_pad(BEGIN_DAY, 
                             2, 
                             side = "left", 
                             pad = "0"), 
            sep = "-"), 
          stringr::str_extract(BEGIN_DATE_TIME, 
                               pattern = "[[:space:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}"), 
          sep = " "), 
        format = "%Y-%m-%d %T"))
    # Same thing but this time for END_DATE_TIME as tmp variable `edt`
    dataset <- dataset %>% 
      dplyr::mutate(edt = as.character(
        paste(
          paste(
            stringr::str_extract(END_YEARMONTH, 
                                 pattern = "^[[:digit:]]{4}"), 
            stringr::str_extract(END_YEARMONTH, 
                                 pattern = "[[:digit:]]{2}$"), 
            stringr::str_pad(END_DAY, 
                             2, 
                             side = "left", 
                             pad = "0"), 
            sep = "-"), 
          stringr::str_extract(END_DATE_TIME, 
                               pattern = "[[:space:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}"), 
          sep = " "), 
        format = "%Y-%m-%d %T"))
    
    # Now I can remove all of the original date/time variables
    dataset <- dataset %>% 
      dplyr::select(-(BEGIN_YEARMONTH:END_TIME), 
                    -(YEAR:MONTH_NAME), 
                    -(BEGIN_DATE_TIME:END_DATE_TIME))
    
    # Rename `bdt` and `edt`
    dataset <- dataset %>% 
      dplyr::rename(BEGIN_DATE_TIME = bdt, 
                    END_DATE_TIME = edt)
    
    # Clean STATE
    
    return(dataset)
  }
}

