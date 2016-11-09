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
#' @importFrom magrittr %>%
#' @examples
#' datasets <- get_listings()
#' @return a dataframe
#' @export
get_listings <- function() {
  file_list <- as.data.frame(XML::readHTMLTable(.ds_url()))
  file_list <- file_list %>% dplyr::select(2:4)
  colnames(file_list) <- c("Name", "Modified", "Size")
  file_list <- file_list[grep("^StormEvents.", file_list$Name),]
  file_list$Name <- as.character(file_list$Name)
  file_list$Modified <- lubridate::ymd_hms(strptime(file_list$Modified,
                                                    "%d-%b-%Y %H:%M"))
  file_list$Size <- as.character(file_list$Size)
  # Make Dataset and Year from Name
  pattern <- "^StormEvents_([:alpha:]+)-.+_d([0-9]{4})_c.+"
  matches <- stringr::str_match(file_list$Name, pattern)
  file_list <- file_list %>% 
    dplyr::mutate(Dataset = matches[,2], 
           Year = as.numeric(matches[,3]))

  # Extract file size int and char from Size
  pattern <- "([0-9\\.]+)([:alpha:]?)"
  matches <- stringr::str_match(file_list$Size, pattern)
  file_list <- file_list %>% 
    dplyr::mutate(SizeInt = as.numeric(matches[,2]),
           SizeChar = matches[,3])
  k <- list("M" = 1e+06, "K" = 1e+03, "H" = 1e+02)
  file_list$SizeChar[file_list$SizeChar == ""] <- "H"
  file_list <- file_list %>% 
    dplyr::mutate(SizeB = SizeInt * k[SizeChar][[1]])

  # Remove Size, SizeInt, and SizeChar
  file_list$Size <- NULL
  file_list$SizeInt <- NULL
  file_list$SizeChar <- NULL
  # Rename SizeB to  Size
  file_list <- file_list %>% dplyr::rename(Size = SizeB)
  # Reorder
  file_list <- file_list %>% 
    dplyr::select(Name, Modified, Size, Dataset, Year)
  return(file_list)
}

#' @title get_data
#' @description Download NCDC Storm Events datasets
#' @details This is a wrapper function for \code{\link{get_details}}, 
#'   \code{\link{get_fatalities}} and \code{\link{get_locations}}. This function 
#'   can load all requested datasets. Use \code{\link{get_listings}} first to 
#'   see what data is available and the file size of the datasets before 
#'   downloading datasets.
#'   
#'   Please see \href{https://www.ncdc.noaa.gov/stormevents/ftp.jsp}{Storm Events Database} 
#'   for latest code book and file naming convention.
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
  dt <- dplyr::bind_rows(dt_list)
  return(dt)
}

#' @title is.dst
#' @description Is t in Daylight Savings Time?
#' @details Calculate if time value is in a period of DST
#' @param t Time in '\%Y-\%m-\%d \%H:\%M:\%S' format, character class.
#' @export
is.dst <- function(t) {

  f <- function(n, do) {
    ifelse(do == "begin", return(8 + (7 - n)), return(8 - n))
  }
  
  dst_date <- function(z, do) {
    # What day of the week is April 1?
    n = lubridate::wday(lubridate::ymd_hm(z, tz = "UTC"))
    # Calculate days to 2nd Sunday
    s = f(n, do)
    # Calculate date
    d = as.POSIXct(lubridate::ymd_hm(z)) + lubridate::days(s)
    return(d)
  }
  
  y = lubridate::year(t)
  dst_begin <- dst_date(paste0(y, "-04-01 02:00"), do = "begin")
  dst_end <- dst_date(paste0(y, "-11-01 02:00"), do = "end")
  t <- as.POSIXct(t, tz = "UTC")
  x <- ifelse(dst_begin <= t & dst_end > t, TRUE, FALSE)
  return(x)
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

#' @title .sample_dataframes
#' @description Build sample dataframes
#' @details Takes common EVENT_ID in all three datasets and filters on those 
#' values.
.sample_dataframes <- function() {
  get_data(2015, clean = FALSE)
  
  x <- as.vector(details$EVENT_ID)
  y <- as.vector(fatalities$EVENT_ID)
  z <- as.vector(locations$EVENT_ID)
  
  i <- intersect(intersect(x, y), z)
  
  s.details <- details %>% 
    filter(EVENT_ID %in% i)
  
  s.fatalities <- fatalities %>% 
    filter(EVENT_ID %in% i)
  
  s.locations <- locations %>% 
    filter(EVENT_ID %in% i)
  
  rm(details, fatalities, locations, i, x, y, z)
  
  devtools::use_data(s.details, overwrite = TRUE)
  devtools::use_data(s.fatalities, overwrite = TRUE)
  devtools::use_data(s.locations, overwrite = TRUE)
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