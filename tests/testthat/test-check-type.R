context("Check Type")

test_that("check type input", {
    # Check proper usage
    expect_equal(check_type("details"), "details") 
    expect_equal(check_type(c("details", "fatalities")), 
                 c("details", "fatalities")) 
    expect_equal(check_type(c("details", "fatalities", "locations")), 
                 c("details", "fatalities", "locations")) 
    
    # Check capitalization
    expect_equal(check_type("Details"), "details") 
    expect_equal(check_type(c("deTaiLs", "fatalities", "loCations")), 
                 c("details", "fatalities", "locations")) 
    expect_equal(check_type(c("DETAILS", "faTalitiEs")), 
                 c("details", "fatalities")) 
    
    # Check mispellings
    expect_error(check_type("detail"), 
                 "Please select any\\(details, fatalities, locations\\).")
    # One mispelling, one correct
    expect_error(check_type(c("details", "fatalitys")), 
                 "Please select any\\(details, fatalities, locations\\).")
    
    # Nothing passed
    expect_error(check_type(), "Please provide a type.")
})
