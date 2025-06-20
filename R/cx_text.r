#' Show information message with context-aware indentation
#'
#' @param message Information message
#' @param ... Additional message components using cli syntax
#' @param verbose Logical, whether to show information messages (default: TRUE)
#' @param .envir Environment for string interpolation
#'
#' @export
cx_text <- function(message, ..., verbose = TRUE, .envir = parent.frame()) {
  if (isTRUE(verbose)) {
    # Calculate indentation based on current section depth
    # No sections (0) = 0 indent, Section 1 (1) = 3 indent, Section 1.1 (2) = 6 indent, etc.
    # Level 4+ capped at 12 indent
    current_depth <- .get_current_section_depth()
    indentation <- min(current_depth * .contextual_env$indentation_size, 12)
    
    cli::cli_div(theme = list(div = list("margin-left" = indentation)))
    cli::cli_text(message = message, ..., .envir = .envir)
    cli::cli_end()
  }
}