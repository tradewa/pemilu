pkgs <- c(
  "tidyverse",   # dplyr, ggplot2, readr, stringr, tibble, etc.
  "scales",      # percent_format() and other scale helpers
  "knitr",       # kable() tables and chunk options
  "jsonlite",    # fromJSON() for JSON data fallback
  "ggdist",      # posterior distribution plots (optional but recommended)
  "rmarkdown",   # Quarto/knitr rendering backend
  "quarto"       # quarto R package for rendering
)
install.packages(pkgs)
renv::snapshot()
