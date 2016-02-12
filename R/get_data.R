################################################################################
library(data.table)
library(lubridate)
library(readr)
library(stringr)
library(XML)

get_filename <- function(year, type = NULL) {
    # Our file names are in the 2nd index
    gz_index <- grep(pattern, file_list$Name, value = TRUE)
    file_url <- paste(url, gz_index, sep = "")
    return(file_url)
}

get_details <- function(year = NULL, warnings = TRUE) {
    file_urls <- lapply(year, get_filename, type = "details")
    datasets <- lapply(file_urls, read_csv)
    df <- rbindlist(datasets)
    return(df)
}

get_data <- function(year = NULL, type = NULL, warn = TRUE, max_size = 2e7) {

    if(!warn) warning("No check on aggregate max file size.")

    if(!is.numeric(year)) stop("Please provide a four-digit year.")
    if(!is.character(type)) stop("Please provide a type")

    type <- tolower(type)
    types_avail <- c("details", "fatalities", "locations")
    if(!all(type %in% types_avail))
        stop(paste("Invalid type.",
                   "Please select details, fatalities or locations.",
                   sep = " "))

    ds_summary <- get_ds_lists()

    # Check for max_size and warn if exceeded
    tmp <- ds_summary[Type %in% type & Year %in% year]
    f_size <- sum(tmp$Size)
    if(f_size > max_size & warn)
        stop(sprintf(paste("Max file size exceeded.",
                           "Max size: (%.0e); Aggregate: (%.0e)",
                           "To proceed, set warn = FALSE.",
                           "Otherwise, select fewer years or types.", sep = " "),
                     max_size, f_size))

    warning(sprintf(paste("Total data size requested: %0.2fkb", sep = ""),
                    f_size/1000))

}

get_ds_lists <- function() {
    # Get the list of datasets
    url <- "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"
    # Can't seem to bring in as data table so do data frame for now.
    # Have to set as.data.frame() to convert to data.table
    file_list <- as.data.frame(readHTMLTable(url))
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
    pattern <- "^StormEvents_([a-z]+)-.+_d([0-9]{4})_c.+"
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
