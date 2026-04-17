# DSE4231 Project: How Does Marijuana Legislation Affect Crime?

## Project Overview

This project studies the causal impact of marijuana legalization on crime, based on the paper:

> *Chollete et al. (2026), “How Does Marijuana Legislation Affect Crime? Medical and Recreational Laws Across 50 States”*

The objective is to critically evaluate the identification strategy and estimation methods used in the paper, and to assess their performance through empirical implementation.

In particular, we replicate and extend the paper’s methodology using synthetic control-based approaches.

---

## Research Question

> How does marijuana legalization (medical vs recreational) affect crime rates across U.S. states, and how sensitive are these results to the choice of causal inference method?

---

## Methodology

### Original Paper Approach

The paper uses:

- Difference-in-Differences (DiD)
- Dynamic event study
- Synthetic Difference-in-Differences (SDID)

These methods aim to address:

- Unobserved heterogeneity (via fixed effects)
- Staggered treatment adoption
- Time-varying confounding

---

### Our Implementation

We extend the study using synthetic control methods and compare three approaches:

#### 1. Pooled Synthetic Control (`pooledsc.R`)

- Aggregates treated states into a single unit
- Estimates an overall average treatment effect
- May impose strong homogeneity assumptions

#### 2. Separate Synthetic Control (`separate.R`)

- Constructs unit-specific counterfactuals
- Captures heterogeneity across states
- More flexible but less stable

#### 3. Hybrid Synthetic Control (`hybrid.R`)

- Uses `multisynth()` from `augsynth`
- Combines pooled and separate approaches
- Learns optimal weighting parameter (ν)

---

## Identification Strategy

The key identification idea is to construct a credible counterfactual for treated states using weighted combinations of untreated (or not-yet-treated) states.

Key assumptions:

- Parallel trends (relaxed) via synthetic control matching
- No interference across units (SUTVA)
- Good pre-treatment fit implies valid counterfactual

We also address:

- Staggered adoption bias
- Limited post-treatment support
- Model sensitivity

---

## Data

- Panel dataset of 50 U.S. states (1995–2019)
- Crime data from FBI Uniform Crime Reports
- Treatment variables:
  - `D_MED`: Medical legalization
  - `D_REC`: Recreational legalization

### Outcomes

- Property crime
- Violent crime
- Subcategories (burglary, larceny, robbery, assault, etc.)

### Covariates

- Income, unemployment, poverty
- Population density
- Political variables

---

## Project Structure
```r
├── Empirical/ # Dataset and original methodology files along with our replication. Contains original paper's README. 
├── pooledsc.R # Pooled synthetic control implementation
├── separate.R # Separate synthetic control implementation
├── hybrid.R # Hybrid (multisynth) implementation
├── nice_plots/ # Figures used in final report
├── results_rec/ # Recreational results (pooled)
├── results_rec_separate/ # Recreational results (separate)
├── results_rec_hybrid/ # Recreational results (hybrid)
├── results_med/ # Medical results (pooled)
├── results_med_separate/ # Medical results (separate)
├── results_med_hybrid/ # Medical results (hybrid)
├── original_paper.pdf # Paper being studied
├── report.pdf # Final project report
└── README.md
```


---

## How to Run

```r
source("pooledsc.R")
source("separate.R")
source("hybrid.R")
```


## Group Members

- Jeron Tan Kang  
- Tammy Alexandra Wong  
- Low Jun Chen Jason  
- N Ashwin Kumar  

---

DSE4231 (Topics in Data Science and Digital Economy)  
National University of Singapore
