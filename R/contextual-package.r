#' contextual: Context-Aware Messaging and Hierarchical Document Structuring
#'
#' The contextual package provides a comprehensive system for creating
#' hierarchically structured documents with automatic numbering and
#' context-aware formatting in R.
#'
#' @section Main Functions:
#' \describe{
#'   \item{\code{\link{cx_title}}}{Smart hierarchical titles with automatic depth detection}
#'   \item{\code{\link{cx_h1}}, \code{\link{cx_h2}}, \code{\link{cx_h3}}, \code{\link{cx_h4}}}{Level-specific headings}
#'   \item{\code{\link{cx_text}}}{Context-aware indented text}
#'   \item{\code{\link{cx_stop}}, \code{\link{cx_warn}}, \code{\link{cx_alert}}, \code{\link{cx_success}}}{Formatted messaging}
#'   \item{\code{\link{cx_debug}}}{Debug messages with optional display}
#'   \item{\code{\link{cx_reset_numbering}}}{Manual reset control}
#' }
#'
#' @section Configuration:
#' The package behavior can be configured through the \code{.contextual_env} environment:
#' \describe{
#'   \item{\code{.contextual_env$debug}}{Control debug message display (TRUE/FALSE)}
#'   \item{\code{.contextual_env$auto_number}}{Control auto-numbering ("all", "title", "none")}
#'   \item{\code{.contextual_env$indentation_size}}{Base indentation size for cx_text (default: 3)}
#' }
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL