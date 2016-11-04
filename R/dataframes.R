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