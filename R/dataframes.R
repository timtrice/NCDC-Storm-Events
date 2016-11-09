#' @title dff_categories
#' @description Categories and brief descriptions for hurricanes/typhoons.
#' @format A 3x5 dataframe
#' \describe{
#'   \item{category}{Category}
#'   \item{max_wind}{Maximum wind in miles per hour}
#'   \item{damage}{Brief description of typical damage}
#' }
#' @source \url{http://www.nhc.noaa.gov/aboutsshws.php}
#' @return dataframe
dff_categories <- function() {
  df <- data.frame("category" = 1:5, 
                   "max_wind" = c(95, 110, 129, 156, NA), 
                   "damage" = c(
                     "Very dangerous winds will produce some damage", 
                     "Extremely dangerous winds will cause extensive damage", 
                     "Devastating damage will occur", 
                     "Catastrophic damage will occur", 
                     "Catastrophic damage will occur"
                   ), 
                   stringsAsFactors = FALSE)
  return(df)
}

#' @title dff_event_types
#' @description Valid Event Types
#' @format A 2x55 dataframe
#' @source \url{http://www.nws.noaa.gov/directives/sym/pd01016005curr.pdf}{NWS Instruction 10-1605}.
#' @return dataframe
dff_event_types <- function() {
  l <- c("Astronomical Low Tide", "Avalanche", "Blizzard", "Coastal Flood",
         "Cold/Wind Chill", "Debris Flow", "Dense Fog", "Dense Smoke",
         "Drought", "Dust Devil", "Dust Storm", "Excessive Heat",
         "Extreme Cold/Wind Chill", "Flash Flood", "Flood", "Frost/Freeze",
         "Funnel Cloud", "Freezing Fog", "Hail", "Heat", "Heavy Rain", 
         "Heavy Snow", "High Surf", "High Wind", "Hurricane (Typhoon)", 
         "Ice Storm", "Lake-Effect Snow", "Lakeshore Flood", 
         "Lightning", "Marine Dense Fog", "Marine Hail", 
         "Marine Heavy Freezing Spray", "Marine High Wind", 
         "Marine Hurricane/Typhoon", "Marine Lightning", 
         "Marine Strong Wind", "Marine Thunderstorm Wind", 
         "Marine Tropical Depression", "Marine Tropical Storm", 
         "Rip Current", "Seiche", "Sleet", "Sneaker Wave", 
         "Storm Surge/Tide", "Strong Wind", "Thunderstorm Wind", 
         "Tornado", "Tropical Depression", "Tropical Storm", "Tsunami", 
         "Volcanic Ash", "Waterspout", "Wildfire", "Winter Storm", 
         "Winter Weather")
  df <- data.frame("event_type_id" = 1:length(l), 
                   "EVENT_TYPE" = sort(l), 
                   stringsAsFactors = FALSE)
  return(df)
}

#' @title dff_fatality_locations
#' @description Valid fatality locations
#' @source \url{ftp://ftp.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/Storm-Data-Export-Format.docx}
#' @return dataframe
dff_fatality_locations <- function() {
  df <- data.frame(
    "fatality_location_id" = c("BF", "BO", "BU", "CA", "CH", 
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

#' @title .dff_forecast_zones
#' NEEDS WORK
#' @description County-Public Forecast Zones Correlation Dataset
#' @details This file is an ASCII "dump" in pipe ("|") delimited form, of a 
#'   "master" shapefile maintained by AGMG for the maintenance of County, Public 
#'   Forecast Zones, CWA boundaries, and Time zones. Each record represents a 
#'   single polygon within the master file. Multiple polygons may exist for the 
#'   same zone/county that contain the same attributes, but the lat and lon 
#'   fields will be different as they are the centroid of the polygon. No 
#'   attempt has been made to remove these seemingly duplicate entries from this 
#'   text file. In addition, the coastal and offshore marine zone shapefiles are 
#'   also "dumped" to this file.
#'   
#'   \href{http://www.nws.noaa.gov/geodata/catalog/wsom/html/cntyzone.htm}{Source}
#'   
#'   \href{http://www.nws.noaa.gov/geodata/catalog/county/html/county.htm}{alternate}
#'   
#'   \href{https://www.census.gov/geo/reference/codes/cou.html}{alternate 2}
.dff_forecast_zones <- function() {
  url <- "http://www.nws.noaa.gov/geodata/catalog/wsom/data/bp01nv16.dbx"
  return(df)
}

#' @title dff_flood_cause
#' @description Valid Flood Causes
#' @format A 7x2 dataframe
#' @return dataframe
dff_flood_causes <- function() {
  df <- data.frame("flood_cause_id" = 1:7, 
                   "FLOOD_CAUSE" = c(
                     "Dam/Levee Break", 
                     "Heavy Rain", 
                     "Heavy Rain/Burn Area", 
                     "Heavy Rain/Snow Melt", 
                     "Heavy Rain/Tropical System", 
                     "Ice Jam", 
                     "Planned Dam Release"
                   ), 
                   stringsAsFactors = FALSE)
  return(df)
}

#' @title dff_magnitude
#' @description Valid Magnitude Type values
#' @format A 6x3 dataframe
#' @return dataframe
dff_magnitude <- function() {
  df <- data.frame("magnitude_id" = 1:6,
                   "MAGNITUDE_TYPE" = c("E", "EG", "ES", "M", "MG", "MS"), 
                   "MAGNITUDE_TYPE_DESC" = c(
                     "Estimated", 
                     "Estimated Gust", 
                     "Estimated Sustained", 
                     "Measured", 
                     "Measured Gust", 
                     "Measured Sustained"), 
                   stringsAsFactors = FALSE)
  return(df)
}

#' @title .dff_state_fips
#' NEEDS WORK
#' @description Create dataframe to hold STATE and corresponding state_id and 
#'   FIPS codes.
#' @details In the details dataset each STATE has a unique STATE_FIPS. By and 
#'   large STATE_FIPS matches with the official codes per 
#'   \href{https://www.census.gov/geo/reference/ansi_statetables.html}{Census.gov}(1).
#'   
#'   However, there are some minor mismatches with what is in the dataset. For 
#'   example, STATE_FIPS 81 in the details dataset belongs to Lake St. Clair 
#'   near Detroit. In the Census documents, that code is for Baker Island, a 
#'   tiny island in the Pacific Ocean. Because of this mismatch I will use the 
#'   original data instead of importing more complete datasets.
#'   
#'   [1] In \href{https://en.wikipedia.org/wiki/FIPS_county_code}{Wikipedia}, 
#'   there is mention of "FIPS PUB 6-4". However, I am unable to locate this 
#'   document.
#' @return dataframe
.dff_state_fips <- function() {
  df <- data.frame(
    "STATE_FIPS" = c(1:2, 4:6, 8:13, 15:42, 44:51, 53:56, 81, 84:99), 
    "STATE" = c("Alabama", "Alaska", "Arizona", "Arkansas", "California", 
                "Colorado", "Connecticut", "Delaware", "District Of Columbia", 
                "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", 
                "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", 
                "Massachusetts", "Michigan", "Minnesota", "Mississippi", 
                "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", 
                "New Jersey", "New Mexico", "New York", "North Carolina", 
                "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", 
                "Rhode Island", "South Carolina", "South Dakota", "Tennessee", 
                "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                "West Virginia", "Wisconsin", "Wyoming", "Lake St. Clair", 
                "Hawaii Waters", "Gulf Of Mexico", "East Pacific", 
                "Atlantic South", "Atlantic North", "Gulf Of Alaska", 
                "Lake Huron", "Lake Michigan", "Lake Superior", 
                "St. Lawrence River", "Lake Ontario", "Lake Erie", 
                "Virgin Islands", "American Samoa", "Guam", "Puerto Rico"), 
    stringsAsFactors = FALSE)
  return(df)
}

#' @title dff_tor_f_scales
#' @description Valid Enhanced Fujita Scale Values
#' @details As best as I can tell these values are identical to others that 
#' exist in the database; i.e., F0, F1, F2...
#' @format A 6x3 dataframe
#' @source \url{http://www.spc.noaa.gov/efscale/}
#' @return dataframe
dff_tor_f_scales <- function() {
  df <- data.frame(
    "EF_scale" = c("EF0", "EF1", "EF2", "EF3", "EF4", "EF5"), 
    "max_wind" = c(72, 112, 157, 206, 260, 318), 
    "damage" = c("Light Damage", 
                 "Moderate Damage", 
                 "Significant Damage", 
                 "Severe Damage", 
                 "Devastating Damage", 
                 "Incredible Damage"), 
    stringsAsFactors = FALSE)
  return(df)()
}