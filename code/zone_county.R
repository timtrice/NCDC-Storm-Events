#' @title zone_county
#' @author Tim Trice <tim.trice@gmail.com>
#' @description Downlaod NWS Zone/County database
#' @details `fips` helps validate location data; we can use the "ZoneCounty"
#'   dataset from the National Weather Service to get timezone information.
#' @source https://www.weather.gov/gis/ZoneCounty
zone_county <-
  read_delim(
    "https://www.weather.gov/source/gis/Shapefiles/County/bp02oc18.dbx",
    delim = "|",
    col_names = c(
      "STATE", "ZONE", "CWA", "NAME", "STATE_ZONE", "COUNTY", "FIPS",
      "TIME_ZONE", "FE_AREA", "LAT", "LON"
    ),
    col_types = cols()
  ) %>%
  write_csv(here::here("./data/zone_county.csv"))
