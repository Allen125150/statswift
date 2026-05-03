#' statswift: Fast and Friendly Descriptive Statistics and Data Summaries
#'
#' @description
#' The `statswift` package provides a clean, intuitive toolkit for performing
#' descriptive statistics and data summaries in R. It is designed to be
#' easy to use for students and analysts who want comprehensive statistical
#' summaries without a heavy dependency footprint.
#'
#' ## Main Functions
#'
#' | Function | Description |
#' |---|---|
#' | [swift_summary()] | Extended descriptive stats for a numeric vector (S3) |
#' | [swift_outliers()] | Detect outliers via IQR or Z-score methods (S3) |
#' | [swift_compare()] | Compare descriptive stats across groups (S3) |
#' | [swift_distplot()] | Plot histogram + density + boxplot for a vector |
#' | [swift_report()] | Full dataset report for a data frame (S4) |
#'
#' ## Class Systems
#'
#' `statswift` uses both S3 and S4 class systems:
#' - **S3**: `SwiftSummary`, `SwiftOutliers`, `SwiftCompare` — with `print` methods.
#' - **S4**: `SwiftReport` — with a `show` method.
#'
#' ## Getting Started
#'
#' ```r
#' library(statswift)
#'
#' # Summarize a vector
#' swift_summary(mtcars$mpg)
#'
#' # Detect outliers
#' swift_outliers(mtcars$mpg, method = "zscore")
#'
#' # Compare across groups
#' swift_compare(mtcars$mpg, mtcars$cyl)
#'
#' # Visual distribution
#' swift_distplot(mtcars$mpg, main = "MPG Distribution")
#'
#' # Full data frame report
#' swift_report(mtcars, data_name = "Motor Trend Cars")
#' ```
#'
#' @author Your Name \email{yourname@@email.com}
#' @docType package
#' @name statswift-package
#' @aliases statswift
"_PACKAGE"

#' @import methods
#' @importFrom stats median sd var quantile IQR density
#' @importFrom graphics hist lines abline legend boxplot layout par
#' @importFrom grDevices adjustcolor
NULL
