# Internal utility functions

# Helper operator
`%||%` <- function(x, y) if (is.null(x)) y else x

# Helper function to determine if a function should auto-number based on global setting
.should_auto_number <- function(function_type) {
  setting <- .contextual_env$auto_number
  if (setting == "all") return(TRUE)
  if (setting == "title" && function_type == "cx_title") return(TRUE) 
  if (setting == "none") return(FALSE)
  return(FALSE)  # Default fallback
}

# Get current section depth for indentation calculation
.get_current_section_depth <- function() {
  # Count how many levels are currently active (non-zero)
  active_levels <- sum(.contextual_env$levels > 0)
  return(active_levels)
}

# Shared reset detection logic
.handle_reset_detection <- function(reset = FALSE) {
  execution_anchor_reset <- FALSE
  if (!reset) {  # Only check if not already resetting
    current_execution_anchor <- .create_execution_anchor()
    
    if (is.null(.contextual_env$last_execution_anchor)) {
      # First execution ever
      .contextual_env$last_execution_anchor <- current_execution_anchor
    } else if (.contextual_env$last_execution_anchor != current_execution_anchor) {
      # Different execution detected (works for both scripts and functions)
      execution_anchor_reset <- TRUE
      .contextual_env$last_execution_anchor <- current_execution_anchor
    }
  }
  
  # Combine all reset conditions: explicit or execution anchor change
  should_reset <- reset || execution_anchor_reset
  
  if (should_reset) {
    # Reset numbering for new execution
    .contextual_env$levels <- c(0, 0, 0)
    .contextual_env$script_context_level <- 0
  }
  
  return(should_reset)
}

# Shared level counter update logic
.update_level_counters <- function(effective_depth) {
  # Increment counter for given level and reset deeper levels
  .contextual_env$levels[effective_depth] <- .contextual_env$levels[effective_depth] + 1
  # Reset deeper levels
  if (effective_depth < 3) {
    .contextual_env$levels[(effective_depth + 1):3] <- 0
  }
}

# Shared section number building logic
.build_section_number <- function(effective_depth) {
  if (effective_depth == 1) {
    section_number <- as.character(.contextual_env$levels[1])
  } else if (effective_depth == 2) {
    if (.contextual_env$levels[1] > 0) {
      section_number <- paste0(.contextual_env$levels[1], ".", .contextual_env$levels[2])
    } else {
      section_number <- as.character(.contextual_env$levels[2])
    }
  } else if (effective_depth == 3) {
    if (.contextual_env$levels[1] > 0 && .contextual_env$levels[2] > 0) {
      section_number <- paste0(.contextual_env$levels[1], ".", .contextual_env$levels[2], ".", .contextual_env$levels[3])
    } else if (.contextual_env$levels[2] > 0) {
      section_number <- paste0(.contextual_env$levels[2], ".", .contextual_env$levels[3])
    } else {
      section_number <- as.character(.contextual_env$levels[3])
    }
  }
  return(section_number)
}

# Unified formatting function for all heading levels
.format_heading <- function(title, level, .envir = parent.frame()) {
  if (level == 1) {
    # Level 1: bright magenta with double lines, uppercase
    formatted_title <- cli::col_br_magenta(paste0("\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550 ", cli::style_bold(toupper(title)), " \u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550\u2550"))
    cli::cli_text(formatted_title, .envir = .envir)
  } else if (level == 2) {
    # Level 2: purple with dashes, title case
    formatted_title <- paste0("\u001b[38;5;99m\u2500\u2500\u2500\u2500\u2500 ", cli::style_bold(title), " \u2500\u2500\u2500\u2500\u2500\u001b[0m")
    cli::cli_text(formatted_title, .envir = .envir)
  } else if (level == 3) {
    # Level 3: lighter purple with short dashes
    formatted_title <- paste0("\u001b[38;5;141m\u2500\u2500\u2500 ", title, "\u001b[0m")
    cli::cli_text(formatted_title, .envir = .envir)
  } else if (level == 4) {
    # Level 4: arrow with no numbering
    colored_arrow_title <- paste0("\u001b[38;5;141m\u2192 \u001b[0m", title)
    cli::cli_text(colored_arrow_title, .envir = .envir)
  }
}

# Unified numbered heading function - consolidates all numbering logic
.cx_heading_numbered <- function(title, level, reset = FALSE, .envir = parent.frame()) {
  # Handle reset detection using shared logic
  should_reset <- .handle_reset_detection(reset)
  
  # Update script context level for function subordination
  .contextual_env$script_context_level <- level
  
  # Update level counters using shared logic
  .update_level_counters(level)
  
  # Build section number using shared logic
  section_number <- .build_section_number(level)
  
  # Create numbered title
  numbered_title <- paste0(section_number, ". ", title)
  
  # Format and display using unified formatter
  .format_heading(numbered_title, level, .envir = .envir)
}

# Internal function for cx_title - handles numbering with pre-calculated context
.cx_title_with_depth <- function(title, effective_depth, script_context_level, reset_applied = FALSE, auto_number = TRUE, .envir = parent.frame()) {
  # Update script context level (this was calculated by cx_title)
  .contextual_env$script_context_level <- script_context_level
  
  if (effective_depth <= 3) {
    # Always update counters for context tracking
    .update_level_counters(effective_depth)
    
    # Conditionally add numbering
    if (auto_number) {
      # Build section number using shared logic
      section_number <- .build_section_number(effective_depth)
      # Create numbered title
      display_title <- paste0(section_number, ". ", title)
    } else {
      # Use title as-is without numbering
      display_title <- title
    }
    
    # Format and display using unified formatter
    .format_heading(display_title, effective_depth, .envir = .envir)
  } else if (effective_depth == 4) {
    # Level 4 - use formatter directly (no numbering at this level anyway)
    .format_heading(title, level = 4, .envir = .envir)
  }
  # Depth > 4: no output
}

# Create universal execution anchor for all reset detection (unified system)
.create_execution_anchor <- function() {
  calls <- sys.calls()
  
  if (length(calls) > 0) {
    # We have a call stack - use environment-based anchor
    top_env_str <- capture.output(print(sys.frame(1)))[1]
    env_hex <- gsub(".*0x([0-9a-f]+).*", "\\1", top_env_str)
    return(paste0("EXEC_", env_hex))
  } else {
    # No call stack (Rscript, R --file, etc.) - use timestamp
    return(paste0("DIRECT_", round(as.numeric(Sys.time()) * 1000000)))
  }
}

# Get current effective context level (script + function context)
.get_current_effective_context_level <- function(user_depth) {
  # For functions, determine effective context based on call depth
  # Shallow calls (like "Continuing A") should use the level they started at
  
  if (user_depth <= 1) {
    # Shallow function calls - use script context, not deep function context
    # This prevents "Continuing A" from being subordinate to deeply nested B() calls
    script_level <- .contextual_env$script_context_level
    return(script_level)
  } else {
    # Deep function calls - calculate based on user_depth for proper hierarchical nesting
    # user_depth=2 -> context should be at least 2 (from shallow calls)
    # user_depth=3 -> context should be at least 3 
    # user_depth=4 -> context should be at least 4
    # This ensures E() (user_depth=5) gets effective_depth=5 (no output)
    script_level <- .contextual_env$script_context_level
    min_context_for_depth <- script_level + user_depth - 1
    return(min_context_for_depth)
  }
}

# Calculate user function depth - FIXED VERSION
.get_user_function_depth <- function(calls) {
  excluded_functions <- c("source", "eval", "eval.parent", "local", "eval.with.vis",
                         "do.call", "lapply", "sapply", "for", "{", "withVisible",
                         "%||%", ".build_section_number", ".GlobalEnv", 
                         # icy integration: Make .icy_title transparent to hierarchical calculation
                         ".icy_title", "icy:::.icy_title",
                         # R internal error handling: Don't count toward user function depth
                         "tryCatch", "tryCatchList", "tryCatchOne", "doTryCatch")
  
  depth <- 0
  seen_functions <- character()
  
  for (i in seq_along(calls)) {
    if (length(calls[[i]]) > 0) {
      func_name <- deparse(calls[[i]][[1]], nlines = 1)
      is_cx <- grepl("^cx_", func_name)
      is_excluded <- func_name %in% excluded_functions
      
      if (!is_cx && !is_excluded) {
        # Only count unique functions to avoid double-counting recursive calls
        if (!func_name %in% seen_functions) {
          depth <- depth + 1
          seen_functions <- c(seen_functions, func_name)
        }
      }
    }
  }
  return(depth)
}