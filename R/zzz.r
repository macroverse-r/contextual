#' Package startup
#' @keywords internal
.onLoad <- function(libname, pkgname) {
  icy::create_local(verbose = FALSE, overwrite = FALSE)


  # Initialize state - CONTEXT-AWARE COUNTERS
  .contextual_env$levels <- c(0, 0, 0)  # levels[1], levels[2], levels[3]
  # Track script-level context separately from function-level numbering
  .contextual_env$script_context_level <- 0  # Level of most recent script-level mv_title call
  # Indentation configuration for mv_text
  .contextual_env$indentation_size <- 3  # Base indentation size
  # Debug control
  .contextual_env$debug <- FALSE  # Global debug flag (default: off)
  # Auto-numbering control: "all", "title", or "none"
  .contextual_env$auto_number <- "all"  # Default: all functions auto-number

  # Track universal execution anchor for all reset detection (unified system)
  .contextual_env$last_execution_anchor <- NULL  # Last execution anchor we saw
}

# Create package environment for state
.contextual_env <- new.env(parent = emptyenv())

