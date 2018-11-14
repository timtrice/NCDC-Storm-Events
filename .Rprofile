#' Check all package requirements are met.

#' Packages required for this project.
pkgs <- c(
  "data.table",
  "devtools",
  "here",
  "tidyverse",
  "workflowr"
)

#' What's missing
missing_pkgs <- pkgs[!(pkgs %in% utils::installed.packages()[, "Package"])]

#' Message
if (length(missing_pkgs) > 0)
  message(
    sprintf(
      "Required packages missing: %s\nRun install.packages(missing)",
      paste0(missing_pkgs, collapse = ", ")
    )
  )

rm(pkgs)
