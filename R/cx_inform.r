#' Show formatted information message
#'
#' @param message Information message text
#' @param ... Additional arguments passed to cli functions
#' @param verbose Whether to show the information message (TRUE) or suppress it (FALSE)
#' @param .envir Environment for glue evaluation
#'
#' @export
cx_inform <- function(message, ..., verbose = TRUE, .envir = parent.frame()) {
  if (isTRUE(verbose)) {
    # Use cli's built-in "i" bullet for blue info styling
    bullet_message <- structure(message, names = "i")
    cli::cli_inform(bullet_message, ..., .envir = .envir)
  }
}