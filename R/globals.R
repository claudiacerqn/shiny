# A scope where we can put mutable global state
.globals <- new.env(parent = emptyenv())

#' Check whether a Shiny application is running
#'
#' This function tests whether a Shiny application is currently running.
#'
#' @return \code{TRUE} if a Shiny application is currently running. Otherwise,
#'   \code{FALSE}.
#' @export
isRunning <- function() {
  .globals$running
}

.onLoad <- function(libname, pkgname) {
  # R's lazy-loading package scheme causes the private seed to be cached in the
  # package itself, making our PRNG completely deterministic. This line resets
  # the private seed during load.
  withPrivateSeed(set.seed(NULL))
}

.onAttach <- function(libname, pkgname) {
  # Check for htmlwidgets version, if installed. As of Shiny 0.12.0 and
  # htmlwidgets 0.4, both packages switched from RJSONIO to jsonlite. Because of
  # this change, Shiny 0.12.0 will work only with htmlwidgets >= 0.4, and vice
  # versa.
  if (system.file(package = "htmlwidgets") != "" &&
      utils::packageVersion("htmlwidgets") < "0.4") {
    packageStartupMessage(
      "This version of Shiny is designed to work with htmlwidgets >= 0.4. ",
      "Please upgrade your version of htmlwidgets."
    )
  }
}
