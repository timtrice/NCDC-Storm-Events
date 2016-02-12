################################################################################
library(data.table)
library(lubridate)
library(R.utils)
library(readr)
library(stringr)
library(XML)

ncdc_se_url <- "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"

dcc <- c("integer", "integer", "integer", "integer", "integer",
         "integer", "integer", "integer", "factor", "factor",
         "integer", "factor", "factor", "factor", "integer",
         "factor", "factor", "factor", "factor", "factor",
         "integer", "integer", "integer", "integer", "factor",
         "factor", "character", "numeric", "character", "logical",
         "logical", "factor", "character", "character", "logical",
         "logical", "logical", "logical", "integer", "factor",
         "factor", "integer", "factor", "factor", "numeric",
         "numeric", "numeric", "numeric", "factor", "character",
         "factor")

fcc <- c("integer", "integer", "integer", "integer", "integer", "factor",
         "factor", "integer", "factor", "factor", "integer")

lcc <- c("integer", "integer", "integer", "integer", "integer", "factor", "factor",
         "numeric", "numeric", "integer", "integer")

#' Get data from NCDC Storm Events
#'
#' \code{get_data} returns a dataset of types based on the year or years passed.
#'
#' @param year number or vector
#' @param type string or vector c("details", "fatalities", "locations")
#' @param warn boolean. Default is TRUE meaning if the aggregated Size of files
#'      requested exceeds max_size, the script stops executing.
#' @param max_size double in bytes. Default is 5MB or ~ 5e+06.
#'
#' @return a dataset
#'
#' \emph{max_size} corresponds to the maximum file size of gzip files. This
#' means the imported datasets will be larger. Please allow room for this.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' get_data(year = 1950, type = "details")
#' get_data(year = c(1950:2000), type = c("details", "fatalities"))
#' }
#'
get_data <- function(year = NULL, type = NULL, warn = TRUE, max_size = 5e6,
                     details_col_classes = dcc, fatalities_col_classes = fcc,
                     locations_col_classes = lcc) {

    if(!warn) warning("No check on aggregate max file size.")

    if(!is.numeric(year)) stop("Please provide a four-digit year.")
    if(!is.character(type)) stop("Please provide a type")

    type <- tolower(type)
    types_avail <- c("details", "fatalities", "locations")
    if(!all(type %in% types_avail))
        stop(paste("Invalid type.",
                   "Please select details, fatalities or locations.",
                   sep = " "))

    summary <- get_listings()

    # Check for max_size and warn if exceeded
    requested <- summary[Type %in% type & Year %in% year]
    f_size <- sum(requested$Size)
    if(f_size > max_size & warn)
        stop(sprintf(paste("Max file size exceeded.",
                           "Max size (%.0e) < Aggregate (%.0e)",
                           "To proceed, set warn = FALSE.",
                           "Otherwise, select fewer years or types.", sep = " "),
                     max_size, f_size))

    # What's the total file size of data requested?
    warning(sprintf(paste("Total data size requested: %0.2fkb", sep = ""),
                    f_size/1000))

    ds_names <- requested[, Name]

    f_list <- list.files("./data")

    # If file does not exist in /data, download
    urls_details <- paste(ncdc_se_url, ds_names, sep = "")
    for(i in 1:length(urls_details)) {
        csv_file <- sub(".gz", "", ds_names[i])
        if(!csv_file %in% f_list){
            download.file(urls_details[i],
                          destfile = paste("./data", ds_names[i], sep = "/"))
            gunzip(paste("./data", ds_names[i], sep = "/"))
        }
    }

    details_names <- requested[Type == "details", Name]
    details_names <- sub(".gz", "", details_names)
    details_names <- paste("./data", details_names, sep = "/")
    details_list <- lapply(details_names, fread, colClasses = dcc,
                           strip.white= TRUE)
    details_df <- rbindlist(details_list)
    setkey(details_df, EVENT_ID)

    fatalities_names <- requested[Type == "fatalities", Name]
    fatalities_names <- sub(".gz", "", fatalities_names)
    fatalities_names <- paste("./data", fatalities_names, sep = "/")
    fatalities_list <- lapply(fatalities_names, fread, colClasses = fcc,
                           strip.white= TRUE)
    fatalities_df <- rbindlist(fatalities_list)
    setkey(fatalities_df, EVENT_ID)

    locations_names <- requested[Type == "locations", Name]
    locations_names <- sub(".gz", "", locations_names)
    locations_names <- paste("./data", locations_names, sep = "/")
    locations_list <- lapply(locations_names, fread, colClasses = lcc,
                           strip.white= TRUE)
    locations_df <- rbindlist(locations_list)
    setkey(locations_df, EVENT_ID)

    df <- details_df[fatalities_df[locations_df]]
    return(df)

}

#' Get listing of files from NCDC Storm Events
#'
#' This function access \code{ncdc_se_url} (see
#'      \url{http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/})
#'      and returns a nicely formatted data.table of the StormEvents listed as
#'      well as modified date, size with type and year variables added.
#'
#' To retrieve a dataset, Name is appended to \code{ncdc_se_url}
#'
#' @return
#' @export
#'
#' @examples
get_listings <- function() {
    # Get the list of datasets
    # Can't seem to bring in as data table so do data frame for now.
    # Have to set as.data.frame() to convert to data.table
    file_list <- as.data.frame(readHTMLTable(ncdc_se_url))
    file_list <- as.data.table(file_list[,2:4])

    # Clean up the list a bit
    setnames(file_list, c("Name", "Modified", "Size"))
    setkey(file_list, Name)
    file_list <- file_list[grep("^StormEvents.", Name)]

    # Change class of cols
    file_list$Name <- as.character(file_list$Name)
    file_list$Modified <- ymd_hms(strptime(file_list$Modified, "%d-%b-%Y %H:%M"))
    file_list$Size <- as.character(file_list$Size)

    # Make Type and Year from Name
    pattern <- "^StormEvents_([:alpha:]+)-.+_d([0-9]{4})_c.+"
    matches <- str_match(file_list$Name, pattern)
    file_list <- file_list[, `:=`(Type = matches[,2],
                                  Year = as.numeric(matches[,3]))]


    # Extract file size int and char from Size
    pattern <- "([0-9\\.]+)([:alpha:]?)"
    matches <- str_match(file_list$Size, pattern)
    file_list <- file_list[, `:=`(SizeInt = as.numeric(matches[,2]),
                                  SizeChar = matches[,3])]
    file_list <- file_list[SizeChar == "", SizeB := SizeInt]
    file_list <- file_list[SizeChar == "K", SizeB := SizeInt * 10^3]
    file_list <- file_list[SizeChar == "M", SizeB := SizeInt * 10^6]

    # Remove Size, SizeInt, and SizeChar
    file_list <- file_list[, c("Size", "SizeInt", "SizeChar") := NULL]
    # Rename SizeB to  Size
    setnames(file_list, "SizeB", "Size")
    # Reorder
    setcolorder(file_list, c("Name", "Modified", "Size", "Type", "Year"))

    return(file_list)
}

