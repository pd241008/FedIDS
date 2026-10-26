#!/usr/bin/env Rscript
# Run from the repo root: Rscript analysis/run_analysis.R
source("analysis/R/01_load.R")
source("analysis/R/02_stats.R")
source("analysis/R/03_plots.R")

runs    <- load_runs()
summary <- summarise_propagation(runs)

dir.create("analysis/output", showWarnings = FALSE, recursive = TRUE)
ggsave("analysis/output/propagation.pdf", plot_propagation(summary), width = 3.3, height = 2.4)
message("wrote analysis/output/propagation.pdf")
