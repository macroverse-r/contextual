#' Show formatted alert message
#'
#' @param message Alert message text
#' @param ... Additional arguments passed to cli functions
#' @param verbose Whether to show the alert (TRUE) or suppress it (FALSE)
#' @param bullet Type of bullet to use ("warn", "fire", "x")
#' @param .envir Environment for glue evaluation
#'
#' @export
cx_alert <- function(message, ..., verbose = TRUE, bullet = "warn", .envir = parent.frame()) {
  if (isTRUE(verbose)) {
    # Validate bullet type
    valid_bullets <- c("warn", "fire", "x")
    if (!bullet %in% valid_bullets) {
      cli::cli_inform(paste0("Invalid bullet type '", bullet, "', using 'warn' instead"))
      bullet <- "warn"
    }
    
    # Define custom bullets with better formatting
    bullet_symbols <- list(
      warn = "\u26A0\uFE0F\u00A0\u00A0",
      fire = "\uD83D\uDD25\u00A0\u00A0"
    )
    
    # Format message with bullet
    if (bullet == "x") {
      # Use cli's built-in "x" bullet for red styling
      bullet_message <- structure(message, names = "x")
      cli::cli_inform(bullet_message, ..., .envir = .envir)
    } else {
      # Handle "warn" and "fire" bullets with yellow text
      formatted_message <- paste0(bullet_symbols[[bullet]], cli::col_br_yellow(message))
      cli::cli_inform(formatted_message, ..., .envir = .envir)
    }
  }
}