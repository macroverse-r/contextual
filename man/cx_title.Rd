% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cx_title.r
\name{cx_title}
\alias{cx_title}
\title{Smart title function with automatic numbering}
\usage{
cx_title(
  title,
  level_adjust = 0,
  reset = FALSE,
  auto_number = TRUE,
  .envir = parent.frame()
)
}
\arguments{
\item{title}{Character string. The heading text to display.}

\item{level_adjust}{Integer. Number of levels to add to the calculated depth (default: 0).}

\item{reset}{Logical. If TRUE, reset numbering before displaying this title (default: FALSE).}

\item{auto_number}{Logical. Whether to automatically number this heading (default: TRUE).}

\item{.envir}{Environment. Environment for string interpolation.}
}
\description{
Smart title function with automatic numbering
}
