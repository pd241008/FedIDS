"""Partition a dataset across sites by attack family and hold out a zero-day.

TODO: implement on the chosen dataset (non-IID split controlled by `skew`;
withhold `zero_day.family` and introduce it at `origin_site` in
`injection_round`).
"""

from __future__ import annotations


def partition_by_family(dataset_name: str, num_sites: int, skew: float, seed: int):
    raise NotImplementedError("Implement dataset partitioning (see docs/adrs).")
