#' Display bulleted list
#'
#' @description
#' Displays a bulleted list using cli formatting. Takes a named vector
#' and outputs with bullet points, handling both named and unnamed items.
#'
#' @param items Named vector of items to display. Names become labels, values become content.
#' @param bullet Character string for bullet type (default: uses CX_BULLET_TYPE from config)
#' @param .envir Environment for string interpolation
#'
#' @importFrom utils as.roman
#' @export
cx_bullets <- function(items, bullet = NULL, .envir = parent.frame()) {
  if (length(items) == 0) return(invisible())
  
  # Greek letters for \u03B1. numbering
  greek_letters <- c("\u03B1", "\u03B2", "\u03B3", "\u03B4", "\u03B5", "\u03B6", "\u03B7", "\u03B8", "\u03B9", "\u03BA", "\u03BB", "\u03BC", 
                     "\u03BD", "\u03BE", "\u03BF", "\u03C0", "\u03C1", "\u03C3", "\u03C4", "\u03C5", "\u03C6", "\u03C7", "\u03C8", "\u03C9")
  
  # Helper function to generate numbered bullets
  generate_numbered_bullet <- function(type, index) {
    switch(type,
      "1." = paste0(index, "."),
      "1:" = paste0(index, ":"),
      "(1)" = paste0("(", index, ")"),
      "a." = {
        if (index > 26) paste0(index, ".") else paste0(letters[index], ".")
      },
      "a:" = {
        if (index > 26) paste0(index, ":") else paste0(letters[index], ":")
      },
      "(a)" = {
        if (index > 26) paste0("(", index, ")") else paste0("(", letters[index], ")")
      },
      "A." = {
        if (index > 26) paste0(index, ".") else paste0(LETTERS[index], ".")
      },
      "A:" = {
        if (index > 26) paste0(index, ":") else paste0(LETTERS[index], ":")
      },
      "(A)" = {
        if (index > 26) paste0("(", index, ")") else paste0("(", LETTERS[index], ")")
      },
      "i." = paste0(tolower(as.roman(index)), "."),
      "i:" = paste0(tolower(as.roman(index)), ":"),
      "(i)" = paste0("(", tolower(as.roman(index)), ")"),
      "I." = paste0(toupper(as.roman(index)), "."),
      "I:" = paste0(toupper(as.roman(index)), ":"),
      "(I)" = paste0("(", toupper(as.roman(index)), ")"),
      "\u03B1." = {
        if (index > 24) paste0(index, ".") else paste0(greek_letters[index], ".")
      },
      "\u03B1:" = {
        if (index > 24) paste0(index, ":") else paste0(greek_letters[index], ":")
      },
      "(\u03B1)" = {
        if (index > 24) paste0("(", index, ")") else paste0("(", greek_letters[index], ")")
      },
      # User-friendly Greek aliases
      "grec." = {
        if (index > 24) paste0(index, ".") else paste0(greek_letters[index], ".")
      },
      "grec:" = {
        if (index > 24) paste0(index, ":") else paste0(greek_letters[index], ":")
      },
      "(grec)" = {
        if (index > 24) paste0("(", index, ")") else paste0("(", greek_letters[index], ")")
      },
      "\u2022"  # fallback
    )
  }
  
  # Get bullet type from config if not specified
  if (is.null(bullet)) {
    bullet <- icy::get_config(package = "contextual", origin = "priority")$CX_BULLET_TYPE
  }
  
  # Handle slash notation (e.g., "α./grec." -> use first option)
  if (grepl("/", bullet)) {
    bullet <- strsplit(bullet, "/")[[1]][1]
  }
  
  # Check if this is a numbering type or symbol type
  numbering_types <- c("1.", "1:", "(1)", "a.", "a:", "(a)", "A.", "A:", "(A)", 
                       "i.", "i:", "(i)", "I.", "I:", "(I)", "\u03B1.", "\u03B1:", "(\u03B1)",
                       "grec.", "grec:", "(grec)")
  is_numbering <- bullet %in% numbering_types
  
  if (!is_numbering) {
    # Traditional symbol bullets
    bullet_map <- list(
      "dot" = "\u2022",
      "arrow" = "\u2192", 
      "dash" = "-",
      "star" = "\u2605",
      "check" = "\u2713",
      "none" = ""
    )
    bullet_symbol <- bullet_map[[bullet]] %||% "\u2022"  # fallback to dot
  }
  
  # Calculate base indentation from section depth
  indent_depth <- .get_current_section_depth() - icy::get_config(package = "contextual", origin = "priority")$CX_INDENT_LV_START
  base_indentation <- max(0, min(indent_depth * icy::get_config(package = "contextual", origin = "priority")$CX_INDENT_WIDTH, 12))
  
  # Add bullet-specific indentation
  bullet_indentation <- icy::get_config(package = "contextual", origin = "priority")$CX_BULLET_INDENT
  total_indentation <- base_indentation + bullet_indentation
  
  # Format items
  for (i in seq_along(items)) {
    name <- names(items)[i]
    value <- items[i]
    
    if (is.null(name) || name == "" || is.na(name)) {
      content <- as.character(value)
    } else {
      content <- paste0(name, ": ", value)
    }
    
    # Generate appropriate bullet for this item
    if (is_numbering) {
      current_bullet <- generate_numbered_bullet(bullet, i)
    } else {
      current_bullet <- bullet_symbol
    }
    
    # Apply total indentation manually
    indent_spaces <- paste(rep(" ", total_indentation), collapse = "")
    cat(indent_spaces, current_bullet, " ", content, "\n", sep = "")
  }
}
