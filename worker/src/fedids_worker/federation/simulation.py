"""Federation simulation entry point.

PLACEHOLDER: produces synthetic per-round metrics so the full pipeline
(Rust -> Python -> Parquet -> R) can be smoke-tested before any real
training exists. Replace with the Flower simulation.
"""

from __future__ import annotations

import numpy as np

from fedids_worker.contracts import config_pb2


def run_federation(cfg: "config_pb2.RunConfig") -> list[dict]:
    rng = np.random.default_rng(cfg.seed)
    fed, zd = cfg.federation, cfg.zero_day
    rows: list[dict] = []
    for rnd in range(fed.rounds):
        for site in range(fed.num_sites):
            if rnd < zd.injection_round:
                recall = 0.0
            else:
                # Synthetic: the origin site learns instantly, others catch up.
                lag = 0 if site == zd.origin_site else 1 + (site % 3)
                steps = max(0, rnd - zd.injection_round - lag + 1)
                recall = float(min(1.0, steps / max(1, fed.rounds // 2)))
                recall = min(1.0, max(0.0, recall + rng.normal(0, 0.01)))
            rows.append(
                {
                    "run_id": cfg.run_id,
                    "round": rnd,
                    "site": site,
                    "metric": "zero_day_recall",
                    "value": recall,
                }
            )
    return rows
