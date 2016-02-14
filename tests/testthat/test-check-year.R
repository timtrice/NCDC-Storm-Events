context("Check Year")

test_that("check year input", {
    # Check appropriate usage
    expect_equal(check_year(1950), 1950) 
    expect_equal(check_year(1950:1955), 1950:1955) 
    expect_equivalent(check_year(c(1950:1955)), c(1950:1955))
    expect_equal(check_year(c(1950, 1955)), c(1950, 1955))
    
    # Check incorrect usage
    expect_error(check_year("1950"), "Please provide year\\(s\\).")
})
