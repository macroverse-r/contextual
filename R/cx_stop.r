#' Stop with formatted error message
#'
#' @param message Main error message
#' @param ... Additional message components using cli syntax
#' @param .envir Environment for string interpolation
#' @param .call_level How far back in the call stack to look for the function name (default -1)
#'
#' @export
cx_stop <- function(message, ..., .envir = parent.frame(), .call_level = -1) {
  # Get the calling function name
  call_info <- sys.call(.call_level)
  if (!is.null(call_info) && length(call_info) > 0) {
    # Extract function name from call_info[[1]]
    func_expr <- call_info[[1]]
    
    # Handle different types of function calls
    if (is.call(func_expr)) {
      # For expressions like icy:::get_package_name or icy::get_package_name, extract the function name
      func_name <- deparse(func_expr)
      # Extract just the function name after :: or :::
      if (grepl(":::", func_name)) {
        func_name <- sub(".*:::", "", func_name)
      } else if (grepl("::", func_name)) {
        func_name <- sub(".*::", "", func_name)
      }
    } else {
      # For simple function names
      func_name <- as.character(func_expr)
    }
    
    # Format message with just the error message in red
    formatted_message <- cli::col_red(message)
  } else {
    formatted_message <- cli::col_red(message)
  }
  
  # Create a clean call object with just the function name for the traceback
  clean_call <- call(func_name)
  cli::cli_abort(c("x" = formatted_message), call = clean_call, ..., .envir = .envir)
}
