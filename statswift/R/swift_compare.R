#' Compare Descriptive Statistics Across Groups
#'
#' @description
#' `swift_compare()` computes and displays descriptive statistics for a numeric
#' variable split by a grouping factor. This is useful for quickly comparing
#' distributions across categories (e.g., treatment vs. control, regions, etc.).
#' Returns an S3 object of class `"SwiftCompare"`.
#'
#' @param x A numeric vector of values to summarize.
#' @param groups A vector (factor or character) of group labels. Must be the
#'   same length as `x`.
#' @param na.rm Logical. Should missing values be removed? Defaults to `TRUE`.
#' @param digits Integer. Number of decimal places. Defaults to `3`.
#'
#' @return An S3 object of class `"SwiftCompare"`, a list containing:
#' \describe{
#'   \item{table}{A data frame with one row per group and columns for n, mean,
#'     median, sd, min, max, and IQR.}
#'   \item{groups}{Character vector of unique group names.}
#'   \item{n_groups}{Number of unique groups.}
#' }
#'
#' @examples
#' scores <- c(85, 90, 78, 92, 88, 76, 95, 60, 70, 82)
#' groups <- c("A", "A", "B", "A", "B", "B", "A", "B", "B", "A")
#' result <- swift_compare(scores, groups)
#' print(result)
#'
#' @seealso [swift_summary()], [swift_distplot()]
#' @export
swift_compare <- function(x, groups, na.rm = TRUE, digits = 3) {
  if (!is.numeric(x))  stop("`x` must be a numeric vector.")
  if (length(x) != length(groups)) stop("`x` and `groups` must be the same length.")

  groups <- as.character(groups)
  unique_groups <- sort(unique(groups[!is.na(groups)]))

  rows <- lapply(unique_groups, function(g) {
    vals <- x[groups == g]
    if (na.rm) vals <- vals[!is.na(vals)]
    data.frame(
      Group  = g,
      N      = length(vals),
      Mean   = round(mean(vals), digits),
      Median = round(stats::median(vals), digits),
      SD     = round(stats::sd(vals), digits),
      Min    = round(min(vals), digits),
      Max    = round(max(vals), digits),
      IQR    = round(stats::IQR(vals), digits),
      stringsAsFactors = FALSE
    )
  })

  tbl <- do.call(rbind, rows)

  result <- list(
    table    = tbl,
    groups   = unique_groups,
    n_groups = length(unique_groups)
  )
  class(result) <- "SwiftCompare"
  result
}

#' Print Method for SwiftCompare Objects
#'
#' @param x A `SwiftCompare` object returned by [swift_compare()].
#' @param ... Additional arguments (ignored).
#' @return Invisibly returns `x`.
#' @export
print.SwiftCompare <- function(x, ...) {
  cat("=========================================\n")
  cat("      statswift :: Group Comparison       \n")
  cat(sprintf("         %d Groups Detected              \n", x$n_groups))
  cat("=========================================\n")
  print(x$table, row.names = FALSE)
  cat("=========================================\n")
  invisible(x)
}
