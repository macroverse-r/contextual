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
#' @export
cx_bullets <- function(items, bullet = NULL, .envir = parent.frame()) {
  if (length(items) == 0) return(invisible())
  
  # Greek letters for α. numbering
  greek_letters <- c("α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", 
                     "ν", "ξ", "ο", "π", "ρ", "σ", "τ", "υ", "φ", "χ", "ψ", "ω")
  
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
      "α." = {
        if (index > 24) paste0(index, ".") else paste0(greek_letters[index], ".")
      },
      "α:" = {
        if (index > 24) paste0(index, ":") else paste0(greek_letters[index], ":")
      },
      "(α)" = {
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
      "•"  # fallback
    )
  }
  
  # Get bullet type from config if not specified
  if (is.null(bullet)) {
    bullet <- icy::get_value("CX_BULLET_TYPE")
  }
  
  # Handle slash notation (e.g., "α./grec." -> use first option)
  if (grepl("/", bullet)) {
    bullet <- strsplit(bullet, "/")[[1]][1]
  }
  
  # Check if this is a numbering type or symbol type
  numbering_types <- c("1.", "1:", "(1)", "a.", "a:", "(a)", "A.", "A:", "(A)", 
                       "i.", "i:", "(i)", "I.", "I:", "(I)", "α.", "α:", "(α)",
                       "grec.", "grec:", "(grec)")
  is_numbering <- bullet %in% numbering_types
  
  if (!is_numbering) {
    # Traditional symbol bullets
    bullet_map <- list(
      "dot" = "•",
      "arrow" = "→", 
      "dash" = "-",
      "star" = "★",
      "check" = "✓",
      "none" = ""
    )
    bullet_symbol <- bullet_map[[bullet]] %||% "•"  # fallback to dot
  }
  
  # Calculate base indentation from section depth
  indent_depth <- .get_current_section_depth() - icy::get_value("CX_INDENT_LV_START")
  base_indentation <- max(0, min(indent_depth * icy::get_value("CX_INDENT_WIDTH"), 12))
  
  # Add bullet-specific indentation
  bullet_indentation <- icy::get_value("CX_BULLET_INDENT")
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
