#' Smart title function with automatic numbering
#' 
#' @param title Character string. The heading text to display.
#' @param level_adjust Integer. Number of levels to add to the calculated depth (default: 0).
#' @param reset Logical. If TRUE, reset numbering before displaying this title (default: FALSE).
#' @param auto_number Logical. Whether to automatically number this heading (default: TRUE).
#' @param .envir Environment. Environment for string interpolation.
#' 
#' @export
cx_title <- function(title, level_adjust = 0, reset = FALSE, auto_number = TRUE, .envir = parent.frame()) {
  # Calculate user function depth
  calls <- sys.calls()
  user_depth <- .get_user_function_depth(calls)
  
  # Debug output
  cx_debug(sprintf("cx_title: user_depth=%d, title='%s', counters=[%d,%d,%d]", 
                   user_depth, substr(title, 1, 20), 
                   .contextual_env$levels[1], .contextual_env$levels[2], .contextual_env$levels[3]), debug = .contextual_env$debug)
  
  # Handle reset detection using shared logic
  should_reset <- .handle_reset_detection(reset)
  
  # HIERARCHICAL LOGIC: Unified depth calculation
  # Key insight: A() calls should be subordinate to wherever they're called from
  
  has_existing_numbering <- (.contextual_env$levels[1] > 0)
  
  # Unified calculation: determine base depth, then add level_adjust
  if (user_depth == 0) {
    # Script-level mv_title call - continue document structure at level 1
    base_depth <- 1
    script_context_level <- base_depth + level_adjust
  } else if (has_existing_numbering) {
    # Function call with existing context → subordinate to current context
    effective_context_level <- .get_current_effective_context_level(user_depth)
    base_depth <- effective_context_level + 1
    script_context_level <- .contextual_env$script_context_level  # Keep existing
  } else {
    # Function calls without context: Start at level 1
    base_depth <- 1
    script_context_level <- .contextual_env$script_context_level  # FIXED: Keep existing, don't override
  }
  
  effective_depth <- base_depth + level_adjust
  
  # Safety check - minimum level is 1
  if (effective_depth < 1) effective_depth <- 1
  
  # Combine individual parameter with global setting
  effective_auto_number <- auto_number && .should_auto_number("cx_title")
  
  if (effective_auto_number) {
    # Delegate to internal function for numbered titles
    .cx_title_with_depth(title, effective_depth, script_context_level, reset_applied = should_reset, .envir = .envir)
  } else {
    # Use formatter directly for non-numbered titles
    if (effective_depth <= 4) {
      .format_heading(title, level = effective_depth, .envir = .envir)
    }
    # Depth > 4: no output
  }
  
  invisible()
}

#' Reset section numbering
#' 
#' @description
#' Resets the section numbering system used by cx_title.
#' Call this at the beginning of a new analysis or report section.
#' 
#' @export
cx_reset_numbering <- function() {
  .contextual_env$levels <- c(0, 0, 0)
  .contextual_env$script_context_level <- 0
  .contextual_env$last_execution_anchor <- NULL
  invisible()
}