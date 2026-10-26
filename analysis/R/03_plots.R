# Plots. Axis labels use words, with units in parentheses (venue style).
suppressPackageStartupMessages(library(ggplot2))

plot_propagation <- function(summary_df) {
  ggplot(summary_df, aes(x = round, y = mean)) +
    geom_ribbon(aes(ymin = lower, ymax = upper), alpha = 0.2, na.rm = TRUE) +
    geom_line() +
    labs(
      x = "Training round",
      y = "Recall on zero-day attack at non-origin sites"
    ) +
    theme_bw(base_size = 8)   # 8 point figure labels
}
