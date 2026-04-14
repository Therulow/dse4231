# ============================================================
# SEPARATE SYNTHETIC CONTROL 
# ============================================================

# load packages
library(haven)
library(dplyr)
library(tidyr)
library(Synth)
library(ggplot2)
library(ggrepel)
library(purrr)
library(panelView)
library(readr)
#install.packages(devtools)
#devtools::install_github("ebenmichael/augsynth")
library(augsynth)
# ============================================================

# load data
df = read_dta('Empirical/crime_potsv4.dta')

# check colnames
colnames(df)

# set up
covariates = c("GOV_DEM", 
               "STATE_DEM", 
               "POV_RATE", 
               "UNRATE", 
               "POP_DENSITY", 
               "lnREALINC")

crime_outcomes <- c(
  "lnPROPERTY",
  "lnVIOLENT1",
  "lnBURGLARY",
  "lnLARCENY",
  "lnAUTO",
  "lnMURDER",
  "lnRAPE",
  "lnROBBERY",
  "lnASSAULT"
)


##########################################
# Separate SC for recreational marijuna

# Main results folder
if (!dir.exists("results_rec_separate")) {
  dir.create("results_rec_separate", recursive = TRUE)
}

# Plots folder
if (!dir.exists("results_rec_separate/plots")) {
  dir.create("results_rec_separate/plots", recursive = TRUE)
}

# check block structure
png("results_rec_separate/plots/panelview_rec.png", width = 1200, height = 800)

panelview(
  lnPROPERTY ~ D_REC,
  data = df,
  index = c("STATE", "YEAR"),
  pre.post = TRUE
)
dev.off()


# check for support
# 1. First treatment year
df2 <- df %>%
  group_by(STATE) %>%
  mutate(first_treat = ifelse(any(D_REC == 1), min(YEAR[D_REC == 1]), NA)) %>%
  ungroup()

# 2. Total treated states
n_treated <- df2 %>%
  distinct(STATE, first_treat) %>%
  filter(!is.na(first_treat)) %>%
  nrow()

# 3. Support table
support_rec <- df2 %>%
  filter(!is.na(first_treat)) %>%
  mutate(event_time = YEAR - first_treat) %>%
  filter(event_time >= 0) %>%
  group_by(event_time) %>%
  summarise(
    treated_units = n_distinct(STATE),
    .groups = "drop"
  ) %>%
  mutate(
    share_treated = treated_units / n_treated,
    robust_5units = treated_units >= 5,
    robust_25pct  = share_treated >= 0.25
  )

support_rec

#############################################################
treat_dummy <- "D_REC"

df3 <- df %>%
  group_by(STATE) %>%
  mutate(first_treat = if (any(D_REC == 1)) min(YEAR[D_REC == 1]) else NA_integer_) %>%
  ungroup()

max_horizon <- 2 # number of post treatment 
last_year <- max(df3$YEAR, na.rm = TRUE)

df_trim_rec <- df3 %>%
  filter(is.na(first_treat) | first_treat <= last_year - max_horizon)


model_summary   <- list()
all_att_results <- list()
failed_models   <- list()


# -----------------------------
# Loop over crime types
# -----------------------------
for (outcome_var in crime_outcomes) {
  cat("\n=============================\n")
  cat("Running:", outcome_var, "\n")
  cat("=============================\n")
  
  
  # outcome ~ treatment | weighting covariates
  fmla <- as.formula(
    paste(
      outcome_var,
      "~", treat_dummy,
      "|", paste(covariates, collapse = " + ")
    )
  )
  
  fit <- tryCatch(
    multisynth(
      form = fmla,
      unit = STATE,
      time = YEAR,
      data = df_trim_rec, 
      nu = 0 # separate
    ),
    error = function(e) e
  )
  
  
  # Handle failure
  if (inherits(fit, "error")) {
    cat("Failed:", outcome_var, "\n")
    failed_models[[outcome_var]] <- fit$message
    next
  }
  
  # -----------------------------
  # Summary
  # -----------------------------
  summ <- tryCatch(summary(fit), error = function(e) NULL)
  model_summary[[outcome_var]] <- summ
  
  summary_text <- if (!is.null(summ)) {
    capture.output(print(summ))
  } else {
    "Summary failed."
  }
  
  writeLines(
    summary_text,
    paste0("results_rec_separate/", outcome_var, "_summary.txt")
  )
  
  # -----------------------------
  # Extract ATT table
  # -----------------------------
  att_tbl <- NULL
  
  if (!is.null(summ) && !is.null(summ$att)) {
    att_tbl <- as.data.frame(summ$att)
  } else if (!is.null(fit$att)) {
    if (is.vector(fit$att)) {
      att_tbl <- data.frame(
        event_time = names(fit$att),
        Estimate   = as.numeric(fit$att),
        stringsAsFactors = FALSE
      )
    } else {
      att_tbl <- as.data.frame(fit$att)
    }
  } else if (!is.null(fit$inf)) {
    att_tbl <- as.data.frame(fit$inf)
  }
  
  if (!is.null(att_tbl)) {
    att_tbl$Outcome   <- outcome_var
    att_tbl$Treatment <- treat_dummy
    
    all_att_results[[outcome_var]] <- att_tbl
    
    write.csv(
      att_tbl,
      paste0("results_rec_separate/", outcome_var, "_att.csv"),
      row.names = FALSE
    )
  }
  
  # -----------------------------
  # Save plot
  # -----------------------------
  plot_file <- file.path("results_rec_separate", "plots", paste0(outcome_var, "_multisynth_avg.png"))
  dir.create(dirname(plot_file), recursive = TRUE, showWarnings = FALSE)
  
  p <- tryCatch(
    plot(fit),
    error = function(e) e
  )
  
  if (inherits(p, "error")) {
    cat("Plot creation failed for", outcome_var, ":", p$message, "\n")
  } else if (inherits(p, "ggplot")) {
    ggsave(
      filename = plot_file,
      plot = p,
      width = 8,
      height = 5,
      dpi = 300
    )
    cat("Saved:", file.exists(plot_file), plot_file, "\n")
  } else {
    cat("plot() did not return a ggplot object for", outcome_var, "\n")
  }
}

# -----------------------------
# Combine ATT results
# -----------------------------
if (length(all_att_results) > 0) {
  combined_att <- bind_rows(all_att_results)
  
  write.csv(
    combined_att,
    "results_rec_separate/all_att_results.csv",
    row.names = FALSE
  )
}

# -----------------------------
# Save failed models
# -----------------------------
if (length(failed_models) > 0) {
  failed_df <- data.frame(
    Outcome = names(failed_models),
    Error   = unlist(failed_models),
    row.names = NULL
  )
  
  write.csv(
    failed_df,
    "results_rec_separate/failed_models.csv",
    row.names = FALSE
  )
}



##########################################
# Separate SC for medical marijuna

# Main results folder
if (!dir.exists("results_med_separate")) {
  dir.create("results_med_separate", recursive = TRUE)
}

# Plots folder
if (!dir.exists("results_med_separate/plots")) {
  dir.create("results_med_separate/plots", recursive = TRUE)
}

# check block structure
png("results_med_separate/plots/panelview_med.png", width = 1200, height = 800)

panelview(
  lnPROPERTY ~ D_MED,
  data = df,
  index = c("STATE", "YEAR"),
  pre.post = TRUE
)
dev.off()


# check for support
# 1. First treatment year
df3 <- df %>%
  group_by(STATE) %>%
  mutate(first_treat = ifelse(any(D_MED == 1), min(YEAR[D_MED == 1]), NA)) %>%
  ungroup()

# 2. Total treated states
n_treated <- df3 %>%
  distinct(STATE, first_treat) %>%
  filter(!is.na(first_treat)) %>%
  nrow()

# 3. Support table
support_med <- df3 %>%
  filter(!is.na(first_treat)) %>%
  mutate(event_time = YEAR - first_treat) %>%
  filter(event_time >= 0) %>%
  group_by(event_time) %>%
  summarise(
    treated_units = n_distinct(STATE),
    .groups = "drop"
  ) %>%
  mutate(
    share_treated = treated_units / n_treated,
    robust_5units = treated_units >= 5,
    robust_25pct  = share_treated >= 0.25
  )

support_med

#############################################################
treat_dummy <- "D_MED"

df4 <- df %>%
  group_by(STATE) %>%
  mutate(first_treat = if (any(D_MED == 1)) min(YEAR[D_MED == 1]) else NA_integer_) %>%
  ungroup()

max_horizon <- 15 # number of post treatment 
last_year <- max(df4$YEAR, na.rm = TRUE)

df_trim_med <- df4 %>%
  filter(is.na(first_treat) | first_treat <= last_year - max_horizon)


model_summary   <- list()
all_att_results <- list()
failed_models   <- list()

# -----------------------------
# Loop over crime types
# -----------------------------
for (outcome_var in crime_outcomes) {
  cat("\n=============================\n")
  cat("Running:", outcome_var, "\n")
  cat("=============================\n")
  
  
  # outcome ~ treatment | weighting covariates
  fmla <- as.formula(
    paste(
      outcome_var,
      "~", treat_dummy,
      "|", paste(covariates, collapse = " + ")
    )
  )
  
  fit <- tryCatch(
    multisynth(
      form = fmla,
      unit = STATE,
      time = YEAR,
      data = df_trim_med, 
      nu = 0
    ),
    error = function(e) e
  )
  
  
  # Handle failure
  if (inherits(fit, "error")) {
    cat("Failed:", outcome_var, "\n")
    failed_models[[outcome_var]] <- fit$message
    next
  }
  
  # -----------------------------
  # Summary
  # -----------------------------
  summ <- tryCatch(summary(fit), error = function(e) NULL)
  model_summary[[outcome_var]] <- summ
  
  summary_text <- if (!is.null(summ)) {
    capture.output(print(summ))
  } else {
    "Summary failed."
  }
  
  writeLines(
    summary_text,
    paste0("results_med_separate/", outcome_var, "_summary.txt")
  )
  
  # -----------------------------
  # Extract ATT table
  # -----------------------------
  att_tbl <- NULL
  
  if (!is.null(summ) && !is.null(summ$att)) {
    att_tbl <- as.data.frame(summ$att)
  } else if (!is.null(fit$att)) {
    if (is.vector(fit$att)) {
      att_tbl <- data.frame(
        event_time = names(fit$att),
        Estimate   = as.numeric(fit$att),
        stringsAsFactors = FALSE
      )
    } else {
      att_tbl <- as.data.frame(fit$att)
    }
  } else if (!is.null(fit$inf)) {
    att_tbl <- as.data.frame(fit$inf)
  }
  
  if (!is.null(att_tbl)) {
    att_tbl$Outcome   <- outcome_var
    att_tbl$Treatment <- treat_dummy
    
    all_att_results[[outcome_var]] <- att_tbl
    
    write.csv(
      att_tbl,
      paste0("results_med_separate/", outcome_var, "_att.csv"),
      row.names = FALSE
    )
  }
  
  # -----------------------------
  # Save plot
  # -----------------------------
  plot_file <- file.path("results_med_separate", "plots", paste0(outcome_var, "_multisynth_avg.png"))
  dir.create(dirname(plot_file), recursive = TRUE, showWarnings = FALSE)
  
  p <- tryCatch(
    plot(fit),
    error = function(e) e
  )
  
  if (inherits(p, "error")) {
    cat("Plot creation failed for", outcome_var, ":", p$message, "\n")
  } else if (inherits(p, "ggplot")) {
    ggsave(
      filename = plot_file,
      plot = p,
      width = 8,
      height = 5,
      dpi = 300
    )
    cat("Saved:", file.exists(plot_file), plot_file, "\n")
  } else {
    cat("plot() did not return a ggplot object for", outcome_var, "\n")
  }
}

# -----------------------------
# Combine ATT results
# -----------------------------
if (length(all_att_results) > 0) {
  combined_att <- bind_rows(all_att_results)
  
  write.csv(
    combined_att,
    "results_med_separate/all_att_results.csv",
    row.names = FALSE
  )
}

# -----------------------------
# Save failed models
# -----------------------------
if (length(failed_models) > 0) {
  failed_df <- data.frame(
    Outcome = names(failed_models),
    Error   = unlist(failed_models),
    row.names = NULL
  )
  
  write.csv(
    failed_df,
    "results_med_separate/failed_models.csv",
    row.names = FALSE
  )
}



