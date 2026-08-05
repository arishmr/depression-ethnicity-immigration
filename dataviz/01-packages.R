# Define vector of package names
packages <- c(
  "dplyr", "tidyverse", "stringr", "forcats", # data wrangling
  "psych", # statistical analysis
  "ggplot2", "RColorBrewer", "patchwork" # visualisation
)

# Load packages
for (package in packages) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  } else {
    library(package, character.only = TRUE)
  }
}

rm(packages, package)
