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
  return(type)
}

#' Check if Year is numeric input
#' @param year numeric vector
#' @return year if valid, otherwise stops
check_year <- function(year = NULL) {
  if(!is.numeric(year)) stop("Please provide year(s).")
  if(year < 1951) stop("There are no datasets prior to 1951.")
  return(year)
}

#' @title ds_url
#' @description URL to download datasets
ds_url <- function() {
  return("http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles")
}

#' @title get_listings
#' @description Get listing of files from NCDC Storm Events
#' @details 
#' Get listing of all datasets off the NCDC Storm Events website. 
#' The function returns a data table showing all StormEvents files listed 
#'      on the NCDC server. 
#' The data table contains the following variables:  
#' * \emph{Name} Filename of the dataset
#' * \emph{Modified} Modified date of the dataset
#' * \emph{Size} Size of the gzip file. 
#' * \emph{Type} One of c("details", "fatalities", "locations")
#' * \emph{Year} Year of dataset
#' This function was created because many datasets listed are empty 
#'   (typically those listed as 147b file size). And a large majority of 
#'   them are very small but do have content. However, in the more 
#'   recent years some of the datasets grow in size exponentially.
#' So this data table helps give insight into gathering data without 
#'   overloading on resources. For example, you may want ten years of 
#'   all data. And, in the early years you can do this very quickly. 
#'   However, doing it in the 2000's will take a considerable amount of 
#'   time depending on your resources.
#' The listings of datasets can be found at 
#'   \url{http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/}
#' @examples
#' DT <- get_listings()
#' head(DT, n = 5L)
#' @import data.table
#' @return a data table
#' @export
get_listings <- function() {
  file_list <- as.data.frame(XML::readHTMLTable(ds_url()))
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

#' @title get_data
#' @description Download NCDC Storm Events datasets
#' @details Loads all requested datasets. Strongly recommended to use 
#'   get_listings() first to see what data is available and the file 
#'   size of the datasets before downloading datasets
#' @param year A numeric vector
#' @param type A character vector
#' @param clean Clean the dataset. TRUE by default.
#' @return Returns a data.table for each year and type requested. 
#' @examples
#'   \dontrun{
#'     get_data(year = c(2015), type = c("details"))
#'   }
#' @export
get_data <- function(year = NULL, type = types_available(), clean = TRUE) {
  year <- check_year(year)
  type <- check_type(type)

  if("details" %in% type)
    dt <- get_details(year, clean)
  if("fatalities" %in% type)
    dt <- get_fatalities(year, clean)
  if("locations" %in% type)
    dt <- get_locations(year, clean)
  return(dt)
}

#' @title get_datasets
#' @description get datasets
#' @param dt_names list of Name from get_listings
#' @param cn list of column names for Type
#' @param ct vector of column types for Type
#' @return a data table of all years requested by Type
get_datasets <- function(dt_names, cn, ct) {
  dt_names <- paste(ds_url(), dt_names, sep = "/")
  dt_list <- lapply(dt_names, read_dataset, cn = cn, ct = ct)
  dt <- rbindlist(dt_list)
  return(dt)
}

read_dataset <- function(u, cn, ct) {
  dt <- readr::read_csv(u, col_names = cn, col_types = ct, skip = 1L)
  p <- readr::problems(dt)
  if(nrow(p) > 0)
    write_problems(p, u)
  return(dt)
}

#' @title types_available
#' @description types of datasets available
types_available <- function() {
  c("details", "fatalities", "locations")
}

write_problems <- function(dt, u) {
  dt$url <- u
  if(!exists('problems')) {
    assign('problems', dt, envir = .GlobalEnv)
  } else {
    problems <<- bind_rows(problems, dt)
  }
  return(TRUE)
}