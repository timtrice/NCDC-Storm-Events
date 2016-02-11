library(XML)
library(readr)
library(data.table)

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

get_data <- function(year = NULL, type = NULL, warnings = TRUE) {
    if(is.null(year) | class(year) != "integer")
        stop("Provide an integer year. ")

    if(is.null(type)) stop("No type provided.")

    if(!type %in% c("details", "fatalities", "locations"))
        stop("Invalid type.")

    if(length(year) == 1) year <- c(year)

    url <- "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"
    file_list <- as.data.frame(readHTMLTable(url))
    file_list <- file_list[,2:4]
    events_idx <- grep("StormEvents_", file_list[,1])
    file_list <- file_list[events_idx,]
    names(file_list) <- c("Name", "Modified", "Size")
    pattern <- "^StormEvents_([a-z]+)-.+_d([0-9]{4})_c.+"
    file_list$type <- gsub(pattern, "\\1", file_list$Name, perl = TRUE)
    file_list$Year <- gsub(pattern, "\\2", file_list$Name, perl = TRUE)
    size_pattern <- "([0-9\\.]+)([K|M])"
    file_list$SizeInB <- gsub(size_pattern, "\\1", file_list$Size, perl = TRUE)
    file_list$SizeKey <- gsub(size_pattern, "\\2", file_list$Size, perl = TRUE)
}
