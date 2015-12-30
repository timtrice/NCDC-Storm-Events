# Set to TRUE if merged CSV files are to be written to data directory
write_files <- TRUE
# Set to TRUE to gzip files
gzip_files <- TRUE

# Include functions
source("functions.R")

# Load libraries
library(data.table)
library(R.utils)

# Pattern for file names
details_file_pattern <- "^StormEvents_details[a-zA-Z0-9 -_\\.]+\\.csv$"
fatalities_file_pattern <- "^StormEvents_fatalities[a-zA-Z0-9 -_\\.]+\\.csv$"
locations_file_pattern <- "^StormEvents_locations[a-zA-Z0-9 -_\\.]+\\.csv$"

# Load files into lists by details, fatalities or locations
details_files <- file_list(pattern = details_file_pattern, 
                           full.names = TRUE)
fatalities_files <- file_list(pattern = fatalities_file_pattern, 
                              full.names = TRUE)
locations_files <- file_list(pattern = locations_file_pattern, 
                             full.names = TRUE)

# For each details/fatalities/locations, we get the file info of all files, 
# convert to data table and then order by size descending. I did this in order 
# to help the colClasses further below but in hindsight may not have been 
# useful (ordering by size gets us the most data to help class())
details_info <- file.info(details_files, extra_cols = TRUE)
details_info <- as.data.table(details_info, keep.rownames = TRUE)
details_info <- details_info[order(-size)]

fatalities_info <- file.info(fatalities_files, extra_cols = TRUE)
fatalities_info <- as.data.table(fatalities_info, keep.rownames = TRUE)
fatalities_info <- fatalities_info[order(-size)]

locations_info <- file.info(locations_files, extra_cols = TRUE)
locations_info <- as.data.table(locations_info, keep.rownames = TRUE)
locations_info <- locations_info[order(-size)]

# Create empty data tables to hold the merged CSV files
details <- data.table()
fatalities <- data.table()
locations <- data.table()

# Get column classes by reading first 1000 lines of biggest CSV file
details_colClasses = sapply(read.csv(details_info[1, rn], nrows = 1000), class)

# After trial and error, some changes to the colClasses have to be made. 
# Some CSV files can be imported without issue. Some just have odd data 
# that creep in. Explanations will be provided
details_colClasses[[10]] <- "factor" # State FIPS, like State, should be factor
# Below are originally classed numeric but due to coercion to character may 
# lead to data loss. Changing to character to avoid; will clean later
details_colClasses[[31]] <- "character"
details_colClasses[[33]] <- "character"
details_colClasses[[34]] <- "character"
details_colClasses[[37]] <- "character"
details_colClasses[[39]] <- "character"
details_colClasses[[42]] <- "character"
details_colClasses[[45]] <- "character"
details_colClasses[[46]] <- "character"
details_colClasses[[47]] <- "character"
details_colClasses[[48]] <- "character"

# Read in CSV files, add to data table
for (files in details_files) {
    details <- rbind(details, 
                     fread(files, 
                           colClasses = details_colClasses, 
                           strip.white = TRUE # Trim whitespace
                           ))
}

# Get column classes by reading first 1000 lines of biggest CSV file
fatalities_colClasses = sapply(read.csv(fatalities_info[1, rn], 
                                        nrows = 1000), class)
# Read in CSV files, add to data table
for (files in fatalities_files) {
    fatalities <- rbind(fatalities, fread(files, 
                                          colClasses = fatalities_colClasses))
}

# Get column classes by reading first 1000 lines of biggest CSV file
locations_colClasses = sapply(read.csv(locations_info[1, rn], 
                                        nrows = 1000), class)
# Read in CSV files, add to data table
for (files in locations_files) {
    locations <- rbind(locations, fread(files, 
                                        colClasses = locations_colClasses))
}

# Write files, if enabled at beginning of script
if(write_files) {
    write.csv(details, "data/details.csv")
    write.csv(fatalities, "data/fatalities.csv")
    write.csv(locations, "data/locations.csv")
}

# Gzip files, if enabled at beginning of script
if(gzip_files) {
    gzip("data/details.csv", remove = FALSE, overwrite = TRUE)
    gzip("data/fatalities.csv", remove = FALSE, overwrite = TRUE)
    gzip("data/locations.csv", remove = FALSE, overwrite = TRUE)
}
