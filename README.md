# Pilpres 2024 — Bayesian Polling from TPS Data

*notes: readme written by AI and checked by owner*

A statistical analysis that simulates how a polling agency could estimate the 2024 Indonesian Presidential Election result using a small sample of polling stations (TPS), Bayesian inference, and DPT-weighted aggregation.

## Overview

Using the complete KPU dataset of ~823,000 TPS across 38 provinces, this project:

1. Allocates TPS visits across provinces using a cluster-based (tiered) strategy
2. Draws a stratified random sample (~0.23% of all TPS)
3. Fits a Bayesian Beta-Binomial model per province for each candidate
4. Aggregates provincial posteriors into a national estimate using DPT voter weights
5. Compares the weighted estimate against the true election result

The analysis shows that even with a tiny sample, DPT-weighted Bayesian aggregation recovers a national estimate very close to the actual outcome.

## Results

| Candidate | Paslon | True Result | Weighted Estimate |
|---|---|---|---|
| Anies Baswedan | 01 | 24.95% | ~24–25% |
| Prabowo Subianto | 02 | 58.59% | ~58–59% |
| Ganjar Pranowo | 03 | 16.47% | ~16–17% |

## Project Structure

```
.
├── analysis.qmd          # Main Quarto notebook — all analysis lives here
├── analysis.html         # Rendered output (self-contained)
├── data/
│   └── tps_raw.csv       # KPU TPS data (823k rows, ~328 MB — not in git)
├── setup/
│   ├── setup_renv.R      # Run once to initialise the renv environment
│   └── packages.R        # Package installation + renv::snapshot()
├── renv/                 # renv environment (reproducible package versions)
└── renv.lock             # Locked package versions
```

## Requirements

- R (>= 4.3)
- [Quarto](https://quarto.org/)
- R packages (managed via `renv`): `tidyverse`, `scales`, `knitr`, `jsonlite`, `ggdist`

## Setup

**1. Clone the repo**

```bash
git clone <repo-url>
cd pemilu
```

**2. Download the data**

Download the KPU TPS release CSV and save it as `data/tps_raw.csv`:

```
https://github.com/khrlimam/pemilu2024-suara-tps/releases/download/2024-04-18/2024-04-18.09-15.csv
```

**3. Restore the R environment**

```r
Rscript setup/setup_renv.R
```

**4. Render the notebook**

```bash
quarto render analysis.qmd
```

This produces `analysis.html` — a self-contained, shareable report.

## Methodology

### Sampling

Provinces are sorted into 4 tiers by registered voter share (DPT). Each tier receives a fixed TPS allocation per province:

| Tier | Provinces | TPS per province |
|---|---|---|
| 1 (smallest) | Bottom 25% | 10 |
| 2 | 25–50% | 30 |
| 3 | 50–75% | 60 |
| 4 (largest) | Top 25% | 100 |

Within each tier, every province receives the same number of TPS visits regardless of population differences. This intentional over-representation of smaller provinces is corrected at aggregation via DPT weighting.

### Bayesian Model

A Beta-Binomial model is fit independently for each candidate in each province:

- **Prior**: Beta(1, 1) — flat/uninformative
- **Posterior**: Beta(1 + k, 1 + n − k)

where `k` is the candidate's votes in the sampled TPS and `n` is the total sampled votes.

### National Aggregation

Provincial posterior means are aggregated to a national estimate using each province's DPT weight:

```
national_estimate = Σ (province_posterior_mean × province_DPT_share)
```

A naive (unweighted) average is also shown as a biased baseline.

## Key Findings

- **DPT weighting matters**: the naive average meaningfully over-weights small provinces; the weighted estimate tracks the true result closely
- **Provincial errors are diluted**: a large error in a small province has negligible national impact (bounded by its DPT share)
- **Sample size vs. accuracy**: increasing Jakarta's TPS sample from 60 → 600 → 6000 visibly narrows the posterior and pulls the estimate toward the true value

## Data Source

Raw data: [khrlimam/pemilu2024-suara-tps](https://github.com/khrlimam/pemilu2024-suara-tps)

Official results: [KPU — Komisi Pemilihan Umum](https://pemilu2024.kpu.go.id/)
