#' @title setup
#' @author Tim Trice <tim.trice@gmail.com>
#' @description Initiate workflowr package
#' @details NA
#' @param NA
#' @examples
#' \code{
#'   Rscript --verbose ./code/settings.R
#' }

# ---- libraries ----
library(holepunch)
library(usethis)

# ---- settings  ----
#' Intentionally Left Blank '#

# ---- options ----
#' Intentionally Left Blank '#

# ---- functions ----
#' Intentionally Left Blank '#

# ---- variables ----
#' Intentionally Left Blank '#

# ---- data ----
#' Intentionally Left Blank '#

# ---- * cleaning  ----
#' Intentionally Left Blank '#

# ---- execution ----

#' Initiate DESCRIPTION
write_compendium_description(
  package = getOption("usethis.description")$Package,
  description = getOption("usethis.description")$Description,
  version = "0.0.0.9000"
)

#' Set License
use_mit_license(name = "Tim Trice")

#' Add GitHub URL and Bug Reports
use_github_links()

# ---- reset-options ----
#' Intentionally Left Blank '#
