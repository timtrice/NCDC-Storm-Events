context("Get Data")

test_that("Check get_data()", {
    expect_equal(is.data.table(get_data(1950)), TRUE)
    # Do we get warning for empty datasets?
    expect_warning(get_data(1950), "No locations returned.")
    # Do names match the expected output?
    expect_identical(names(get_data(1950, type = "details")), 
                     c("BEGIN_YEARMONTH", "BEGIN_DAY", "BEGIN_TIME", 
                       "END_YEARMONTH", "END_DAY", "END_TIME", "EPISODE_ID", 
                       "EVENT_ID", "STATE", "STATE_FIPS", "YEAR", 
                       "MONTH_NAME", "EVENT_TYPE", "CZ_TYPE", "CZ_FIPS", 
                       "CZ_NAME", "WFO", "BEGIN_DATE_TIME", "CZ_TIMEZONE", 
                       "END_DATE_TIME", "INJURIES_DIRECT", 
                       "INJURIES_INDIRECT", "DEATHS_DIRECT", 
                       "DEATHS_INDIRECT", "DAMAGE_PROPERTY", "DAMAGE_CROPS", 
                       "SOURCE", "MAGNITUDE", "MAGNITUDE_TYPE", 
                       "FLOOD_CAUSE", "CATEGORY", "TOR_F_SCALE", 
                       "TOR_LENGTH", "TOR_WIDTH", "TOR_OTHER_WFO", 
                       "TOR_OTHER_CZ_STATE", "TOR_OTHER_CZ_FIPS", 
                       "TOR_OTHER_CZ_NAME", "BEGIN_RANGE", "BEGIN_AZIMUTH", 
                       "BEGIN_LOCATION", "END_RANGE", "END_AZIMUTH", 
                       "END_LOCATION", "BEGIN_LAT", "BEGIN_LON", "END_LAT", 
                       "END_LON", "EPISODE_NARRATIVE", "EVENT_NARRATIVE", 
                       "DATA_SOURCE"))
    expect_identical(names(get_data(1950, type = "fatalities")), 
                     c("FAT_YEARMONTH", "FAT_DAY", "FAT_TIME", "FATALITY_ID", 
                       "EVENT_ID", "FATALITY_TYPE", "FATALITY_DATE", 
                       "FATALITY_AGE", "FATALITY_SEX", "FATALITY_LOCATION", 
                       "EVENT_YEARMONTH"))
    expect_identical(names(get_data(1996, type = "locations")), 
                     c("YEARMONTH", "EPISODE_ID", "EVENT_ID", 
                       "LOCATION_INDEX", "RANGE", "AZIMUTH", "LOCATION", 
                       "LATITUDE", "LONGITUDE", "LAT2", "LON2"))
})
