#' @title .check_datasets
#' @description Is ds valid?
#' @param ds character or vector, c("details", "fatalities", "locations")
#' @return ds if valid, otherwise stop and throw error.
.check_datasets <- function(ds = NULL) {
  if(is.null(ds) | !is.character(ds)) 
    stop("Please provide a dataset.")
  ds <- tolower(ds)
  if(!all(ds %in% .datasets_available()))
    stop(paste("Invalid dataset. ",
               "Please select one or all of c(\"details\", \"fatalities\", \"locations\").",
               sep = " "))
  return(ds)
}

#' @title .check_year
#' @description Check if year is valid numeric input
#' @param year numeric vector
#' @return year if valid, otherwise stop and throw error.
.check_year <- function(year = NULL) {
  if(!is.numeric(year)) stop("Please provide year(s).")
  if(min(year) < 1951) stop("There are no datasets prior to 1951.")
  return(year)
}

#' @title .datasets_available
#' @description datasets available: details, fatalities and/or locations
.datasets_available <- function() {
  c("details", "fatalities", "locations")
}

#' @title .ds_url
#' @description URL to download datasets
.ds_url <- function() {
  return("http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles")
}

#' @title get_listings
#' @description Get listing of files from NCDC Storm Events
#' @details Get listing of all datasets off the NCDC Storm Events website. 
#'   The function returns a dataframe showing all StormEvents files listed on 
#'   the NCDC server.
#'   
#'   The data table contains the following variables:
#'   \itemize{
#'     \item Name: Filename of the dataset
#'     \item Modified: Modified date of the dataset
#'     \item Size: Size of the gzip file in bytes
#'     \item Dataset: One of c("details", "fatalities", "locations")
#'     \item Year: Year of dataset
#'   }
#'   
#'   The listings of datasets can be found at 
#'   \url{http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/}
#' @examples
#' datasets <- get_listings()
#' @import data.table
#' @return a data table
#' @export
get_listings <- function() {
  file_list <- as.data.frame(XML::readHTMLTable(.ds_url()))
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
  
  # Make Dataset and Year from Name
  pattern <- "^StormEvents_([:alpha:]+)-.+_d([0-9]{4})_c.+"
  matches <- stringr::str_match(file_list$Name, pattern)
  file_list <- file_list[, `:=`(Dataset = matches[,2],
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
                                       "Dataset", "Year"))
  return(file_list)
}

#' @title get_data
#' @description Download NCDC Storm Events datasets
#' @details This is a wrapper function for \code{\link{get_details}}, 
#'   \code{\link{get_fatalities}} and \code{\link{get_locations}}. This function 
#'   can load all requested datasets. Use \code{\link{get_listings}} first to 
#'   see what data is available and the file size of the datasets before 
#'   downloading datasets.
#' @param year A single number or numeric vector.
#' @param ds A string or character vector.
#' @param clean Clean and reorganize the dataset. TRUE by default.
#' @return Returns a dataframe for each year and ds requested. 
#' @examples
#' \dontrun{
#'   # Return the details dataset cleaned for 2015.
#'   get_data(year = 2015, ds = "details")
#' }
#' 
#' \dontrun{
#'   # Return the details, fatalities datasets for 2015 to 2016
#'   get_data(year = 2015:2016, ds = c("details", "fatalities"))
#' }
#' 
#' \dontrun{
#'   # Get all datasets for 2015
#'   get_data(year = 2015)
#' }
#' 
#' \dontrun{
#'   # details, fatalities and locations raw
#'   get_data(year = 2015, clean = FALSE)
#' }
#' @export
get_data <- function(year = NULL, ds = .datasets_available(), clean = TRUE) {
  year <- .check_year(year)
  ds <- .check_datasets(ds)

  if("details" %in% ds)
    get_details(year, clean)
  if("fatalities" %in% ds)
    get_fatalities(year, clean)
  if("locations" %in% ds)
    get_locations(year, clean)
  return(TRUE)
}

#' @title .get_datasets
#' @description Build list of requested datasets, bind and return
#' @param gz_names list of Name from \code{get_listings}
#' @param cn list of column names for ds
#' @param ct vector of column types for ds
#' @return a data table of all years requested by ds
.get_datasets <- function(gz_names, cn, ct) {
  gz_names <- paste(.ds_url(), gz_names, sep = "/")
  dt_list <- lapply(gz_names, .read_dataset, cn = cn, ct = ct)
  dt <- rbindlist(dt_list)
  return(dt)
}

#' @title read_dataset
#' @description Download each requested dataset.
#' @param u URL of requested dataset
#' @param cn column names for the requested dataset
#' @param ct column classes for each cn
#' @return dataset
.read_dataset <- function(u, cn, ct) {
  df <- readr::read_csv(u, col_names = cn, col_types = ct, skip = 1L, 
                        progress = TRUE)
  p <- readr::problems(df)
  if(nrow(p) > 0)
    write_problems(p, u)
  return(df)
}

#' @title write_problems
#' @description Generate or append problems dataframe
#' @param df Problems dataframe as generated from readr::read_csv
#' @param u URL of dataset that generated the problems.
#' @return TRUE if successful
.write_problems <- function(df, u) {
  df$url <- u
  if(!exists('problems')) {
    assign('problems', df, envir = .GlobalEnv)
  } else {
    problems <<- bind_rows(problems, df)
  }
  return(TRUE)
}