# https://www.ncdc.noaa.gov/stormevents/details.jsp

# Libraries
library(R.utils)
library(data.table)

# URL of CSV files
url <- "http://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"

# Read in HTML of URL
html <- readLines(url(paste(url, 
                            "/", 
                            sep = "")))

# Extract lines containing file patterns
gz <- gsub("(.+\")(StormEvents_[a-z -_ 0-9\\.]+\\.csv\\.gz)(\".+)", 
           "\\2", # Get second grouping
           html, 
           perl = TRUE)

# Index of patterns matched
gz_index <- grep("StormEvents_[a-z -_ 0-9\\.]+\\.csv\\.gz", gz)

# New list of zip files
file_list <- list(gz[gz_index])

# Create data directory, if does not exist
if(!dir.exists("data")) dir.create("data")

# for each file in file_list, download and extract
for(i in 1:length(file_list[[1]])) {
    fileUrl <- paste(url, file_list[[1]][[i]], sep = "/")
    # Download
    download.file(fileUrl, destfile = paste("data", file_list[[1]][[i]], 
                                            sep = "/"))
    # Unzip
    gunzip(paste("data", file_list[[1]][[i]], sep = "/"), remove = FALSE)
}

