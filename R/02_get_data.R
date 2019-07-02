#' @author Tim Trice <tim.trice@gmail.com>
#' @description Import NCDC Storm Events Database
#' @source https://www.ncdc.noaa.gov/stormevents/

# ---- libraries ----
library(curl)
library(dplyr)
library(glue)
library(here)
library(purrr)
library(readr)

# ---- sources ----
source(here("./code/functions.R"))

# ---- settings ----
#' FTP URL
ftp <- "ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/"

#' Three datasets to download and their expected width
tables <- c("details", "fatalities", "locations")

# ---- connection ----
#' Establish connection, get list of gz datasets
con = curl(ftp, "r")
tbl = read.table(con, stringsAsFactors = TRUE, fill = TRUE)
close(con)

# ---- by_table ----
#' Split out the datasets into their own lists. Will end up with a list of
#' length 3 for each table containing all related dataset URLs
by_table <-
  map(
    .x = glue("^StormEvents_{tables}"),
    .f = grep,
    x = tbl$V9,
    value = TRUE
  ) %>%
  map(~glue("{ftp}{.x}")) %>%
  set_names(nm = tables)

# ---- load-data ----
df <-
  map(
    .x = tables,
    .f = function(x) {
      map_df(
        .x = by_table[[x]],
        .f = read_csv,
        col_types = cols(.default = col_character())
      )
    }
  ) %>%
  set_names(nm = tables)

#' Bring `EVENT_ID` and table's respective ID field to front
df$fatalities <- select(df$fatalities, EVENT_ID, FATALITY_ID, everything())
df$locations <- select(df$locations, EPISODE_ID, EVENT_ID, everything())

# ---- save-data ----
write_csv(df$details, here("./data/details.csv"))
write_csv(df$fatalities, here("./data/fatalities.csv"))
write_csv(df$locations, here("./data/locations.csv"))
