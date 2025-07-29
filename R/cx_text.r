#' Show information message with context-aware indentation and text wrapping
#'
#' @param message Information message
#' @param ... Additional message components using cli syntax
#' @param verbose Logical, whether to show information messages (default: TRUE)
#' @param max_width Maximum width for text wrapping (default: 120, can be set via CX_MAX_WIDTH env var)
#' @param .envir Environment for string interpolation
#'
#' @export
cx_text <- function(message, ..., verbose = TRUE, max_width = NULL, .envir = parent.frame()) {
  if (isTRUE(verbose)) {
    # Get max width from parameter, environment variable, or default
    if (is.null(max_width)) {
      max_width <- as.numeric(Sys.getenv("CX_MAX_WIDTH", "120"))
    }
    
    # Calculate indentation based on current section depth
    # No sections (0) = 0 indent, Section 1 (1) = 3 indent, Section 1.1 (2) = 6 indent, etc.
    # Level 4+ capped at 12 indent
    current_depth <- .get_current_section_depth()
    indentation <- min(current_depth * .contextual_env$indentation_size, 12)
    
    # Adjust max width to account for indentation
    effective_width <- max_width - indentation
    
    # Use strwrap for consistent text wrapping
    wrapped_text <- strwrap(message, width = effective_width, simplify = FALSE)[[1]]
    
    # Apply indentation to each line manually
    indent_spaces <- paste(rep(" ", indentation), collapse = "")
    for (line in wrapped_text) {
      cat(indent_spaces, line, "\n", sep = "")
    }
  }
}
