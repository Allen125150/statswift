#' SwiftReport: An S4 Class for Full Dataset Statistical Reports
#'
#' @description
#' The `SwiftReport` S4 class stores a structured statistical report for an
#' entire data frame, including per-column descriptive summaries and metadata.
#' Use [swift_report()] to construct a `SwiftReport` object.
#'
#' @slot data_name Character. The name of the dataset.
#' @slot n_rows Integer. Number of rows in the dataset.
#' @slot n_cols Integer. Number of columns in the dataset.
#' @slot numeric_cols Character vector of numeric column names.
#' @slot summaries List of per-column summary statistics (named list of lists).
#' @slot generated_at Character. Timestamp when the report was generated.
#'
#' @exportClass SwiftReport
setClass("SwiftReport",
  representation(
    data_name    = "character",
    n_rows       = "integer",
    n_cols       = "integer",
    numeric_cols = "character",
    summaries    = "list",
    generated_at = "character"
  )
)

#' Generate a Full Statistical Report for a Data Frame (S4)
#'
#' @description
#' `swift_report()` inspects an entire data frame and produces a structured
#' `SwiftReport` S4 object. For every numeric column it computes key
#' descriptive statistics (mean, median, sd, min, max, NA count, skewness).
#' The result can be printed to the console for a clean, formatted overview
#' of your dataset.
#'
#' @param df A data frame.
#' @param data_name Character. A label for the dataset (used in printing).
#'   Defaults to `"Dataset"`.
#' @param digits Integer. Decimal places for rounding. Defaults to `3`.
#' @param na.rm Logical. Should NAs be removed before computing stats?
#'   Defaults to `TRUE`.
#'
#' @return An S4 object of class `"SwiftReport"`.
#'
#' @examples
#' report <- swift_report(mtcars, data_name = "Motor Trend Cars")
#' show(report)
#'
#' report2 <- swift_report(iris, data_name = "Fisher's Iris Dataset")
#' show(report2)
#'
#' @seealso [swift_summary()], [swift_compare()]
#' @export
swift_report <- function(df, data_name = "Dataset", digits = 3, na.rm = TRUE) {
  if (!is.data.frame(df)) stop("`df` must be a data frame.")

  num_cols <- names(df)[sapply(df, is.numeric)]

  summaries <- lapply(num_cols, function(col) {
    vals <- df[[col]]
    if (na.rm) vals_clean <- vals[!is.na(vals)] else vals_clean <- vals
    n <- length(vals_clean)
    if (n < 2) return(list(note = "Insufficient data"))
    mn  <- mean(vals_clean)
    sd_x <- stats::sd(vals_clean)
    skew <- (sum((vals_clean - mn)^3) / n) / (sd_x^3)
    list(
      n        = n,
      na_count = sum(is.na(vals)),
      mean     = round(mn, digits),
      median   = round(stats::median(vals_clean), digits),
      sd       = round(sd_x, digits),
      min      = round(min(vals_clean), digits),
      max      = round(max(vals_clean), digits),
      skewness = round(skew, digits)
    )
  })
  names(summaries) <- num_cols

  methods::new("SwiftReport",
    data_name    = as.character(data_name),
    n_rows       = as.integer(nrow(df)),
    n_cols       = as.integer(ncol(df)),
    numeric_cols = num_cols,
    summaries    = summaries,
    generated_at = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  )
}

#' Show Method for SwiftReport S4 Objects
#'
#' @description
#' Prints a formatted statistical report to the console for a `SwiftReport`
#' S4 object produced by [swift_report()].
#'
#' @param object A `SwiftReport` S4 object.
#' @return Invisibly returns `object`.
#' @exportMethod show
setMethod("show", "SwiftReport", function(object) {
  cat("=========================================\n")
  cat("       statswift :: Dataset Report        \n")
  cat("=========================================\n")
  cat(sprintf("  Dataset      : %s\n", object@data_name))
  cat(sprintf("  Generated    : %s\n", object@generated_at))
  cat(sprintf("  Rows         : %d\n", object@n_rows))
  cat(sprintf("  Columns      : %d  (%d numeric)\n", object@n_cols, length(object@numeric_cols)))
  cat("-----------------------------------------\n")

  for (col in object@numeric_cols) {
    s <- object@summaries[[col]]
    cat(sprintf("\n  [ %s ]\n", col))
    if (!is.null(s$note)) {
      cat(sprintf("    %s\n", s$note))
    } else {
      cat(sprintf("    n=%d  NAs=%d  Mean=%-8s  Median=%-8s\n",
                  s$n, s$na_count, s$mean, s$median))
      cat(sprintf("    SD=%-8s  Min=%-8s  Max=%-8s  Skew=%s\n",
                  s$sd, s$min, s$max, s$skewness))
    }
  }
  cat("\n=========================================\n")
  invisible(object)
})
