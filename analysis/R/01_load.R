# Load worker outputs. R reads Parquet only (no protobuf dependency).
suppressPackageStartupMessages({
  library(arrow)
  library(dplyr)
})

load_runs <- function(runs_dir = Sys.getenv("RUNS_DIR", "runs")) {
  metric_files <- Sys.glob(file.path(runs_dir, "*", "metrics.parquet"))
  meta_files   <- Sys.glob(file.path(runs_dir, "*", "meta.parquet"))
  stopifnot("No runs found. Run the orchestrator first." = length(metric_files) > 0)

  metrics <- bind_rows(lapply(metric_files, read_parquet))
  meta    <- bind_rows(lapply(meta_files, read_parquet))
  inner_join(metrics, meta, by = "run_id")
}
