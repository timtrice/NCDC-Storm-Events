context("is.dst")

test_that("Boolean values are correct", {
  #2016
  expect_equal(is.dst('2016-04-10 01:59:00'), FALSE)
  expect_equal(is.dst('2016-04-10 02:00:00'), TRUE)
  expect_equal(is.dst('2016-11-06 01:59:00'), TRUE)
  expect_equal(is.dst('2016-11-06 02:00:00'), FALSE)
  
  #2000
  expect_equal(is.dst('2000-04-09 01:59:00'), FALSE)
  expect_equal(is.dst('2000-04-09 02:01:00'), TRUE)
  expect_equal(is.dst('2000-11-05 01:59:00'), TRUE)
  expect_equal(is.dst('2000-11-05 02:01:00'), FALSE)
  
  # Random dates outside DST
  expect_equal(is.dst('2015-12-01 01:59:00'), FALSE)
  expect_equal(is.dst('2014-01-15 01:59:00'), FALSE)
  expect_equal(is.dst('2013-02-01 01:59:00'), FALSE)
  expect_equal(is.dst('2012-03-30 01:59:00'), FALSE)
  
  # Random dates inside DST
  expect_equal(is.dst('2015-05-01 01:59:00'), TRUE)
  expect_equal(is.dst('2014-06-15 01:59:00'), TRUE)
  expect_equal(is.dst('2013-07-01 01:59:00'), TRUE)
  expect_equal(is.dst('2012-08-30 01:59:00'), TRUE)
  
})
