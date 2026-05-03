library(testthat)
library(statswift)

# -------------------------------------------------------
# swift_summary() tests
# -------------------------------------------------------
test_that("swift_summary returns SwiftSummary object", {
  result <- swift_summary(c(1, 2, 3, 4, 5))
  expect_s3_class(result, "SwiftSummary")
})

test_that("swift_summary computes correct mean", {
  result <- swift_summary(c(10, 20, 30))
  expect_equal(result$mean, 20)
})

test_that("swift_summary counts NAs correctly", {
  result <- swift_summary(c(1, NA, 3, NA, 5))
  expect_equal(result$na_count, 2)
  expect_equal(result$n, 3)
})

test_that("swift_summary errors on non-numeric input", {
  expect_error(swift_summary(c("a", "b", "c")))
})

test_that("swift_summary errors on too few values", {
  expect_error(swift_summary(c(1)))
})

# -------------------------------------------------------
# swift_outliers() tests
# -------------------------------------------------------
test_that("swift_outliers returns SwiftOutliers object", {
  result <- swift_outliers(c(1, 2, 3, 100))
  expect_s3_class(result, "SwiftOutliers")
})

test_that("swift_outliers detects obvious outlier via IQR", {
  result <- swift_outliers(c(1, 2, 3, 4, 5, 100))
  expect_true(100 %in% result$outlier_values)
})

test_that("swift_outliers detects obvious outlier via zscore", {
  result <- swift_outliers(c(1, 2, 3, 4, 5, 100), method = "zscore", threshold = 2)
  expect_true(100 %in% result$outlier_values)
})

test_that("swift_outliers returns 0 outliers for normal data", {
  set.seed(1)
  result <- swift_outliers(rnorm(50, mean = 0, sd = 1), method = "zscore", threshold = 4)
  expect_equal(result$n_outliers, 0)
})

# -------------------------------------------------------
# swift_compare() tests
# -------------------------------------------------------
test_that("swift_compare returns SwiftCompare object", {
  result <- swift_compare(c(1, 2, 3, 4), c("A", "A", "B", "B"))
  expect_s3_class(result, "SwiftCompare")
})

test_that("swift_compare produces correct number of groups", {
  result <- swift_compare(c(1,2,3,4,5,6), c("X","X","Y","Y","Z","Z"))
  expect_equal(result$n_groups, 3)
})

test_that("swift_compare errors on mismatched lengths", {
  expect_error(swift_compare(c(1, 2, 3), c("A", "B")))
})

# -------------------------------------------------------
# swift_report() tests (S4)
# -------------------------------------------------------
test_that("swift_report returns SwiftReport S4 object", {
  report <- swift_report(mtcars, data_name = "Test")
  expect_s4_class(report, "SwiftReport")
})

test_that("swift_report has correct row/col counts", {
  report <- swift_report(mtcars)
  expect_equal(report@n_rows, 32L)
  expect_equal(report@n_cols, 11L)
})

test_that("swift_report errors on non-data-frame input", {
  expect_error(swift_report(c(1, 2, 3)))
})
