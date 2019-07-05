#' @author Tim Trice <tim.trice@gmail.com>
#' @description Import NCDC Storm Events Database
#' @source https://www.ncdc.noaa.gov/stormevents/

# ---- libraries ----
library(DBI)
library(dplyr)
library(glue)
library(lubridate)
library(purrr)
library(rlang)
library(RSQLite)
library(stringr)
library(tidyr)
library(vroom)

# ---- details-read ----
details <- vroom(
  file = here::here(
    "./data/",
    list.files(path = here::here("./data/"), pattern = "details")
  ),
  delim = ",",
  col_types = cols(.default = col_character())
)

# ---- details-dates ----
#' In the `details` dataset, there are numerous columns with some type of
#' date or time information; it is redundant and untidy. These columns are
#' `BEGIN_YEARMONTH`, `BEGIN_DAY`, `BEGIN_TIME`, `END_YEARMONTH`, `END_DAY`,
#' `END_TIME`, `YEAR`, `MONTH_NAME`, `BEGIN_DATE_TIME`, `CZ_TIMEZONE`, and
#' `END_DATE_TIME`. I have already validated each observation's date/time
#' fields match one another; all information is contained within
#' `BEGIN_DATE_TIME` and `END_DATE_TIME`. However, these two fields cannot
#' simply be converted to dates as the year is in %C (century; see ?strftime).
#' So, a value of "28-APR-50 14:45:00" will be converted incorrectly to
#' "2050-04-28 14:45:00 UTC"; the year should be 1950.
#'
#' I use `lubridate::parse_date_time2` to correct this, setting the
#' `cutoff_2000` parameter to 49L; this means any year value greater than 49
#' will use the previous century. So, the same string above,
#' "28-APR-50 14:45:00" will properly be converted to "1950-04-28 14:45:00 UTC".
#'
#' Additionally, the `parse_date_time2` function will automatically assign
#' "UTC" as the timezone as it is not specified below. While the timezone
#' information is provided in the dataset - `CZ_TIMEZONE` - it is horribly
#' incorrect. Just plotting "CST" or "CDT" observations will demonstrate
#' locations all across the continental United States. Therefore, a secondary
#' source is needed to validate the timezones. That dataset will be included
#' below.
#'
#' With that, by default, all datetime observations will be converted to
#' character saving the date and time values but losing the timezone values.

details <-
  details %>%
  select(
    -c(
      BEGIN_YEARMONTH, BEGIN_DAY, BEGIN_TIME, END_YEARMONTH, END_DAY, END_TIME,
      YEAR, MONTH_NAME, CZ_TIMEZONE
    )
  ) %>%
  mutate_at(
    .vars = vars("BEGIN_DATE_TIME", "END_DATE_TIME"),
    .funs = parse_date_time2,
    orders = "%d!-%m!-%y!* %H!:%M!:%S!",
    cutoff_2000 = 49L
  )  %>%
  #' Make character string; timezones are invalid and junk.
  mutate_at(
    .vars = vars("BEGIN_DATE_TIME", "END_DATE_TIME"),
    .funs = as.character,
  )

# ---- details-damage ----
#' The damage variables are alphanumeric strings with characters reprsenting
#' the dollar amount in hundreds, thousands, and millions. Split both
#' `DAMAGE_PROPERTY` and `DAMAGE_CROPS`, convert the characters to a multiplier,
#' then update original variables with integer values.
details <-
  details %>%
  extract(
    col = DAMAGE_PROPERTY,
    into = c("DAMAGE_PROPERTY_VALUE", "DAMAGE_PROPERTY_KEY"),
    regex = "([[:digit:]\\.]+)([[:alpha:]])*",
    remove = FALSE,
    convert = TRUE
  ) %>%
  extract(
    col = DAMAGE_CROPS,
    into = c("DAMAGE_CROPS_VALUE", "DAMAGE_CROPS_KEY"),
    regex = "([[:digit:]\\.]+)([[:alpha:]])*",
    remove = FALSE,
    convert = TRUE
  ) %>%
  mutate_at(
    .vars = vars(c(DAMAGE_PROPERTY_KEY, DAMAGE_CROPS_KEY)),
    .funs = ~case_when(
      .x %in% c("h", "H") ~ 1e2,
      .x %in% c("k", "K") ~ 1e3,
      .x %in% c("m", "M") ~ 1e6,
      .x %in% c("b", "B") ~ 1e9,
      TRUE                ~ 1
    )
  ) %>%
  mutate(
    DAMAGE_PROPERTY = DAMAGE_PROPERTY_VALUE * DAMAGE_PROPERTY_KEY,
    DAMAGE_CROPS = DAMAGE_CROPS_VALUE * DAMAGE_CROPS_KEY
  ) %>%
  select(-c(
    DAMAGE_PROPERTY_VALUE, DAMAGE_PROPERTY_KEY, DAMAGE_CROPS_VALUE,
    DAMAGE_CROPS_KEY
  ))

# ---- details-reclass ----
# Reclass data types
details <-
  details %>%
  mutate_at(
    .vars = c(
      "EPISODE_ID", "EVENT_ID", "STATE_FIPS", "CZ_FIPS", "INJURIES_DIRECT",
      "INJURIES_INDIRECT", "DEATHS_DIRECT", "DEATHS_INDIRECT", "MAGNITUDE",
      "CATEGORY", "TOR_LENGTH", "TOR_WIDTH", "TOR_OTHER_CZ_FIPS", "BEGIN_RANGE",
      "END_RANGE", "BEGIN_LAT", "BEGIN_LON", "END_LAT", "END_LON"
    ),
    .funs = as.numeric
  )

# ---- details-episode-narratives ----
#' This and the next section aren't necessarily "tidying" as they fit the tidy
#' principals. But, these variables are repetitive across observations and many
#' do not even exist. I can reduce the filesize of `details` from a very heavy
#' 1034M to a much more comfortable 297M; the next two CSV files weighing 176M.
#' I like savings.
episode_narratives <-
  details %>%
  select(EPISODE_ID, EPISODE_NARRATIVE) %>%
  distinct() %>%
  na.omit() %>%
  arrange(EPISODE_ID)

details$EPISODE_NARRATIVE <- NULL

# ---- details-event-narratives ----
event_narratives <-
  details %>%
  select(EPISODE_ID, EVENT_ID, EVENT_NARRATIVE) %>%
  distinct() %>%
  na.omit() %>%
  arrange(EPISODE_ID, EVENT_ID)

details$EVENT_NARRATIVE <- NULL

# --- details-event-types ----
# Clean `EVENT_TYPE`; multiple entries are stored comma-delimited
details$EVENT_TYPE[details$EVENT_TYPE == "HAIL FLOODING"] <- "Hail, Flood"
# "Icy Roads" is not a valid entry; will use "Ice Storm"
details$EVENT_TYPE[details$EVENT_TYPE == "HAIL/ICY ROADS"] <- "Hail, Ice Storm"
details$EVENT_TYPE[details$EVENT_TYPE == "Heavy Wind"] <- "High Wind"
details$EVENT_TYPE[details$EVENT_TYPE == "High Snow"] <- "Heavy Snow"
details$EVENT_TYPE[details$EVENT_TYPE == "Hurricane"] <- "Hurricane (Typhoon)"
# "Landslide" isn't a valid entry but there is nothing close (though "Avalanche"
# exists). Will leave as is.
#details$EVENT_TYPE[details$EVENT_TYPE == "Landslide"] <- "Landslide"
# "Northern Lights' is an invalid entry
details$EVENT_TYPE[details$EVENT_TYPE == "Northern Lights"] <- NA_character_
details$EVENT_TYPE[details$EVENT_TYPE == "OTHER"] <- NA_character_
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WIND/ TREE"] <- "Thunderstorm Wind"
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WIND/ TREES"] <- "Thunderstorm Wind"
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WINDS FUNNEL CLOU"] <- "Thunderstorm Wind, Funnel Cloud"
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WINDS HEAVY RAIN"] <- "Thunderstorm Wind, Heavy Rain"
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WINDS LIGHTNING"] <- "Thunderstorm Wind, Lightning"
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WINDS/ FLOOD"] <- "Thunderstorm Wind, Flood"
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WINDS/FLASH FLOOD"] <- "Thunderstorm Wind, Flash Flood"
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WINDS/FLOODING"] <- "Thunderstorm Wind, Flood"
details$EVENT_TYPE[details$EVENT_TYPE == "THUNDERSTORM WINDS/HEAVY RAIN"] <- "Thunderstorm Wind, Heavy Rain"
details$EVENT_TYPE[details$EVENT_TYPE == "TORNADO/WATERSPOUT"] <- "Tornado, Waterspout"
details$EVENT_TYPE[details$EVENT_TYPE == "TORNADOES, TSTM WIND, HAIL"] <- "Tornado, Thunderstorm Wind, Hail"
details$EVENT_TYPE[details$EVENT_TYPE == "Volcanic Ashfall"] <- "Volcanic Ash"

# ---- fatalities-read ----
fatalities <- vroom(
  file = here::here(
    "./data/",
    list.files(path = here::here("./data/"), pattern = "fatalities")
  ),
  delim = ",",
  col_types = cols(.default = col_character())
)

# ---- fatalities-dates ----
#' `fatalities` also has several date/time variables: `FAT_YEARMONTH`,
#' `FAT_DAY`, `FAT_TIME`, `FATALITY_DATE`. However, the values for some
#' observations do not match. This may be related to `FATALITY_TYPE`. Or, it
#' could be typos in the observation. For this reason, `FATALITY_DATE` is
#' converted to "%Y-%m-%d %H:%M:%S" format only as a new variable,
#' `FATALITY_DATE_TIME_1`, and all other variables are used to generate
#' `FATALITY_DATE_TIME_2`.
#'
#' A warning will be generated, "11 failed to parse". This is because there are
#' 10 variables where `FAT_DAY` is 0. See `FATALITY_ID`s 18845, 18846, 18847,
#' 18848, 18849, 18850, 18851, 18852, 18853, and 18854.
#'
#' The 11th warning is for `FATALITY_ID` 18392 where `FAT_YEARMONTH` is
#' "201202" (February) and `FAT_DAY` is 31; obviously there are never 31 days
#' in February. `FATALITY_DATE` is populated (and thus, `FATALITY_DATE_TIME_1`)

fatalities <-
  fatalities %>%
  #' `FATALITY_DATE` may not contain seconds, therefore set truncated to 1L
  mutate(
    FATALITY_DATE_TIME_1 = parse_date_time(
      x = FATALITY_DATE,
      orders = "mdY HMS",
      truncated = 1L
    )
  ) %>%
  #' Must pad `FAT_DAY` to two digits.
  mutate_at(
    .vars = vars("FAT_DAY"),
    .funs = str_pad,
    width = 2L,
    side = "left",
    pad = "0"
  ) %>%
  #' Must pad `FAT_TIME` to four digits. I have verified these values are
  #' minutes (in old `details` vars, some were hours.)
  mutate_at(
    .vars = vars("FAT_TIME"),
    .funs = str_pad,
    width = 4L,
    side = "left",
    pad = "0"
  ) %>%
  #' Concat remaining vars and convert to datetime
  mutate(
    FATALITY_DATE_TIME_2 = parse_date_time(
      x = paste0(FAT_YEARMONTH, FAT_DAY, FAT_TIME),
      orders = "YmdHM"
    )
  ) %>%
  #' Drop extra vars (`EVENT_YEARMONTH` is in `details`)
  select(-c(FAT_YEARMONTH, FAT_DAY, FAT_TIME, FATALITY_DATE, EVENT_YEARMONTH)) %>%
  #' Convert to character to drop timezone
  mutate_at(
    .vars = vars("FATALITY_DATE_TIME_1", "FATALITY_DATE_TIME_2"),
    .funs = as.character
  )

# ---- fatalities-reclass ----
fatalities <-
  mutate_at(
    .tbl = fatalities,
    .vars = c("FATALITY_ID", "EVENT_ID", "FATALITY_AGE"),
    .funs = as.numeric
  )

# ---- locations-read ----
locations <- vroom(
  file = here::here(
    "./data/",
    list.files(path = here::here("./data/"), pattern = "locations")
  ),
  delim = ",",
  col_types = cols(.default = col_character())
)

# ---- locations-dates ----
#' Drop `YEARMONTH`
locations <- select(locations, -YEARMONTH)

# ---- sqlite ----
con <- dbConnect(SQLite(), here::here("./output/ncdc.db"))
dbWriteTable(con, "details", details)
dbWriteTable(con, "episode_narratives", episode_narratives)
dbWriteTable(con, "event_narratives", event_narratives)
dbWriteTable(con, "fatalities", fatalities)
dbWriteTable(con, "locations", locations)
dbDisconnect(con)
