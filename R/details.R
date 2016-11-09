#' @title clean_details
#' @description Clean most variables in the details dataset.
#' @details Specifically what is changed:
#' \itemize{
#'   \item BEGIN_DATE_TIME, END_DATE_TIME reformatted to "%Y-%m-%d %T", 
#'     character class with no timezone.
#'   \item EVENT_TYPE is moved into its own dataframe and cleaned up to match 
#'     requirements in \href{http://www.nws.noaa.gov/directives/sym/pd01016005curr.pdf}{NWS Instruction 10-1605, March 23, 2016}, 
#'     Section 2.1.1, pg. 6
#'   \item DAMAGE_PROPERTY reformatted to numeric values
#'   \item DAMAGE_CROPS reformatted to numeric values
#'   \item FLOOD_CAUSE removed spaces between slashes
#' }
#' 
#' Variables removed:
#' \itemize{
#'   \item BEGIN_YEARMONTH
#'   \item BEGIN_DAY
#'   \item BEGIN_TIME
#'   \item END_YEARMONTH
#'   \item END_DAY
#'   \item END_TIME
#'   \item YEAR
#'   \item MONTH_NAME
#'   \item CZ_TIMEZONE
#'   \item EVENT_TYPE (located in `details_event_types`)
#' }
#' @param df Raw `details` dataset.
#' @return Clean dataframe
#' @export
clean_details <- function(df) {
  # BEGIN_DATE_TIME
  details_begin_date_time <- details_date_time(
    df %>% 
      dplyr::select(EVENT_ID, BEGIN_YEARMONTH, BEGIN_DAY, BEGIN_DATE_TIME))
  
  # END_DATE_TIME
  details_end_date_time <- details_date_time(
    df %>% 
      dplyr::select(EVENT_ID, END_YEARMONTH, END_DAY, END_DATE_TIME))
  
  df <- df %>% 
    dplyr::select(-(BEGIN_YEARMONTH:END_TIME), 
                  -(YEAR:MONTH_NAME), 
                  -(BEGIN_DATE_TIME:END_DATE_TIME))
  
  ## Join the new date_time variables
  df <- df %>% 
    dplyr::left_join(details_begin_date_time, by = "EVENT_ID") %>% 
    dplyr::left_join(details_end_date_time, by = "EVENT_ID")
  
  # EVENT_TYPE
  df_event_types <- details_event_types(
    df %>% 
      dplyr::select(EVENT_ID, EVENT_TYPE))
  df$EVENT_TYPE <- NULL

  # DAMAGE_PROPERTY
  df_damage_property <- details_damages(
    df %>% 
      dplyr::select(EVENT_ID, DAMAGE_PROPERTY))
  df$DAMAGE_PROPERTY <- NULL
  df <- df %>% 
    dplyr::left_join(df_damage_property, by = "EVENT_ID")
  
  # DAMAGE_CROPS
  df_damage_crops <- details_damages(
    df %>% 
      dplyr::select(EVENT_ID, DAMAGE_CROPS))
  df$DAMAGE_CROPS <- NULL
  df <- df %>% 
    dplyr::left_join(df_damage_crops, by = "EVENT_ID")
  
  # FLOOD_CAUSE
  flood_cause <- details_flood_cause(
    df %>% 
      dplyr::select(EVENT_ID, FLOOD_CAUSE))
  df$FLOOD_CAUSE <- NULL
  df %>% 
    dplyr::left_join(flood_cause, 
                     by = "EVENT_ID")

  return(df)
}

#' @title .details_category
#' @description filter non-NA values of CATEGORY
#' @details Deprecated for the time-being
#' @param df[,c("EVENT_ID", "CATEGORY")]
.details_category <- function(df) {
  categories <- dff_categories()
  df <- df[complete.cases(df),]
  assign("categories", categories, envir = .GlobalEnv)
  assign("details_categories", df, envir = .GlobalEnv)
  return(TRUE)
}

#' @title .details_col_types
#' @description return column types for readr::read_csv
#' @return string of values for each column class for raw `details` dataset
.details_col_types <- function() {
  # separated by line break based on .details_names() for legibility
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

#' @title details_damages
#' @description Clean DAMAGE_PROPERTY or DAMAGE_CROPS
#' @details In each of these variables values are often represented like 2.5K or 
#' 3M or 0.09K. The character key and numeric value are extracted then value is
#' multipled against k:
#' \itemize{
#'   \item B 1e+09
#'   \item M 1e+06
#'   \item K 1e+03
#'   \item H 1e+02
#' }
#' Numeric values replace the string values of the original variable. Values of 
#' 0 and NA are removed.
#' @param df A dataframe containing EVENT_ID and one of DAMAGE_PROPERTY or DAMAGE_CROPS
#' @return A dataframe with EVENT_ID and cleaned DAMAGE_PROPERTY or DAMAGE_CROPS, numeric
#' @export
details_damages <- function(df) {
  
  x <- ifelse("DAMAGE_PROPERTY" %in% names(df), "DAMAGE_PROPERTY", "DAMAGE_CROPS")
  
  colnames(df)[2] <- "damage"
  
  df <- df %>% 
    dplyr::mutate(
      key = stringr::str_extract(
        damage, 
        "[[:alpha:]]$"), 
      value = stringr::str_extract(
        damage, 
        "^[[:digit:][:punct:]]+"))
  
  k <- list("B" = 1e+09, "M" = 1e+06, "K" = 1e+03, "H" = 1e+02)
  
  df$value[df$value == 0] <- NA
  
  df <- df %>% 
    dplyr::mutate(ndamage = ifelse(!is.na(value), as.numeric(value) * k[key][[1]], NA)) %>% 
    dplyr::select(EVENT_ID, ndamage)
  
  colnames(df)[2] <- x

  return(df)
}

#' @title details_date_time
#' @description Reformat BEGIN_DATE_TIME or END_DATE_TIME to '%Y-%m-%d %T' format.
#' @details Takes one of details$BEGIN_DATE_TIME or details$END_DATE_TIME 
#' along with details$[BEGIN|END]_YEARMONTH, details$[BEGIN|END]_DAY 
#' and returns a clean, reformatted value of class character with no timezone. 
#' Times are assumed to be local times.
#' @param df A dataframe with EVENT_ID and *_YEARMONTH, *_DAY and *_DATE_TIME 
#'   where * is one of either BEGIN or END.
#' @return A dataframe with EVENT_ID and *_DATE_TIME in in '%Y-%m-%d %H:%M:%S' format.
#' @export
details_date_time <- function(df) {
  x <- ifelse("BEGIN_DAY" %in% names(df), "BEGIN", "END")
  # Rename variables
  colnames(df) <- c("EVENT_ID", "YEARMONTH", "DAY", "DATE_TIME")
  df <- df %>% 
    dplyr::mutate(y = stringr::str_extract(YEARMONTH, pattern = "^[[:digit:]]{4}"), 
           m = stringr::str_extract(YEARMONTH, pattern = "[[:digit:]]{2}$"), 
           d = stringr::str_pad(DAY, 2, side = "left", pad = "0"), 
           hms = stringr::str_extract(
             DATE_TIME, pattern = "[[:space:]][[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}"), 
           dt = as.character(
             paste(paste(y, m, d, sep = "-"), hms, sep = " "), 
             format = "%Y-%m-%d %T")) %>% 
    dplyr::select(EVENT_ID, dt)
  
  if(x == "BEGIN") {
    df <- df %>% dplyr::rename(BEGIN_DATE_TIME = dt)
  } else {
    df <- df %>% dplyr::rename(END_DATE_TIME = dt)
  }
  return(df)
}

#' @title .details_episode_narratives
#' @description Extract details$EPISODE_NARRATIVES and move to Global env.
#' @details Builds two-column dataframe if not empty with no NAs
#'   \itemize{
#'     \item EVENT_ID
#'     \item EPISODE_NARRATIVE
#'   }
#' 
#' Deprecated for the time being
#' 
#' @return TRUE on success
.details_episode_narratives <- function(df) {
  df <- df[complete.cases(df),]
  if(nrow(df) > 0)
    assign("details_episode_narratives", df, envir = .GlobalEnv)
  return(TRUE)
}

#' @title .details_event_narratives
#' @description Extract details$EVENT_NARRATIVES and move to Global env.
#' @details Builds two-column dataframe if not empty with no NAs
#'   \itemize {
#'     \item EVENT_ID
#'     \item EPISODE_NARRATIVE
#'   }
#' 
#' Deprecated for the time-being
#' 
#' @return TRUE on success
.details_event_narratives <- function(df) {
  df <- df[complete.cases(df),]
  if(nrow(df) > 0)
    assign("details_event_narratives", df, envir = .GlobalEnv)
  return(TRUE)
}

#' @title details_event_types
#' @description Extract details$EVENT_TYPE and move to new dataframe.
#' @details details$EVENT_TYPE consists mostly of single values. Some `EVENT_ID` 
#' have multiple `EVENT_TYPE`. These are split into single values and cleaned up 
#' to match values in 
#' \href{NWS Instruction 10-1605, March 23, 2016}{http://www.nws.noaa.gov/directives/sym/pd01016005curr.pdf} 
#' Section 2.1.1, pg. 6.
#' 
#' Because this could potentially duplicate `EVENT_ID` it is kept separate from 
#' details.
#' @param df A dataframe with EVENT_ID and EVENT_TYPE
#' @return TRUE on success
#' @export
details_event_types <- function(df) {
  # Convert to matrix for speed
  df <- as.matrix(df)

  # Clean data
  df[,2] <- tolower(df[,2])
  # Normalize
  df[,2] <- gsub("^landslide|northern lights|other|/ tree[s]*|/icy roads$", NA, df[,2])
  df[,2] <- gsub("thunderstorm winds|tstm wind", "thunderstorm wind", df[,2])
  df[,2] <- gsub("thunderstorm wind[ /]+heavy rain", "thunderstorm wind,heavy rain", df[,2])
  df[,2] <- gsub("/flash flood", ",flash flood", df[,2])
  df[,2] <- gsub("/flooding|/ flood", ",flood", df[,2])
  df[,2] <- gsub(" funnel clou$", ",funnel cloud", df[,2])
  df[,2] <- gsub(" lightning$", ",lightning", df[,2])
  df[,2] <- gsub("tornado/waterspout", "tornado,waterspout", df[,2])
  df[,2] <- gsub("tornadoes", "tornado", df[,2])
  df[,2] <- gsub("^hail[[:blank:]]flooding$", "hail,flooding", df[,2])
  # Correct specific values
  df[,2] <- gsub("^cold/wind chill$", "extreme cold/wind chill", df[,2])
  df[,2] <- gsub("^volcanic ashfall$", "volcanic ash", df[,2])
  df[,2] <- gsub("^heavy wind$", "high wind", df[,2])
  df[,2] <- gsub("^high snow$", "heavy snow", df[,2])
  df[,2] <- gsub("^hurricane$", "hurricane (typhoon)", df[,2])
  df[,2] <- gsub("^sneakerwave$", "sneaker wave", df[,2])
  # Clean up
  df[,2] <- gsub(", ", ",", df[,2])
  df[,2][df[,2] == ""] <- NA
  # Conver back to dataframe
  df <- as.data.frame(df, stringsAsFactors = FALSE)
  
  # Temporarily disable warnings for tidyr::separate
  opt_warn <- getOption("warn")
  options(warn = -1)
  # Separate and gather
  df <- df %>% 
    tidyr::separate(EVENT_TYPE, 
             c("EVENT1", "EVENT2", "EVENT3"), 
             sep = ",") %>% 
    tidyr::gather(event, type, EVENT1:EVENT3)
  options(warn = opt_warn)
  
  df$event <- NULL
  colnames(df)[2] <- "EVENT_TYPE"
  df <- df[complete.cases(df),]
  df$EVENT_TYPE <- trimws(df$EVENT_TYPE)
  event_types <- dff_event_types()
  # Join to get event_type_id
  df <- df %>% 
    dplyr::left_join(event_types %>% 
                       dplyr::mutate(EVENT_TYPE = tolower(EVENT_TYPE)), 
                     by = "EVENT_TYPE")
  df$EVENT_TYPE <- NULL
  # Join again to get proper-case EVENT_TYPE
  df <- df %>%
    dplyr::left_join(event_types, 
                     by = "event_type_id")
  df$event_type_id <- NULL
  df$EVENT_ID <- as.integer(df$EVENT_ID)
  assign("details_event_types", df, envir = .GlobalEnv)
  return(TRUE)
}

#' @title details_flood_cause
#' @description Clean details$FLOOD_CAUSE
#' @param df A dataframe with EVENT_ID and FLOOD_CAUSE
#' @return Complete.cases dataframe with clean FLOOD_CAUSE values.
#' @export
details_flood_cause <- function(df) {
  df <- df[complete.cases(df),]
  df$FLOOD_CAUSE[df$FLOOD_CAUSE == "Dam / Levee Break"] = "Dam/Levee Break"
  df$FLOOD_CAUSE[df$FLOOD_CAUSE == "Heavy Rain / Burn Area"] = "Heavy Rain/Burn Area"
  df$FLOOD_CAUSE[df$FLOOD_CAUSE == "Heavy Rain / Snow Melt"] = "Heavy Rain/Snow Melt"
  df$FLOOD_CAUSE[df$FLOOD_CAUSE == "Heavy Rain / Tropical System"] = "Heavy Rain/Tropical System"
  return(df)
}

#' @title .details_names
#' @description return column names for readr::readr_csv
#' @return vector of column names for raw `details` dataset
.details_names <- function() {
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
#' @details 
#'   A warning message will be generated.
#' 
#'   \emph{Too few values at n locations}
#' 
#'   This is acceptable. EVENT_TYPES is rebuilt to capture one event type per 
#'   row. In most cases there is only one or two event types per event but there 
#'   can be at most 3 (so far). The message is simply stating there are not 3 
#'   event types for each row (location). This message is generated by 
#'   tidyr::separate.
#' @param year numeric vector with year(s) to retrieve data.
#' @param clean clean the data if TRUE (default). Otherwise, return as-is.
#' @export
get_details <- function(year = NULL, clean = TRUE) {
  year <- .check_year(year)
  summary <- get_listings()
  requested <- summary %>% 
    dplyr::filter(Dataset == "details", 
           Year %in% year)
  df <- .get_datasets(gz_names = requested$Name, 
                          cn = .details_names(), 
                          ct = .details_col_types())
  if(clean) {
    df <- clean_details(df)
    assign("c.details", df, envir = .GlobalEnv)
  } else {
    assign("details", df, envir = .GlobalEnv)
  }
  return(TRUE)
}

