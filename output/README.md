# Output

## `details`

### Changes

The following changes were made from the raw data files:

1. Variables `BEGIN_YEARMONTH`, `BEGIN_DAY`, `BEGIN_TIME`, `END_YEARMONTH`, `END_DAY`, `END_TIME`, `YEAR`, `MONTH_NAME`, and `CZ_TIMEZONE`have been removed. All date/time variables (without information on timezone) are in the variables `BEGIN_DATE_TIME` and `END_DATE_TIME`. Timezone information has been dropped due to significant inaccuracies. Timezone information can be found using the `fips` and `zone_county` datasets in the ./data directory.

1. `DAMAGE_PROPERTY` and `DAMAGE_CROPS` have been modified. Raw data contains strings such as "1k" or "10M". The string values ("h", "k", "m", capitalized or not) were used as multipliers and both variables updated as integer values. For example, "1k" is now integer 1000.

1. The variable `EPISODE_NARRATIVES` has been relocated to it's own dataset. Many of these values are duplicates so, to save file space, all unique entires were relocated to the `episode_narratives` dataset in this directory. Use `EPISODE_ID` as the primary key.

1. The variable `EVENT_NARRATIVES` has also been removed and exists as unique entries in the `event_narratives` dataset in this directory. `EVENT_ID` is the primary key.

### Dictionary

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
  * `BEGIN_DATE_TIME` - Beginning time of event in 'yyyy-dd-mm hh:mm:ss' format
  * `END_DATE_TIME` - End time of event in 'yyyy-dd-mm hh:mm:ss' format
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
  * `DATA_SOURCE`:
    + **CSV** - Unknown
    + **PDC** - Unknown
    + **PDS** - Unknown
    + **PUB** - Unknown

## `episode_narratives`

All unique `EPISODE_NARRATIVE` values from the raw `details` dataset.

### Dictionary

  * `EPISODE_ID` - A unique ID assigned by the NWS for a storm episode. Contains many `EVENT_ID`
  * `EPISODE_NARRATIVE` - Text describing the episode

## `event_narratives`

All unique `EVENT_NARRATIVE` values from the raw `details` dataset.

### Dictionary

  * `EVENT_NARRATIVE` - Text describing the event
  * `EVENT_ID` - A unique ID assigned by the NWS to a single event. Belongs to `EPISODE_ID`

## `fatalities`

Like `details`, `fatalities` contained several date/time variables that were unnecessary. Unfortunately, these observations did not quite match. In many instances, the variable `FATALITY_DATE` was consistent with the raw variables `FAT_YEARMONTH`, `FAT_DAY`, `FAT_TIME`, and `EVENT_YEARMONTH`. However, in many instances, these values did not match. 

Because of this, two new variables were created: `FATALITY_DATE_TIME_1` and `FATALITY_DATE_TIME_2`. 

### Dictionary

  * `EVENT_ID` - Event to which the fatality occurred
  * `FATALITY_ID` - Uniqe ID for the fatality
  * `FATALITY_TYPE`:
    + D - Direct
    + I - Indirect
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
  * `FATALITY_DATE_TIME_1` - A modified variable of the original `FATALITY_DATE` variable, in "yyyy-mm-dd hh:mm:ss" format
  * `FATALITY_DATE_TIME_2` - A modified variable of the original `FAT_YEARMONTH`, `FAT_DAY`, and `FAT_TIME` variables, in "yyyy-mm-dd hh:mm:ss" format

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
