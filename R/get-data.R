#' @title ds_url
#' @description URL to download files
ds_url <- function() {
    "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles"
}

#' @title types_available
#' @description types of datasets available
types_available <- function() {
    c("details", "fatalities", "locations")
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

#' @title details_col_types
#' @description return column types for readr::read_csv
details_col_types <- function() {
  # separated by line break based on details_names() for legibility
  x <- paste0("iiii", 
              "iiiic", 
              "iiccc", 
              "ccccc", 
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

#' @title fatalities_names
#' @description return column names for readr::read_csv
fatalities_names <- function() {
  x <- c("FAT_YEARMONTH", "FAT_DAY", "FAT_TIME", "FATALITY_ID", "EVENT_ID", 
         "FATALITY_TYPE", "FATALITY_DATE", "FATALITY_AGE", "FATALITY_SEX", 
         "FATALITY_LOCATION", "EVENT_YEARMONTH")
  return(x)
}

#' @title fatalities_col_types
#' @description return column types for readr::read_csv
fatalities_col_types <- function() {
  # separated by line break based on fatalities_names() for legibility
  x <- paste0("iiiii", 
              "ccic", 
              "ci")
  return(x)
}

#' @title locations_names
#' @description return column names for readr::read_csv
locations_names <- function() {
  x <- c("YEARMONTH", "EPISODE_ID", "EVENT_ID", "LOCATION_INDEX", "RANGE", 
         "AZIMUTH", "LOCATION", "LATITUDE", "LONGITUDE", "LAT2", "LON2")
  return(x)
}

#' @title locations_col_types
#' @description return column types for readr::read_csv
locations_col_types <- function() {
  # separated by line break based on fatalities_names() for legibility
  x <- paste0("iiiin", 
              "ccnnii")
  return(x)
}

#' Get listing of files from NCDC Storm Events
#'
#' Get listing of all datasets off the NCDC Storm Events website. 
#' 
#' The function returns a data table showing all StormEvents files listed 
#'      on the NCDC server. 
#' 
#' The data table contains the following variables:  
#' 
#' * \emph{Name} Filename of the dataset
#' 
#' * \emph{Modified} Modified date of the dataset
#' 
#' * \emph{Size} Size of the gzip file. 
#' 
#' * \emph{Type} One of c("details", "fatalities", "locations")
#' 
#' * \emph{Year} Year of dataset
#' 
#' This function was created because many datasets listed are empty 
#'      (typically those listed as 147b file size). And a large majority of 
#'      them are very small but do have content. However, in the more 
#'      recent years some of the datasets grow in size exponentially.
#' 
#' So this data table helps give insight into gathering data without 
#'      overloading on resources. For example, you may want ten years of 
#'      all data. And, in the early years you can do this very quickly. 
#'      However, doing it in the 2000's will take a considerable amount of 
#'      time 
#'      depending on your resources.
#' 
#' The listings of datasets can be found at 
#'      \url{http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/}
#'
#' @return a data table
#' 
#' @import data.table
#' 
#' @export
#' 
#' @examples
#' DT <- get_listings()
#' head(DT, n = 5L)
#' 
get_listings <- function() {
    file_list <- as.data.frame(XML::readHTMLTable(ncdcEnv$url))
    file_list <- data.table::as.data.table(file_list[,2:4])
    
    # Clean up the list a bit
    data.table::setnames(file_list, c("Name", "Modified", "Size"))
    data.table::setkey(file_list, Name)
    file_list <- file_list[grep("^StormEvents.", Name)]
    
    # Change class of cols
    file_list$Name <- as.character(file_list$Name)
    file_list$Modified <- lubridate::ymd_hms(strptime(file_list$Modified,
                                                      "%d-%b-%Y %H:%M"))
    file_list$Size <- as.character(file_list$Size)
    
    # Make Type and Year from Name
    pattern <- "^StormEvents_([:alpha:]+)-.+_d([0-9]{4})_c.+"
    matches <- stringr::str_match(file_list$Name, pattern)
    file_list <- file_list[, `:=`(Type = matches[,2],
                                  Year = as.numeric(matches[,3]))]
    
    
    # Extract file size int and char from Size
    pattern <- "([0-9\\.]+)([:alpha:]?)"
    matches <- stringr::str_match(file_list$Size, pattern)
    file_list <- file_list[, `:=`(SizeInt = as.numeric(matches[,2]),
                                  SizeChar = matches[,3])]
    file_list <- file_list[SizeChar == "", SizeB := SizeInt]
    file_list <- file_list[SizeChar == "K", SizeB := SizeInt * 10^3]
    file_list <- file_list[SizeChar == "M", SizeB := SizeInt * 10^6]
    
    # Remove Size, SizeInt, and SizeChar
    file_list <- file_list[, c("Size", "SizeInt", "SizeChar") := NULL]
    # Rename SizeB to  Size
    data.table::setnames(file_list, "SizeB", "Size")
    # Reorder
    data.table::setcolorder(file_list, c("Name", "Modified", "Size",
                                         "Type", "Year"))
    
    file_list
}

#' Download NCDC Storm Events datasets
#' 
#' Loads all requested datasets. Strongly recommended to use 
#'      get_listings() first to see what data is available and the file 
#'      size of the datasets before downloading datasets
#'
#' @param year numeric, vector
#' @param type character, vector
#'
#' @import data.table
#' 
#' @export
#' 
#' @return Returns a data.table for each year and type requested. 
#' 
#' @examples
#' \dontrun{
#' get_data(year = c(1990:1995), type = c("details", "fatalities"))
#' }
#' 
get_data <- function(year = NULL, type = types_available()) {
    year <- check_year(year)
    type <- check_type(type)

    summary <- get_listings()
    
    requested <- summary[Type %in% type & Year %in% year]

    if("details" %in% type) {
        dataset <- get_datasets(requested[Type == "details", Name], 
                                details_names(), 
                                details_col_types())
        if(nrow(dataset) > 0) {
        } else {
            warning("No details returned.")
        }
    }
    if("fatalities" %in% type){
        ds_fatalities <- get_datasets(requested[Type == "fatalities", Name], 
                                      fatalities_names(), 
                                      fatalities_col_types())
        if(nrow(ds_fatalities) > 0) {
            if(exists("dataset")) {
                dataset <- ds_fatalities[dataset]
            } else {
                dataset <- ds_fatalities
            }
        } else {
            warning("No fatalities returned (Yay!).")
        }
    }
    if("locations" %in% type) {
        ds_locations <- get_datasets(requested[Type == "locations", Name], 
                                     locations_names(), 
                                     locations_col_types())
        if(nrow(ds_locations) > 0) {
            if(exists("ds_details")) {
                dataset <- ds_locations[dataset]
            } else if(exists("ds_fatalities")) {
                dataset <- ds_locations[dataset]
            } else {
                dataset <- ds_locations
            }
        } else {
            warning("No locations returned.")
        }
    }
    
    dataset
    
}

#' @title get_datasets
#' @description get datasets
#' @param dt_names list of Name from get_listings
#' @param cn list of column names for Type
#' @param ct vector of column types for Type
#' @return a data table of all years requested by Type
get_datasets <- function(dt_names, cn, ct) {
    dt_names <- paste(ds_url(), dt_names, sep = "/")
    dt_list <- lapply(dt_names, readr::read_csv, col_names = cn, col_types = ct, 
                      skip = 1L)
    dt <- rbindlist(dt_list)
    dt
}

#' Check if Year is numeric input
#' @param year numeric vector
#' @return year if valid, otherwise stops
#' 
check_year <- function(year = NULL) {
    if(!is.numeric(year)) stop("Please provide year(s).")
    
    year
}

#' Check if Type is valid character vector
#' @param type character, vector
#' @return type
check_type <- function(type = NULL) {
    if(is.null(type) | !is.character(type)) 
        stop("Please provide a type.")
    type <- tolower(type)
    if(!all(type %in% types_available()))
        stop(paste("Invalid type.",
                   "Please select any(details, fatalities, locations).",
                   sep = " "))
    
    type
}

