# ---- import_datasets ----
#' @title import_datasets
#' @description Load all csv gzips of a table into one dataframe. All columns
#'   are imported as character by default.
#' @param x Table; details, fatalities, or locations
#' @param y Expected width or number of columns
#' @param ... Additional read_csv parameters
import_datasets <- function(x, y, ...) {
  map_df(
    .x = glue("{ftp}{by_table[[{x}]]}"),
    .f = read_csv,
    #' Make character to avoid reading errors or warnings
    col_types = glue_collapse(rep("c", y)),
    ...
  )
}

# ---- var_conversion ----
#' @title var_conversion
#' @description Test variables in dataframe and convert, without error, to
#'   integer, double, or leave as character.
#' @param x Variable to test
var_conversion <- function(x) {

  quietly_as_integer <- quietly(.f = as.integer)
  quietly_as_double <- quietly(.f = as.double)

  y <- quietly_as_integer(x)
  z <- quietly_as_double(x)

  if (all(y$result == z$result) & !is.na(all(y$result == z$result)))
    return(y$result)

  if (all(is_empty(z$warnings), is_empty(z$messages)))
    return(z$result)

  x
}
