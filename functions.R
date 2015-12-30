# Load libraries
library(devtools)
library(roxygen2)

#' file_list
#'
#' @param directory directory of files to read in
#' @param pattern pattern of file names
#' @param ... additional params for list.files()
#'
#' @seealso list.files()
#' 
#' @return list of files
#'
#' @examples
#' list_of_files <- file_list(directory = "data", pattern = "^[A-Z]+\\.csv", ...)
file_list <- function(directory = "data", pattern, ...) {
    # Check if pattern provided
    if(is.null(pattern)) stop("Must provide a pattern")
    
    # list.files
    x <- list.files(directory, pattern = pattern, ...)
}
