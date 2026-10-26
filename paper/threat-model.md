# Threat Model

> Stage 1 output. Every Stage 4–7 experiment must name **one adversary (A1/A2) and
> one goal (G1/G2/G3)** from this file, or the experiment is out of scope.

## Parties

| Party | Description | Trust |
| :--- | :--- | :--- |
| **Sites S₁…S_N** (N small, 3–50; main matrix = 5/10/20/50) | Organizations (e.g. enterprises, MSSPs, universities) each holding local flow data, non-IID by attack family | Correct protocol participants; do not collude with adversaries |
| **Aggregation server** | Runs FedAvg/FedProx/FedAdam, publishes the global model per round | Honest (does not deviate from the protocol), but may harbor **A1** |
| **Peer clients** | Other sites; observe only published global model versions | Curious; individual site may be **A2** |
| (Optional) **External observer** | Audit logs public per round; goal coordination; UNDEFENDED downgraded (not an adversary in our experiments) | Unauthenticated third party |

## Adversaries (defined separately)

### A1 — Honest-but-curious server
- **Sees:** per-client parameter updates each round (or only their secure sum
  when SecAgg is simulated); dataset identity/participation per round; round
  schedule; model architecture.
- **Cannot:** read raw flows, modify the protocol, send adversary to clients.
- **Goal:** G1, G2, G3 (severity: strongest view).

### A2 — Curious peer client
- **Sees:** consecutive global model versions only (their own published diffs);
  number of clients; round schedule.
- **Cannot:** observe other clients' individual updates; force its own exclusion;
  authentication foreknowledge of client sampling beyond the announced schedule.
- **Goal:** G1 (primary), G2; G3 is degraded to coarse features.

## Adversary capabilities / knowledge

- Auxiliary data: public IDS-natured replica with a plausible distribution of
  flows; can train **shadow federations** (own Flower runs) with chosen
  origin-site/timing labels; does not need the target sites' exact distributions.
- Architecture knowledge: aware of MLP/1D-CNN option and the optimizer used.
- Protocol knowledge: knows N, skew parameter range, zero-day family menu, but
  **not** which family/origin/timing the target run chose (out-of-sample test).
- Compute bounded: fixed attack-model budget (documented in the comparator output).

## Adversary goals

| ID | Goal | Severity / output |
| :- | :--- | :--- |
| **G1** | Attribute the origin site: which of the N sites was first to see the zero-day | accuracy / top-k over 1/N; relative to random and largest-δ‖δ‖ heuristic |
| **G2** | Timing: infer the injection round t | absolute & CI-quantile round error (MAE / CDF) |
| **G3** | Property: coarse traffic profile of the unseen attack family (presence in an update, coarse class) | AUC (binary "event seen" style detectors) |

## Out of scope (explicit, with rationale)

- **Active/poisoning adversaries, malicious clients, collusion** (server+peer),
  Byzantine update construction: orthogonal; a *misbehaving participant can
  always self-report*, and Stage 6's thresholded k-of-N release already touches
  the anti-collusion decision boundary. Cited in Limitations, not defended against.
- **Model inversion / data reconstruction** (DLG-style): different level of
  leakage; ours is event/source-level — and reconstruction is weaker signal in
  tabular IDS flows.
- **End-user record-level privacy (GDPR-style)**: covered by C-record level client
  DP defenses; our contribution above is organization-level attribution.
- **Real coordination channel privacy** (SecAgg protocol internals): we *simulate*
  SecAgg (sum-only visibility); labeled as such in the artifact, flagged in
  Limitations.

## Why this setting is realistic (deployment paragraph draft)

A small group of organizations — a sectoral ISAC or cloud+telco consortium —
runs cross-silo FL to share detector quality without shipping traffic. Cross-silo
realities: N is small (a sites digit, not thousands), each site trains on its own
attack mix (heavy class-level non-IID), labels arrive late for previously-unseen
families, and the party you don't want to reveal is "we got hit with something
new, at time t" — precisely the event whose propagation your consortium *wants
spread fast* and whose attribution origin *motivates every G1–G3 adversary above*.
Organizations already share indicators voluntarily; this paper does not ask them
to trust more, it measures what the current mechanism discloses anyway.

## Threat-model figure (paper draft: Fig. 1, mermaid placeholder; final version → TikZ/vector)

```mermaid
flowchart LR
  subgraph cons["Cross-silo federation, N sites"]
    S1(S₁: benign A-heavy)
    S2(S₂: zero-day @ round t)
    S3(S₃)
    SN(S₂…S_N)
  end
  S1 & S2 & SN -- "Δw_i (individual)" --> SV((Aggregation server))
  SV -- "w_global" --> peer(Peer S₂ = A2)
  S2 -.-|"origin, time t"| adv1(A1: server<br/>G1 origin, G2 timing, G3 property)
  peer -.-|"model diffs only"| adv2(A2: peer<br/>G1 origin (primary))
  SV -.- SecAgg["SecAgg ON ⇒ only ΣΔw_i visible"]
  style S2 fill:#e74c3c,color:#fff
```

Adversary/goal experiment binding (Stage 4–7 matrix anchor):

| Experiment | Adversary | Goal |
| :--- | --- | --- |
| E1 propagation (Stage 4) | — (no adversary) | characterizes the *value* side G1→ owners want |
| E2 leakage primary (Stage 5) | A1 | G1, G2, G3 |
| E2 leakage peer (Stage 5) | A2 | G1 (+G2) |
| E2 under SecAgg (Stage 5) | A1 (reduced) | G1, G2 residual |
| E3 defenses (Stage 6) | A1 + A2 | G1–G3 cost curve |

## Done-when check gate

- [x] Each later experiment binds to exactly one adversary + goal (table above).
- [x] Out-of-scope list explicit with rationale.
- [x] Realism paragraph exists (draft above).
- [ ] Reviewer pass once Section 3 LaTeX appears in Stage 8.
