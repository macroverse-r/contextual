#' Display a level 1 heading with automatic numbering
#'
#' @description
#' Shows a formatted level 1 heading in bright magenta color with automatic section numbering.
#' Participates in the hierarchical numbering system.
#'
#' @param title Character string. The heading text to display.
#' @param auto_number Logical. Whether to automatically number this heading (default: TRUE).
#' @param reset Logical. If TRUE, reset numbering before displaying this title (default: FALSE).
#' @param .envir Environment. Environment for string interpolation in cli functions.
#'   Default is parent.frame().
#'
#' @export
cx_h1 <- function(title, auto_number = TRUE, reset = FALSE, .envir = parent.frame()) {
  # Combine individual parameter with global setting
  effective_auto_number <- auto_number && .should_auto_number("cx_h")
  
  if (effective_auto_number) {
    .cx_heading_numbered(title, level = 1, reset = reset, .envir = .envir)
  } else {
    .format_heading(title, level = 1, .envir = .envir)
  }
}

#' Display a level 2 heading with automatic numbering
#'
#' @description
#' Shows a formatted level 2 heading in regular magenta color with automatic section numbering.
#' Participates in the hierarchical numbering system.
#'
#' @param title Character string. The heading text to display.
#' @param auto_number Logical. Whether to automatically number this heading (default: TRUE).
#' @param reset Logical. If TRUE, reset numbering before displaying this title (default: FALSE).
#' @param .envir Environment. Environment for string interpolation in cli functions.
#'   Default is parent.frame().
#'
#' @export
cx_h2 <- function(title, auto_number = TRUE, reset = FALSE, .envir = parent.frame()) {
  # Combine individual parameter with global setting
  effective_auto_number <- auto_number && .should_auto_number("cx_h")
  
  if (effective_auto_number) {
    .cx_heading_numbered(title, level = 2, reset = reset, .envir = .envir)
  } else {
    .format_heading(title, level = 2, .envir = .envir)
  }
}

#' Display a level 3 heading with automatic numbering
#'
#' @description
#' Shows a formatted level 3 heading with color and automatic section numbering.
#' Participates in the hierarchical numbering system.
#'
#' @param title Character string. The heading text to display.
#' @param auto_number Logical. Whether to automatically number this heading (default: TRUE).
#' @param reset Logical. If TRUE, reset numbering before displaying this title (default: FALSE).
#' @param .envir Environment. Environment for string interpolation in cli functions.
#'   Default is parent.frame().
#'
#' @export
cx_h3 <- function(title, auto_number = TRUE, reset = FALSE, .envir = parent.frame()) {
  # Combine individual parameter with global setting
  effective_auto_number <- auto_number && .should_auto_number("cx_h")
  
  if (effective_auto_number) {
    .cx_heading_numbered(title, level = 3, reset = reset, .envir = .envir)
  } else {
    .format_heading(title, level = 3, .envir = .envir)
  }
}

#' Display a level 4 heading
#'
#' @description
#' Shows a formatted level 4 heading using cli_inform with ">" bullet.
#' Provides a simple, clean subsection marker.
#'
#' @param title Character string. The heading text to display.
#' @param .envir Environment. Environment for string interpolation in cli functions.
#'   Default is parent.frame().
#'
#' @export
cx_h4 <- function(title, .envir = parent.frame()) {
  .format_heading(title, level = 4, .envir = .envir)
}