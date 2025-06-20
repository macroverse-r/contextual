#' Show debug message
#'
#' @param message Debug message
#' @param ... Additional message components
#' @param debug Logical, whether to show debug messages (default: uses global setting)
#' @param .envir Environment for string interpolation
#'
#' @export
cx_debug <- function(message, ..., debug = .contextual_env$debug, .envir = parent.frame()) {
  if (isTRUE(debug)) {
    # Use simpler styling to avoid cli issues
    formatted_message <- paste0(cli::style_italic(cli::col_grey("[DEBUG] ")), message)
    cli::cli_text(formatted_message, .envir = .envir)
    
    # Show additional details if provided
    details <- list(...)
    if (length(details) > 0) {
      cli::cli_bullets(details, .envir = .envir)
    }
  }
}