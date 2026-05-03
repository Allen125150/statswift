# statswift <img src="man/figures/logo.png" align="right" height="120" alt="statswift logo"/>

<!-- badges: start -->
![R](https://img.shields.io/badge/R-%3E%3D4.1.0-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
<!-- badges: end -->

> Fast and friendly descriptive statistics and data summaries for R.

**statswift** is a lightweight R package providing clean, readable descriptive statistics and data summaries. It is designed for students and analysts who want comprehensive statistical output quickly — without heavy dependencies.

---

## Features

- **`swift_summary()`** — Extended descriptive stats (mean, median, SD, SE, skewness, kurtosis, CV, and more) — *S3 class*
- **`swift_outliers()`** — Outlier detection via IQR or Z-score — *S3 class*
- **`swift_compare()`** — Group-wise descriptive comparison table — *S3 class*
- **`swift_distplot()`** — Distribution visualization (histogram + density + boxplot)
- **`swift_report()`** — Full statistical report for an entire data frame — *S4 class*

---

## Installation

Install from GitHub using `devtools`:

```r
# install.packages("devtools")
devtools::install_github("yourusername/statswift")
```

---

## Quick Start

```r
library(statswift)

# 1. Extended summary statistics
swift_summary(mtcars$mpg)

# 2. Outlier detection
swift_outliers(mtcars$mpg, method = "iqr")

# 3. Compare across groups
swift_compare(mtcars$mpg, mtcars$cyl)

# 4. Distribution plot
swift_distplot(mtcars$mpg, main = "MPG Distribution", col = "steelblue")

# 5. Full dataset report (S4)
swift_report(mtcars, data_name = "Motor Trend Cars")
```

---

## Example Output

### `swift_summary()`

```
=========================================
       statswift :: Extended Summary      
=========================================
  Observations : 32  (NAs: 0)
-----------------------------------------
  Mean         : 20.091
  Median       : 19.2
  Std Dev      : 6.027
  Variance     : 36.324
  Std Error    : 1.065
  CV (%)       : 29.999
-----------------------------------------
  Min          : 10.4
  Q1           : 15.425
  Q3           : 22.8
  Max          : 33.9
  Range        : 23.5
  IQR          : 7.375
-----------------------------------------
  Skewness     : 0.611
  Kurtosis     : -0.373
=========================================
```

### `swift_compare()`

```
=========================================
      statswift :: Group Comparison       
         3 Groups Detected              
=========================================
 Group  N   Mean Median    SD  Min  Max   IQR
     4 11 26.664   26.0 4.510 21.4 33.9 4.600
     6  7 19.743   19.7 1.454 17.8 21.4 2.350
     8 14 15.100   15.2 2.560 10.4 19.2 2.625
=========================================
```

---

## Class System

`statswift` uses both S3 and S4 class systems:

| Class | System | Created By | Method |
|---|---|---|---|
| `SwiftSummary` | S3 | `swift_summary()` | `print()` |
| `SwiftOutliers` | S3 | `swift_outliers()` | `print()` |
| `SwiftCompare` | S3 | `swift_compare()` | `print()` |
| `SwiftReport` | S4 | `swift_report()` | `show()` |

---

## Documentation

Full long-form documentation is available in the package vignette:

```r
vignette("introduction-to-statswift", package = "statswift")
```

---

## Dependencies

`statswift` uses only base R packages:

- `stats` — statistical computations
- `graphics` — base R plotting
- `grDevices` — color utilities
- `methods` — S4 class system

No external CRAN packages are required.

---

## License

MIT © 2026 Allen Zagic. See [LICENSE](LICENSE) for details.
