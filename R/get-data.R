#' Get listing of files from NCDC Storm Events
#'
#' This function accesses the NCDC Storm Events dataset listings and returns a 
#'      formatted data.table showing the StormEvents file names (Name), 
#'      modified date (Modified), gzip file size (Size), Type (details, 
#'      fatalities or locations) and Year.
#' 
#' The listings of datasets can be found at 
#'      \url{http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/}
#'
#' @return a data table
#' @import data.table
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

    return(file_list)
}
