#!/usr/bin/env sh
# Smoke test: one command from the Rust orchestrator runs a tiny federation,
# writes result.pb + metrics.parquet, and R renders a test plot.
set -eu
cd "$(dirname "$0")/.."

[ -f .env ] || cp .env.example .env
set -a; . ./.env; set +a

cargo run --release --manifest-path orchestrator/Cargo.toml -- run --sweep orchestrator/sweeps/smoke.toml
Rscript analysis/run_analysis.R
echo "smoke test OK"
