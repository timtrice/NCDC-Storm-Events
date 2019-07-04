#' @title fips
#' @author Tim Trice <tim.trice@gmail.com>
#' @description Downlaod FIPS datasets
#' @details In the `details` dataset, there are two variables, `STATE_FIPS` and
#' `CZ_FIPS`, that can be used to verify locations and help retrieve timezone
#' information. A second source is needed; enter the US Census Bureau website.
#'
#' There are several datasets available for the contiguous United States and
#' additional states and territories. These datasets combined **may not**
#' include everything needed. But, best guess, it should cover at least 95%
#'
#' FIPS Class Codes
#' - H1: identifies an active county or statistically equivalent entity that
#'   does not qualify under subclass C7 or H6.
#' - H4: identifies a legally defined inactive or nonfunctioning county or
#'     statistically equivalent entity that does not qualify under subclass H6.
#' - H5:  identifies census areas in Alaska, a statistical county equivalent
#'     entity.
#' - H6: identifies a county or statistically equivalent entity that is areally
#'     coextensive or governmentally consolidated with an incorporated place,
#'     part of an incorporated place, or a consolidated city.
#' - C7: identifies an incorporated place that is an independent city; that is,
#'     it also serves as a county equivalent because it is not part of any
#'     county, and a minor civil division (MCD) equivalent because it is not
#'     part of any MCD.
#' @source https://www.census.gov/geo/reference/codes/cou.html

domain <- "https://www2.census.gov/geo/docs/reference/codes/files/"

urls <-
  list(
    "US" = "national_county.txt",
    "American Samoa" = "st60_as_cou.txt",
    "Guam" = "st66_gu_cou.txt",
    "Northern Mariana Islands" = "st69_mp_cou.txt",
    "Puerto Rico" = "st72_pr_cou.txt",
    "US Minor Outlying Islands" = "st74_um_cou.txt",
    "US Virgin Islands" = "st78_vi_cou.txt"
  )

columns <- c("STATE", "STATEFP", "COUNTYFP", "COUNTYNAME", "CLASSFP")

column_classes <- cols(
  "STATE" = col_character(),
  "STATEFP" = col_integer(),
  "COUNTYFP" = col_integer(),
  "COUNTYNAME" = col_character(),
  "CLASSFP" = col_character()
)

#' Occasionally this may start generating a "HTTP error 304"; this seems to be
#' if too many requests are within a short time period, but I haven't verified
#' this.
fips <-
  map_df(
    .x = urls,
    .f = ~read_csv(
      glue("{domain}{.x}"),
      col_names = columns,
      col_types = column_classes
    )
  ) %>%
  distinct() %>%
  write_csv(path = here::here("./data/fips.csv"))
