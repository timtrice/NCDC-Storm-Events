# Data

This directory contains raw data files as downloaded from their source. To view processed data, see the ./output directory.

## `details`

[Source](https://www.ncdc.noaa.gov/stormevents/details.jsp)

  * `BEGIN_YEARMONTH` - Beginning year and month of the event in '%Y%m' format
  * `BEGIN_DAY` - Beginning day of the event in '%d' format
  * `BEGIN_TIME` - Beginning time of the event in '%H%M' format
  * `END_YEARMONTH` - End year and month of the event in '%Y%m' format
  * `END_DAY` - End day of the event in '%d' format
  * `END_TIME` - End time of the event in '%d' format
  * `EPISODE_ID` - A unique ID assigned by the NWS for a storm episode. Contains many `EVENT_ID`
  * `EVENT_ID` - A unique ID assigned by the NWS to a single event. Belongs to `EPISODE_ID`
  * `STATE` - Long name state names
  * `STATE_FIPS` - FIPS code for `STATE`. See [American National Standards Institute (ANSI) Codes for States, the District of Columbia, Puerto Rico, and the Insular Areas of the United States](https://www.census.gov/geo/reference/ansi_statetables.html):
    + 1 - Alabama
    + 2 - Alaska
    + 4 - Arizona
    + 5 - Arkansas
    + 6 - California
    + 8 - Colorado
    + 9 - Connecticut
    + 10 - Delaware
    + 11 - District Of Columbia
    + 12 - Florida
    + 13 - Georgia
    + 15 - Hawaii
    + 16 - Idaho
    + 17 - Illinois
    + 18 - Indiana
    + 19 - Iowa
    + 20 - Kansas
    + 21 - Kentucky
    + 22 - Louisiana
    + 23 - Maine
    + 24 - Maryland
    + 25 - Massachusetts
    + 26 - Michigan
    + 27 - Minnesota
    + 28 - Mississippi
    + 29 - Missouri
    + 30 - Montana
    + 31 - Nebraska
    + 32 - Nevada
    + 33 - New Hampshire
    + 34 - New Jersey
    + 35 - New Mexico
    + 36 - New York
    + 37 - North Carolina
    + 38 - North Dakota
    + 39 - Ohio
    + 40 - Oklahoma
    + 41 - Oregon
    + 42 - Pennsylvania
    + 44 - Rhode Island
    + 45 - South Carolina
    + 46 - South Dakota
    + 47 - Tennessee
    + 48 - Texas
    + 49 - Utah
    + 50 - Vermont
    + 51 - Virginia
    + 53 - Washington
    + 54 - West Virginia
    + 55 - Wisconsin
    + 56 - Wyoming
    + 81 - Lake St. Clair
    + 84 - Hawaii Waters
    + 85 - Gulf Of Mexico
    + 86 - East Pacific
    + 87 - Atlantic South
    + 88 - Atlantic North
    + 89 - Gulf Of Alaska
    + 90 - Lake Huron
    + 91 - Lake Michigan
    + 92 - Lake Superior
    + 93 - St. Lawrence River
    + 94 - Lake Ontario
    + 95 - Lake Erie
    + 96 - Virgin Islands
    + 97 - American Samoa
    + 98 - Guam
    + 99 - Puerto Rico
  * `YEAR` - 4-digit year
  * `MONTH_NAME` - Long name of month
  * `EVENT_TYPE` - See [NWS Instruction 10-1605, March 23, 2016 Section 2.1.1, pg. 6](http://www.nws.noaa.gov/directives/sym/pd01016005curr.pdf):
    + Astronomical Low Tide
    + Avalanche
    + Blizzard
    + Coastal Flood,
    + Cold/Wind Chill
    + Debris Flow
    + Dense Fog
    + Dense Smoke,
    + Drought
    + Dust Devil
    + Dust Storm
    + Excessive Heat,
    + Extreme Cold/Wind Chill
    + Flash Flood
    + Flood
    + Frost/Freeze,
    + Funnel Cloud
    + Freezing Fog
    + Hail
    + Heat
    + Heavy Rain
    + Heavy Snow
    + High Surf
    + High Wind
    + Hurricane (Typhoon)
    + Ice Storm
    + Lake-Effect Snow
    + Lakeshore Flood
    + Lightning
    + Marine Dense Fog
    + Marine Hail
    + Marine Heavy Freezing Spray
    + Marine High Wind
    + Marine Hurricane/Typhoon
    + Marine Lightning
    + Marine Strong Wind
    + Marine Thunderstorm Wind
    + Marine Tropical Depression
    + Marine Tropical Storm
    + Rip Current
    + Seiche
    + Sleet
    + Sneaker Wave
    + Storm Surge/Tide
    + Strong Wind
    + Thunderstorm Wind
    + Tornado
    + Tropical Depression
    + Tropical Storm
    + Tsunami
    + Volcanic Ash
    + Waterspout
    + Wildfire
    + Winter Storm
    + Winter Weather
  * `CZ_TYPE`:
    + `C` - County/Parish
    + `Z` - Zone
    + `M` - Marine
  * `CZ_FIPS` - FIPS code for `CZ_NAME`
  * `CZ_NAME` - Name assigned to county FIPS number
  * `WFO` - NWS Forecast Office
  * `BEGIN_DATE_TIME` - Beginning time of event in '%d-%b-%y %H:%M:%S' format
  * `CZ_TIMEZONE` - Timezone of county zone
  * `END_DATE_TIME` - End time of event in '%d-%b-%y %H:%M:%S' format
  * `INJURIES_DIRECT` - Number of direct injuries related to event
  * `INJURIES_INDIRECT` - Number of indirect injuries related to event
  * `DEATHS_DIRECT` - Number of direct deaths related to event
  * `DEATHS_INDIRECT` - Number of indirect deaths related to event
  * `DAMAGE_PROPERTY` - Cost of damage to property, e.g., 10.00K
  * `DAMAGE_CROPS` - Cost of damage to crops, e.g., 10.00K
  * `SOURCE` - Source reporting the event. No restrictions
  * `MAGNITUDE` - Measured extent of wind speeds or hail size
  * `MAGNITUDE_TYPE`:
    + **E** - Estimated
    + **EG** - Estimated Gust
    + **ES** - Estimated Sustained
    + **M** - Measured
    + **MG** - Measured Gust
    + **MS** - Measured Sustained
  * `FLOOD_CAUSE`:
    + Dam/Levee Break
    + Heavy Rain
    + Heavy Rain/Burn Area
    + Heavy Rain/Snow Melt
    + Heavy Rain/Tropical System
    + Ice Jam
    + Planned Dam Release
  * `CATEGORY`:
    + **1** - Very dangerous winds will produce some damage
    + **2** - Extremely dangerous winds will cause extensive damage
    + **3** - Devastating damage will occur
    + **4** - Catastrophic damage will occur
    + **5** - Catastrophic damage will occur
  * `TOR_F_SCALE`:
    + **EF0** - Light Damage
    + **EF1** - Moderate Damage
    + **EF2** - Significant Damage
    + **EF3** - Severe Damage
    + **EF4** - Devastating Damage
    + **EF5** - Incredible Damage
  * `TOR_LENGTH` - Length of tornado segment while on the ground, in miles
  * `TOR_WIDTH` - Width of the tornado while on the ground, in feet
  * `TOR_OTHER_WFO` - Secondary NWS Forecast Office if tornado crosses zones
  * `TOR_OTHER_CZ_STATE` - State abbreviation if tornado crosses state lines
  * `TOR_OTHER_CZ_FIPS` - `CZ_FIPS` if tornado crosses zones
  * `TOR_OTHER_CZ_NAME` - Secondary county zone if tornado crosses zones
  * `BEGIN_RANGE` - Distance of event from `BEGIN_LOCATION`
  * `BEGIN_AZIMUTH` - Compass direction of event from `BEGIN_LOCATION`
  * `BEGIN_LOCATION` - Nearest point of reference of the beginning of the event
  * `END_RANGE` - Distance of event from `END_LOCATION`
  * `END_AZIMUTH` - Compass direction of event from `END_LOCATION`
  * `END_LOCATION` - Nearest point of reference of the end of the event
  * `BEGIN_LAT` - Beginning latitude of the event
  * `BEGIN_LON` - Beginning longitude of the event
  * `END_LAT` - End latitude of the event
  * `END_LON` - End longitude of the event
  * `EPISODE_NARRATIVE` - Text describing the episode
  * `EVENT_NARRATIVE` - Text describing the event
  * `DATA_SOURCE`:
    + **CSV** - Unknown
    + **PDC** - Unknown
    + **PDS** - Unknown
    + **PUB** - Unknown

## `fatalities`

  * `FAT_YEARMONTH` - Year and month of the fatality in '%Y%m' format
  * `FAT_DAY` - Day of the month in '%e' format
  * `FAT_TIME` - Time of the incident in '%H%M' format
  * `FATALITY_ID` - Uniqe ID for the fatality
  * `EVENT_ID` - Event to which the fatality occurred
  * `FATALITY_TYPE`:
    + D - Direct
    + I - Indirect
  * `FATALITY_DATE` - Date of the fatality in '%m/%d/%Y %H:%M:%S' format
  * `FATALITY_AGE` - Age of the victim
  * `FATALITY_SEX` - Sex of the victim
  * `FATALITY_LOCATION`:
    + Ball Field
    + Boating
    + Business
    + Camping
    + Church
    + Heavy Equip/Construction
    + Golfing
    + In Water
    + Long Span Roof
    + Mobile/Trailer Home
    + Other/Unknown
    + Outside/Open Areas
    + Permanent Home
    + Permanent Structure
    + School
    + Telephone
    + Under Tree
    + Vehicle and/or Towed Trailer
  * `EVENT_YEARMONTH` - Year and month of the event in '%Y%m' format

## `locations`

  * `YEARMONTH` - Year and month of the event in '%Y%m' format
  * `EPISODE_ID` - A unique ID assigned by the NWS for a storm episode. Contains many `EVENT_ID`
  * `EVENT_ID` - A unique ID assigned by the NWS to a single event. Belongs to `EPISODE_ID`
  * `LOCATION_INDEX` - Number assigned by NWS to specific locations within the same event
  * `RANGE` - Distance in miles of event to location
  * `AZIMUTH` - Compass direction of event to location
  * `LOCATION` - Name of location
  * `LATITUDE` - Latitude of location
  * `LONGITUDE` - Longitude of location
  * `LAT2` - Unknown
  * `LON2` - Unknown

## Additional Data Sources

### `fips`

[Source](https://www.census.gov/geo/reference/codes/cou.html)

The `fips` dataset can be downloaded with ./code/fips.R. This data is saved in the data directory as it is considered raw. 

* STATE - State postal code

* STATEFP - State FIPS code

* COUNTYFP - County FIPS code

* COUNTYNAME - County name and legal/statistical area description

* CLASSFP - FIPS class code

### `zone_county`

[Source](https://www.weather.gov/gis/ZoneCounty)

A zone-county correlation file from the National Weather Service may also be downloaded using ./code/zone_county.R. This dataset identifies all weather zones, FIPS codes for each zone, location data and time zone data.

* STATE - Two character state abbreviation

* ZONE - Three character zone number

* CWA - Three character CWA ID (of the zone, starting with 01 May 2018 file)

* NAME - Zone name

* STATE_ZONE - Five-character state + zone name

* COUNTY - County name

* FIPS - Five-character state-county FIPS code

* TIME_ZONE	- Time zone of polygon (See comments on county page)

* FE_AREA	- Feature Area (location in STATE - See comments on county page)

* LAT	- Latitude of centroid of the zone

* LON	- Longitude of centroid of the zone
