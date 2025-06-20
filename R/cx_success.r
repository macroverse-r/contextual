#' Show success message
#'
#' @param message Success message
#' @param ... Additional message components using cli syntax
#' @param verbose Logical, whether to show success messages (default: TRUE)
#' @param .envir Environment for string interpolation
#'
#' @export
cx_success <- function(message, ..., verbose = TRUE, .envir = parent.frame()) {
  if (isTRUE(verbose)) {
    # First show the main success message with green text
    cli::cli_inform(c("v" = cli::col_br_green(message)), .envir = .envir)
    
    # Then show any additional details
    details <- list(...)
    if (length(details) > 0) {
      cli::cli_bullets(details, .envir = .envir)
    }
  }
}