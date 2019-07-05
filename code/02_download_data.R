#' @author Tim Trice <tim.trice@gmail.com>
#' @description Download NCDC Storm Events Database datasets. Save gzips to
#'   \code{./data}.
#' @source https://www.ncdc.noaa.gov/stormevents/

# ---- libraries ----
library(curl)
library(purrr)

# ---- sources ----
# Intentionally blank

# ---- settings ----
#' FTP URL
ftp <- "ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"

# Datasets to download will have one of the three names below in their
# file name. Do not care about anything else.
tables <- c("details", "fatalities", "locations")

# ---- connection ----
#' Establish connection, get list of gz datasets
con <- curl(ftp, "r")
tbl <- read.table(con, stringsAsFactors = TRUE, fill = TRUE)
close(con)

# ---- extract-files ----
# Filter `tbl` to only those datasets we care about; prepend `ftp`
files <- grep(pattern = paste(tables, collapse = "|"), x = tbl$V9, value = TRUE)
urls <- paste0(ftp, files)

# ---- download-files ----
# TODO
# Need to have a setup that only downloads modified since the last modified
# time. Problem is when git is used that modified time will be when the repo is
# cloned. Perhaps, created? Maybe check by file size?
walk2(urls, files, ~curl_download(.x, destfile = here::here("./data", .y), quiet = FALSE))
