# install.R

# List of required packages
packages <- c(
  "ggplot2",
  "dplyr",
  "forcats",
  "hrbrthemes",
  "viridis",
  "zoo",
  "corrplot",
  "maps"
)

# Identify which packages are not yet installed
installed <- rownames(installed.packages())
to_install <- setdiff(packages, installed)

# Install missing packages
if (length(to_install) > 0) {
  install.packages(to_install, repos = "https://cloud.r-project.org/")
}

# Optional message
cat("All packages are now installed.\n")