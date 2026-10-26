# Summaries across seeds: mean and 95% confidence interval per round.
suppressPackageStartupMessages(library(dplyr))

summarise_propagation <- function(runs) {
  runs |>
    filter(metric == "zero_day_recall", site != origin_site) |>
    group_by(num_sites, skew, defense_kind, round, run_id) |>
    summarise(recall = mean(value), .groups = "drop_last") |>   # average over non-origin sites
    summarise(
      n    = n(),
      mean = mean(recall),
      se   = sd(recall) / sqrt(n()),
      .groups = "drop"
    ) |>
    mutate(
      lower = mean - qt(0.975, pmax(n - 1, 1)) * se,
      upper = mean + qt(0.975, pmax(n - 1, 1)) * se
    )
}
