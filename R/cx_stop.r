#' Stop with formatted error message
#'
#' @param message Main error message
#' @param ... Additional message components using cli syntax
#' @param .envir Environment for string interpolation
#'
#' @export
cx_stop <- function(message, ..., .envir = parent.frame()) {
  # Get the calling function name
  call_info <- sys.call(-1)
  if (!is.null(call_info)) {
    func_name <- as.character(call_info[[1]])
    # Format message with function name in blue/bold and message in red
    formatted_message <- paste0("in ", 
                                cli::style_bold(cli::col_blue(func_name)), 
                                "(): ", 
                                cli::col_red(message))
  } else {
    formatted_message <- cli::col_red(message)
  }
  
  cli::cli_abort(c("x" = formatted_message), ..., .envir = .envir)
}