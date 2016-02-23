ds_url <- function() {
    "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles"
}

types_available <- function() {
    c("details", "fatalities", "locations")
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
        dataset <- get_datasets(requested[Type == "details", Name])
        if(nrow(dataset) > 0) {
            setkey(dataset, EVENT_ID)
        } else {
            warning("No details returned.")
        }
    }
    if("fatalities" %in% type){
        ds_fatalities <- get_datasets(requested[Type == "fatalities", Name])
        if(nrow(ds_fatalities) > 0) {
            setkey(ds_fatalities, EVENT_ID)
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
        ds_locations <- get_datasets(requested[Type == "locations", Name])
        if(nrow(ds_locations) > 0) {
            setkey(ds_locations, EVENT_ID)
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

#' Get datasets
#'
#' @param dt_names list of Name from get_listings
#'
#' @return a data table of all years requested by Type
#' @export
get_datasets <- function(dt_names) {
    dt_names <- paste(ds_url(), dt_names, sep = "/")
    dt_list <- lapply(dt_names, readr::read_csv)
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

