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
#' Intentionally Left Blank '#

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
holepunch::write_compendium_description(
  package = getOption("usethis.description")$Package,
  description = getOption("usethis.description")$Description,
  version = "0.0.0.9000"
)

#' Remove `holepunch` from Imports which is added due to the above call.
desc::desc_del_dep("holepunch")

#' Add Remote packages
usethis::use_dev_package("holepunch")

#' Set License
usethis::use_mit_license(name = "Tim Trice")

#' Add GitHub URL and Bug Reports
usethis::use_github_links()

# ---- reset-options ----
#' Intentionally Left Blank '#
