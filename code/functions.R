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
