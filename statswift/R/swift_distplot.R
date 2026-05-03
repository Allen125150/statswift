#' Plot the Distribution of a Numeric Vector
#'
#' @description
#' `swift_distplot()` generates a composite distribution plot for a numeric
#' vector, combining a histogram with a density curve and a boxplot. This
#' gives a quick visual summary of a variable's distribution, central
#' tendency, spread, and skewness.
#'
#' @param x A numeric vector.
#' @param main Character. Main title of the plot. Defaults to
#'   `"Distribution Plot"`.
#' @param col Character. Fill color for the histogram bars. Defaults to
#'   `"steelblue"`.
#' @param na.rm Logical. Should missing values be removed? Defaults to `TRUE`.
#' @param show_mean Logical. Should a vertical line for the mean be drawn?
#'   Defaults to `TRUE`.
#' @param show_median Logical. Should a vertical line for the median be drawn?
#'   Defaults to `TRUE`.
#'
#' @return Invisibly returns `NULL`. Called for its side effect of producing a plot.
#'
#' @examples
#' set.seed(42)
#' x <- rnorm(200, mean = 50, sd = 10)
#' swift_distplot(x, main = "Simulated Normal Distribution", col = "coral")
#'
#' # Right-skewed data
#' y <- rexp(200, rate = 0.1)
#' swift_distplot(y, main = "Exponential Distribution", col = "forestgreen")
#'
#' @seealso [swift_summary()], [swift_compare()]
#' @export
swift_distplot <- function(x, main = "Distribution Plot", col = "steelblue",
                           na.rm = TRUE, show_mean = TRUE, show_median = TRUE) {
  if (!is.numeric(x)) stop("`x` must be a numeric vector.")
  if (na.rm) x <- x[!is.na(x)]
  if (length(x) < 2) stop("At least 2 non-missing values are required.")

  # Save original par settings and restore on exit
  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par))

  # Layout: histogram on top, boxplot on bottom
  graphics::layout(matrix(c(1, 2), nrow = 2), heights = c(3, 1))
  graphics::par(mar = c(2, 4, 3, 2))

  # --- Histogram + Density ---
  h <- graphics::hist(x, plot = FALSE)
  y_max <- max(h$density, stats::density(x)$y) * 1.15

  graphics::hist(x,
    freq  = FALSE,
    col   = grDevices::adjustcolor(col, alpha.f = 0.6),
    border = "white",
    main  = main,
    xlab  = "",
    ylab  = "Density",
    ylim  = c(0, y_max),
    las   = 1
  )

  # Density curve
  graphics::lines(stats::density(x), col = "black", lwd = 2)

  # Mean and median lines
  if (show_mean) {
    graphics::abline(v = mean(x), col = "firebrick", lwd = 2, lty = 2)
  }
  if (show_median) {
    graphics::abline(v = stats::median(x), col = "darkgreen", lwd = 2, lty = 3)
  }

  # Legend
  legend_labels <- c()
  legend_cols   <- c()
  legend_lty    <- c()
  if (show_mean)   { legend_labels <- c(legend_labels, sprintf("Mean = %.2f",   mean(x)));           legend_cols <- c(legend_cols, "firebrick");  legend_lty <- c(legend_lty, 2) }
  if (show_median) { legend_labels <- c(legend_labels, sprintf("Median = %.2f", stats::median(x))); legend_cols <- c(legend_cols, "darkgreen");  legend_lty <- c(legend_lty, 3) }

  if (length(legend_labels) > 0) {
    graphics::legend("topright", legend = legend_labels, col = legend_cols,
                     lty = legend_lty, lwd = 2, bty = "n", cex = 0.85)
  }

  # --- Boxplot ---
  graphics::par(mar = c(3, 4, 0, 2))
  graphics::boxplot(x,
    horizontal = TRUE,
    col        = grDevices::adjustcolor(col, alpha.f = 0.4),
    border     = "black",
    xlab       = "Value",
    notch      = FALSE,
    outline    = TRUE
  )

  invisible(NULL)
}
