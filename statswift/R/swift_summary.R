#' Compute an Extended Descriptive Summary of a Numeric Vector
#'
#' @description
#' `swift_summary()` computes a comprehensive set of descriptive statistics
#' for a numeric vector, going well beyond base R's `summary()`. It returns
#' an S3 object of class `"SwiftSummary"` with a clean print method.
#'
#' @param x A numeric vector.
#' @param na.rm Logical. Should missing values be removed before computation?
#'   Defaults to `TRUE`.
#' @param digits Integer. Number of decimal places for rounding. Defaults to `3`.
#'
#' @return An S3 object of class `"SwiftSummary"`, which is a named list containing:
#' \describe{
#'   \item{n}{Total number of observations (excluding NAs if `na.rm = TRUE`).}
#'   \item{na_count}{Number of missing values.}
#'   \item{mean}{Arithmetic mean.}
#'   \item{median}{Median.}
#'   \item{sd}{Standard deviation.}
#'   \item{variance}{Variance.}
#'   \item{se}{Standard error of the mean.}
#'   \item{min}{Minimum value.}
#'   \item{max}{Maximum value.}
#'   \item{range}{Range (max - min).}
#'   \item{q1}{First quartile (25th percentile).}
#'   \item{q3}{Third quartile (75th percentile).}
#'   \item{iqr}{Interquartile range.}
#'   \item{skewness}{Skewness of the distribution.}
#'   \item{kurtosis}{Excess kurtosis of the distribution.}
#'   \item{cv}{Coefficient of variation (sd / mean * 100).}
#' }
#'
#' @examples
#' x <- c(4, 7, 13, 2, 1, 9, 15, NA, 6, 3)
#' result <- swift_summary(x)
#' print(result)
#'
#' # Access individual statistics
#' result$mean
#' result$skewness
#'
#' @seealso [swift_outliers()], [swift_compare()]
#' @export
swift_summary <- function(x, na.rm = TRUE, digits = 3) {
  if (!is.numeric(x)) stop("`x` must be a numeric vector.")

  na_count <- sum(is.na(x))
  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)
  if (n < 2) stop("At least 2 non-missing values are required.")

  mn   <- mean(x)
  med  <- stats::median(x)
  sd_x <- stats::sd(x)
  var_x <- stats::var(x)
  se   <- sd_x / sqrt(n)
  q1   <- stats::quantile(x, 0.25, names = FALSE)
  q3   <- stats::quantile(x, 0.75, names = FALSE)
  iqr  <- q3 - q1

  # Skewness and kurtosis (Fisher's definitions)
  skew <- (sum((x - mn)^3) / n) / (sd_x^3)
  kurt <- ((sum((x - mn)^4) / n) / (sd_x^4)) - 3

  cv <- ifelse(mn != 0, (sd_x / mn) * 100, NA)

  result <- list(
    n        = n,
    na_count = na_count,
    mean     = round(mn, digits),
    median   = round(med, digits),
    sd       = round(sd_x, digits),
    variance = round(var_x, digits),
    se       = round(se, digits),
    min      = round(min(x), digits),
    max      = round(max(x), digits),
    range    = round(max(x) - min(x), digits),
    q1       = round(q1, digits),
    q3       = round(q3, digits),
    iqr      = round(iqr, digits),
    skewness = round(skew, digits),
    kurtosis = round(kurt, digits),
    cv       = round(cv, digits)
  )

  class(result) <- "SwiftSummary"
  result
}

#' Print Method for SwiftSummary Objects
#'
#' @param x A `SwiftSummary` object returned by [swift_summary()].
#' @param ... Additional arguments (ignored).
#' @return Invisibly returns `x`.
#' @export
print.SwiftSummary <- function(x, ...) {
  cat("=========================================\n")
  cat("       statswift :: Extended Summary      \n")
  cat("=========================================\n")
  cat(sprintf("  Observations : %d  (NAs: %d)\n", x$n, x$na_count))
  cat("-----------------------------------------\n")
  cat(sprintf("  Mean         : %s\n", x$mean))
  cat(sprintf("  Median       : %s\n", x$median))
  cat(sprintf("  Std Dev      : %s\n", x$sd))
  cat(sprintf("  Variance     : %s\n", x$variance))
  cat(sprintf("  Std Error    : %s\n", x$se))
  cat(sprintf("  CV (%%)        : %s\n", x$cv))
  cat("-----------------------------------------\n")
  cat(sprintf("  Min          : %s\n", x$min))
  cat(sprintf("  Q1           : %s\n", x$q1))
  cat(sprintf("  Q3           : %s\n", x$q3))
  cat(sprintf("  Max          : %s\n", x$max))
  cat(sprintf("  Range        : %s\n", x$range))
  cat(sprintf("  IQR          : %s\n", x$iqr))
  cat("-----------------------------------------\n")
  cat(sprintf("  Skewness     : %s\n", x$skewness))
  cat(sprintf("  Kurtosis     : %s\n", x$kurtosis))
  cat("=========================================\n")
  invisible(x)
}
