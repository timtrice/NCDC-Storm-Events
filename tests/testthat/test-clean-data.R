context("Cleaning Date and Time")

test_that("Check get_data()", {
    # Nothing passed
    expect_error(add_datetime(), "No data table.")
})

test_that("Check tz_to_dt()", {
    expect_error(tz_to_dt(), "No data table.")
})

test_that("Check add_fips()", {
    expect_error(add_fips(), "No data table.")
})

test_that("Check add_tz()", {
    expect_error(add_tz(), "No data table.")
})
