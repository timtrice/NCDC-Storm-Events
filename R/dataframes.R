#' Initialize dataframes
#' 
#' These dataframes are generated as reference tables from the original three 
#' datasets. For example, in details$STATE are set strings of values that sould 
#' exist. In this file is a function to build a dataframe that holds those keys 
#' and values.

#' @title fatality_locations
#' @description Dataframe to hold valid fatalities$location per p.8 of 
#'   \href{ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/Storm-Data-Export-Format.docx}{Storm Data Export Format document}
#' @return dataframe
fatality_locations <- function() {
  df <- data.frame("fatality_location_id" = c("BF", "BO", "BU", "CA", "CH", 
                                              "EQ", "GF", "IW", "LS", "MH", 
                                              "OT", "OU", "PH", "PS", "SC", 
                                              "TE", "UT", "VE"), 
                   "FATALITY_LOCATION" = c("Ball Field", "Boating", "Business", 
                                  "Camping", "Church", 
                                  "Heavy Equip/Construction", "Golfing", 
                                  "In Water", "Long Span Roof", 
                                  "Mobile/Trailer Home", "Other/Unknown", 
                                  "Outside/Open Areas", "Permanent Home", 
                                  "Permanent Structure", "School", "Telephone", 
                                  "Under Tree", "Vehicle and/or Towed Trailer"), 
                   stringsAsFactors = FALSE)
  return(df)  
}

#' @title state_fips
#' @description Create dataframe to hold STATE and corresponding state_id and 
#'   FIPS codes.
#' @return dataframe
state_fips <- function() {
  df <- data.frame(
    "state_id" = c(1:68), 
    "STATE" = c("ALABAMA", "ALASKA", "AMERICAN SAMOA", "ARIZONA", "ARKANSAS", 
                "ATLANTIC NORTH", "ATLANTIC SOUTH", "CALIFORNIA", "COLORADO", 
                "CONNECTICUT", "DELAWARE", "DISTRICT OF COLUMBIA", "E PACIFIC", 
                "FLORIDA", "GEORGIA", "GUAM", "GULF OF ALASKA", 
                "GULF OF MEXICO", "HAWAII", "HAWAII WATERS", "IDAHO", 
                "ILLINOIS", "INDIANA", "IOWA", "KANSAS", "KENTUCKY", 
                "LAKE ERIE", "LAKE HURON", "LAKE MICHIGAN", "LAKE ONTARIO", 
                "LAKE ST CLAIR", "LAKE SUPERIOR", "LOUISIANA", "MAINE", 
                "MARYLAND", "MASSACHUSETTS", "MICHIGAN", "MINNESOTA", 
                "MISSISSIPPI", "MISSOURI", "MONTANA", "NEBRASKA", "NEVADA", 
                "NEW HAMPSHIRE", "NEW JERSEY", "NEW MEXICO", "NEW YORK", 
                "NORTH CAROLINA", "NORTH DAKOTA", "OHIO", "OKLAHOMA", "OREGON",
                "PENNSYLVANIA", "PUERTO RICO", "RHODE ISLAND", "SOUTH CAROLINA", 
                "SOUTH DAKOTA", "ST LAWRENCE R", "TENNESSEE", "TEXAS", "UTAH", 
                "VERMONT", "VIRGINIA", "VIRGIN ISLANDS", "WASHINGTON", 
                "WEST VIRGINIA", "WISCONSIN", "WYOMING"), 
    "FIPS" = c(1:68))
}
