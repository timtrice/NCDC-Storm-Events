context("Get Listings")

# For now all we're expecting is a data table of 5 variables. Currently there 
#       are 198 rows but more files can be added at any time so no checks

test_that("Check get_listings()", {
    expect_equal(is.data.table(get_listings()), TRUE)
    
    expect_identical(names(get_listings()), c("Name", "Modified", "Size", 
                                              "Type", "Year"))
})
