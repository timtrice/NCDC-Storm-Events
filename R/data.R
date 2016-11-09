#' Details dataset
#'
#' Parent dataframe for the NCDC Storm Events datasets in raw format. 
#'
#' @format A data frame with 51 variables:
#' \describe{
#'   \item{BEGIN_YEARMONTH}{Beginning year and month of the event in '\%Y\%m' format}
#'   \item{BEGIN_DAY}{Beginning day of the event in '\%d' format}
#'   \item{BEGIN_TIME}{Beginning time of the event in '\%H\%M' format}
#'   \item{END_YEARMONTH}{End year and month of the event in '\%Y\%m' format}
#'   \item{END_DAY}{End day of the event in '\%d' format}
#'   \item{END_TIME}{End time of the event in '\%d' format}
#'   \item{EPISODE_ID}{A unique ID assigned by the NWS for a storm episode. Contains many EVENT_ID}
#'   \item{EVENT_ID}{A unique ID assigned by the NWS to a single event. Belongs to EPISODE_ID}
#'   \item{STATE}{Long name state names}
#'   \item{STATE_FIPS}{FIPS code for STATE.}
#'   \item{YEAR}{4-digit year}
#'   \item{MONTH_NAME}{Long name of month}
#'   \item{EVENT_TYPE}{See \href{NWS Instruction 10-1605, March 23, 2016}{http://www.nws.noaa.gov/directives/sym/pd01016005curr.pdf} Section 2.1.1, pg. 6.}
#'   \item{CZ_TYPE}{
#'     \describe{
#'       \item{C}{County/Parish}
#'       \item{Z}{Zone}
#'       \item{M}{Marine}
#'     }
#'   }
#'   \item{CZ_FIPS}{FIPS code for CZ_NAME}
#'   \item{CZ_NAME}{Name assigned to county FIPS number}
#'   \item{WFO}{NWS Forecast Office}
#'   \item{BEGIN_DATE_TIME}{Beginning time of event in '\%d-\%b-\%y \%H:\%M:\%S' format}
#'   \item{CZ_TIMEZONE}{Timezone of county zone}
#'   \item{END_DATE_TIME}{End time of event in '\%d-\%b-\%y \%H:\%M:\%S' format}
#'   \item{INJURIES_DIRECT}{Number of direct injuries related to event}
#'   \item{INJURIES_INDIRECT}{Number of indirect injuries related to event}
#'   \item{DEATHS_DIRECT}{Number of direct deaths related to event}
#'   \item{DEATHS_INDIRECT}{Number of indirect deaths related to event}
#'   \item{DAMAGE_PROPERTY}{Cost of damage to property, e.g., 10.00K}
#'   \item{DAMAGE_CROPS}{Cost of damage to crops, e.g., 10.00K}
#'   \item{SOURCE}{Source reporting the event. No restrictions}
#'   \item{MAGNITUDE}{Measured extent of wind speeds or hail size}
#'   \item{MAGNITUDE_TYPE}{See \code{\link{dff_magnitude}}}
#'   \item{FLOOD_CAUSE}{See \code{\link{dff_flood_causes}}}
#'   \item{CATEGORY}{See \code{\link{dff_categories}}}
#'   \item{TOR_F_SCALE}{See \code{\link{dff_tor_f_scale}}}
#'   \item{TOR_LENGTH}{Length of tornado segment while on the ground, in miles}
#'   \item{TOR_WIDTH}{Width of the tornado while on the ground, in feet}
#'   \item{TOR_OTHER_WFO}{Secondary NWS Forecast Office if tornado crosses zones}
#'   \item{TOR_OTHER_CZ_STATE}{State abbreviation if tornado crosses state lines}
#'   \item{TOR_OTHER_CZ_FIPS}{CZ_FIPS if tornado crosses zones}
#'   \item{TOR_OTHER_CZ_NAME}{Secondary county zone if tornado crosses zones}
#'   \item{BEGIN_RANGE}{Distance of event from BEGIN_LOCATION}
#'   \item{BEGIN_AZIMUTH}{Compass direction of event from BEGIN_LOCATION}
#'   \item{BEGIN_LOCATION}{Nearest point of reference of the beginning of the event}
#'   \item{END_RANGE}{Distance of event from END_LOCATION}
#'   \item{END_AZIMUTH}{Compass direction of event from END_LOCATION}
#'   \item{END_LOCATION}{Nearest point of reference of the end of the event}
#'   \item{BEGIN_LAT}{Beginning latitude of the event}
#'   \item{BEGIN_LON}{Beginning longitude of the event}
#'   \item{END_LAT}{End latitude of the event}
#'   \item{END_LON}{End longitude of the event}
#'   \item{EPISODE_NARRATIVE}{Text describing the episode}
#'   \item{EVENT_NARRATIVE}{Text describing the event}
#'   \item{DATA_SOURCE}{
#'     \describe{
#'       \item{CSV}{Unknown}
#'       \item{PDC}{Unknown}
#'       \item{PDS}{Unknown}
#'       \item{PUB}{Unknown}
#'     }
#'   }
#' }
#' @source \url{https://www.ncdc.noaa.gov/stormevents/details.jsp}
"s.details"

#' Fatalities Dataset
#' 
#' A dataset identifying fatalities associated with events in `details`.
#' 
#' @format A data frame with 11 variables:
#' \describe{
#'   \item{FAT_YEARMONTH}{Year and month of the fatality in '\%Y\%m' format}
#'   \item{FAT_DAY}{Day of the month in '\%e' format}
#'   \item{FAT_TIME}{Time of the incident in '\%H\%M' format}
#'   \item{FATALITY_ID}{Uniqe ID for the fatality}
#'   \item{EVENT_ID}{Event to which the fatality occurred}
#'   \item{FATALITY_TYPE}{
#'     \describe{
#'       \item{D}{Direct}
#'       \item{I}{Indirect}
#'     }
#'   }
#'   \item{FATALITY_DATE}{Date of the fatality in '\%m/\%d/\%Y \%H:\%M:\%S' format}
#'   \item{FATALITY_AGE}{Age of the victim}
#'   \item{FATALITY_SEX}{Sex of the victim}
#'   \item{FATALITY_LOCATION}{See \code{\link{dff_fatality_locations}}}
#'   \item{EVENT_YEARMONTH}{Year and month of the event in '\%Y\%m' format}
#' }
#' @source \url{https://www.ncdc.noaa.gov/stormevents/details.jsp}
"s.fatalities"

#' Locations Dataset
#' 
#' A dataset identifying locations for events. I'm unsure for now the differences 
#' between this dataset and the location data in `details`.
#' 
#' @format A dataframe with 11 variables
#' \describe{
#'   \item{YEARMONTH}{Year and month of the event in '\%Y\%m' format}
#'   \item{EPISODE_ID}{A unique ID assigned by the NWS for a storm episode. Contains many EVENT_ID}
#'   \item{EVENT_ID}{A unique ID assigned by the NWS to a single event. Belongs to EPISODE_ID}
#'   \item{LOCATION_INDEX}{Number assigned by NWS to specific locations within the same event}
#'   \item{RANGE}{Distance in miles of event to location}
#'   \item{AZIMUTH}{Compass direction of event to location}
#'   \item{LOCATION}{Name of location}
#'   \item{LATITUDE}{Latitude of location}
#'   \item{LONGITUDE}{Longitude of location}
#'   \item{LAT2}{Unknown}
#'   \item{LON2}{Unknown}
#' }
#' @source \url{https://www.ncdc.noaa.gov/stormevents/details.jsp}
"s.locations"