# FedIDS

Federated intrusion detection: how fast does a zero-day attack propagate through
a federation, and what does that propagation reveal about the site that saw it first?

Target paper: *Who Saw It First? Zero-Day Propagation and Attribution Leakage in
Federated Intrusion Detection* (see `paper/`).

> Conventions follow the Design Dungeons playbook: root-level decoupling, one
> artifact per root directory, reproducible setup from `.env.example`, fail-fast
> configuration, ADRs for decisions.

## Layout

| Directory | Language | Role |
|---|---|---|
| `proto/` | proto3 | Contracts between components (single source of truth) |
| `orchestrator/` | Rust | Sweeps, run supervision, result collection |
| `worker/` | Python | Data processing, federation, attacks, defenses |
| `analysis/` | R | Statistics, plots, paper tables (reads Parquet only) |
| `datasets/` | n/a | `raw/` immutable source data, `processed/` derived (gitignored) |
| `runs/` | n/a | One directory per run (gitignored) |
| `paper/` | LaTeX | Euro S&P 2027 template |
| `docs/` | Markdown | `adrs/`, `postmortems/` |
| `scripts/` | sh | `smoke.sh` end-to-end check |

## Data flow

```
sweep.toml -> [Rust orchestrator] -- config.pb --> [Python worker]
                                                      |-- result.pb
                                                      |-- metrics.parquet, meta.parquet
                                                      v
                                              [R analysis] -> analysis/output/*.pdf
```

## Quick start

```sh
cp .env.example .env            # fill local values
make proto                      # generate Python bindings (needs grpcio-tools)
make test                       # worker unit + smoke tests
make smoke                      # orchestrator -> worker -> R plot, end to end
```

## Reproducibility

Pin everything: `Cargo.lock`, a locked Python environment, `renv.lock`, and the
Docker image. Every `RunResult` records the git commit and image digest.

## Status

Skeleton. Federation, attacks, and defenses are stubs; `federation/simulation.py`
emits synthetic metrics so the pipeline can be checked before real training exists.

See [CHANGELOG.md](CHANGELOG.md).
