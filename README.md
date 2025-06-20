# contextual

Context-aware messaging and hierarchical document structuring for R.

## Installation

```r
# Install from local directory
devtools::install("~/MEGA/repo/macroverse/contextual")
```

## Features

- **Hierarchical Titles**: Automatic numbering (1, 1.1, 1.1.1) with smart depth detection
- **Formatted Messages**: Consistent error, warning, alert, and success messages
- **Context-Aware Text**: Automatic indentation based on section depth
- **Smart Reset Detection**: Handles script re-execution and console calls

## Usage

```r
library(contextual)

# Create hierarchical document structure
mv_title("Data Analysis")              # 1. DATA ANALYSIS
mv_title("Load Data", level_adjust=1)  # 1.1. Load Data
mv_text("Loading datasets...")         #     Loading datasets...

# Formatted messages
mv_success("Data loaded successfully")
mv_warn("Missing values detected")
mv_alert("Processing large dataset")

# Heading functions
mv_h1("Results")                       # 2. RESULTS
mv_h2("Summary Statistics")            # 2.1. Summary Statistics
mv_h3("Descriptive Stats")             # 2.1.1. Descriptive Stats
mv_h4("Details")                       # → Details
```

## Configuration

```r
# Control debug output
.contextual_env$debug <- FALSE

# Control auto-numbering
.contextual_env$auto_number <- "all"    # all functions auto-number
.contextual_env$auto_number <- "title"  # only mv_title auto-numbers
.contextual_env$auto_number <- "none"   # no auto-numbering
```

## License

Dual-licensed under AGPL-3.0 (open source) and commercial license.
Part of the macroverse R ecosystem.