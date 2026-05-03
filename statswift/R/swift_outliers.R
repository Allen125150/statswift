#' Detect Outliers in a Numeric Vector
#'
#' @description
#' `swift_outliers()` identifies outliers in a numeric vector using two
#' widely-used methods: the IQR (Tukey) fence method and the Z-score method.
#' It returns an S3 object of class `"SwiftOutliers"` summarizing detected
#' outliers and their indices.
#'
#' @param x A numeric vector.
#' @param method Character string specifying the detection method. One of
#'   `"iqr"` (default) or `"zscore"`.
#' @param threshold Numeric threshold. For `"iqr"`, the fence multiplier
#'   (default `1.5`). For `"zscore"`, the Z-score cutoff (default `3`).
#' @param na.rm Logical. Should missing values be removed? Defaults to `TRUE`.
#'
#' @return An S3 object of class `"SwiftOutliers"`, a list containing:
#' \describe{
#'   \item{method}{The detection method used.}
#'   \item{threshold}{The threshold applied.}
#'   \item{outlier_values}{Numeric vector of detected outlier values.}
#'   \item{outlier_indices}{Integer vector of positions in `x` of outliers.}
#'   \item{n_outliers}{Count of detected outliers.}
#'   \item{pct_outliers}{Percentage of observations flagged as outliers.}
#'   \item{lower_fence}{Lower fence (IQR method only, else `NA`).}
#'   \item{upper_fence}{Upper fence (IQR method only, else `NA`).}
#' }
#'
#' @examples
#' x <- c(2, 3, 4, 5, 6, 7, 100, -50, 5, 4)
#'
#' # IQR method (default)
#' swift_outliers(x)
#'
#' # Z-score method
#' swift_outliers(x, method = "zscore", threshold = 2.5)
#'
#' @seealso [swift_summary()]
#' @export
swift_outliers <- function(x, method = "iqr", threshold = NULL, na.rm = TRUE) {
  if (!is.numeric(x)) stop("`x` must be a numeric vector.")
  method <- match.arg(method, c("iqr", "zscore"))

  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)

  if (method == "iqr") {
    if (is.null(threshold)) threshold <- 1.5
    q1 <- stats::quantile(x, 0.25, names = FALSE)
    q3 <- stats::quantile(x, 0.75, names = FALSE)
    iqr <- q3 - q1
    lower_fence <- q1 - threshold * iqr
    upper_fence <- q3 + threshold * iqr
    is_outlier  <- x < lower_fence | x > upper_fence
  } else {
    if (is.null(threshold)) threshold <- 3
    z_scores   <- abs((x - mean(x)) / stats::sd(x))
    is_outlier <- z_scores > threshold
    lower_fence <- NA
    upper_fence <- NA
  }

  result <- list(
    method          = method,
    threshold       = threshold,
    outlier_values  = x[is_outlier],
    outlier_indices = which(is_outlier),
    n_outliers      = sum(is_outlier),
    pct_outliers    = round(sum(is_outlier) / n * 100, 2),
    lower_fence     = if (method == "iqr") round(lower_fence, 3) else NA,
    upper_fence     = if (method == "iqr") round(upper_fence, 3) else NA
  )

  class(result) <- "SwiftOutliers"
  result
}

#' Print Method for SwiftOutliers Objects
#'
#' @param x A `SwiftOutliers` object returned by [swift_outliers()].
#' @param ... Additional arguments (ignored).
#' @return Invisibly returns `x`.
#' @export
print.SwiftOutliers <- function(x, ...) {
  cat("=========================================\n")
  cat("      statswift :: Outlier Detection      \n")
  cat("=========================================\n")
  cat(sprintf("  Method       : %s\n", toupper(x$method)))
  cat(sprintf("  Threshold    : %s\n", x$threshold))
  if (!is.na(x$lower_fence)) {
    cat(sprintf("  Lower Fence  : %s\n", x$lower_fence))
    cat(sprintf("  Upper Fence  : %s\n", x$upper_fence))
  }
  cat("-----------------------------------------\n")
  cat(sprintf("  # Outliers   : %d (%.2f%%)\n", x$n_outliers, x$pct_outliers))
  if (x$n_outliers > 0) {
    cat(sprintf("  Indices      : %s\n", paste(x$outlier_indices, collapse = ", ")))
    cat(sprintf("  Values       : %s\n", paste(x$outlier_values, collapse = ", ")))
  } else {
    cat("  No outliers detected.\n")
  }
  cat("=========================================\n")
  invisible(x)
}
