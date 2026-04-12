# ============================================================
# POOLED SYNTHETIC CONTROL 
# ============================================================

# load packages
library(haven)
library(dplyr)
library(tidyr)
library(Synth)
library(ggplot2)
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

# check block structure
panelview(
  lnPROPERTY ~ D_REC, # for legalisation of recreational marijuna
  data = df,
  index = c("STATE", "YEAR"),
  pre.post = TRUE
)

panelview(
  lnPROPERTY ~ D_MED, # for legalisation of medical marijuna
  data = df,
  index = c("STATE", "YEAR"),
  pre.post = TRUE
)

##########################################
# Pooled SC for recreational marijuna

treat_dummy <- "D_REC"
cohort_year <- 2017

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

# -----------------------------
# First treatment year for D_REC
# -----------------------------
first_treat <- df %>%
  group_by(STATE) %>%
  summarise(
    first_rec = if (any(D_REC == 1, na.rm = TRUE)) {
      min(YEAR[D_REC == 1], na.rm = TRUE)
    } else {
      NA_real_
    },
    .groups = "drop"
  )

treated_states <- first_treat %>%
  filter(first_rec == cohort_year) %>%
  pull(STATE)

donor_states <- first_treat %>%
  filter(is.na(first_rec) | first_rec > cohort_year) %>%
  pull(STATE)

cat("Treated states:\n")
print(treated_states)
cat("Number of donor states:", length(donor_states), "\n")

# -----------------------------
# Analysis sample
# -----------------------------
analysis_df_base <- df %>%
  filter(STATE %in% c(treated_states, donor_states)) %>%
  mutate(
    treated_cohort = ifelse(STATE %in% treated_states & YEAR >= cohort_year, 1, 0)
  )

# -----------------------------
# Create folders
# -----------------------------
dir.create("results_rec", showWarnings = FALSE)
dir.create("results_rec/plots", showWarnings = FALSE)

# -----------------------------
# Storage objects
# -----------------------------
all_att_results <- list()
model_summary <- list()
failed_models <- list()

# -----------------------------
# Loop
# -----------------------------
for (outcome_var in crime_outcomes) {
  cat("\n=============================\n")
  cat("Running:", outcome_var, "\n")
  cat("=============================\n")
  
  # Keep only complete rows for this outcome
  analysis_df <- analysis_df_base %>%
    filter(!is.na(.data[[outcome_var]]))
  
  # Try model
  fit <- tryCatch(
    {
      augsynth(
        as.formula(paste(outcome_var, "~ treated_cohort")),
        unit = STATE,
        time = YEAR,
        t_int = cohort_year,
        data = analysis_df,
        progfunc = "none",
        scm = TRUE
      )
    },
    error = function(e) e
  )
  
  # Handle failure
  if (inherits(fit, "error")) {
    cat("Failed:", outcome_var, "\n")
    failed_models[[outcome_var]] <- fit$message
    next
  }
  
  # Model summary
  summ <- summary(fit)
  model_summary[[outcome_var]] <- summ
  
  # Save full printed summary as text file
  summary_text <- capture.output(summary(fit))
  writeLines(
    summary_text,
    paste0("results_rec/", outcome_var, "_summary.txt")
  )
  
  # Extract ATT table
  att_tbl <- NULL
  
  if (!is.null(fit$att)) {
    att_tbl <- data.frame(
      YEAR = as.numeric(names(fit$att)),
      Estimate = as.numeric(fit$att)
    )
  }
  
  if (!is.null(summ$att)) {
    att_tbl <- as.data.frame(summ$att)
  }
  
  if (is.null(att_tbl) && !is.null(fit$inf)) {
    att_tbl <- as.data.frame(fit$inf)
  }
  
  if (!is.null(att_tbl)) {
    if (!"Outcome" %in% names(att_tbl)) {
      att_tbl$Outcome <- outcome_var
    }
    att_tbl$Treatment <- treat_dummy
    att_tbl$Cohort <- cohort_year
    
    all_att_results[[outcome_var]] <- att_tbl
    
    # Save ATT table as csv
    write.csv(
      att_tbl,
      paste0("results_rec/", outcome_var, "_att.csv"),
      row.names = FALSE
    )
  }
  
  # Save plot safely
  p <- tryCatch(plot(fit), error = function(e) NULL)
  
  if (inherits(p, "ggplot")) {
    p <- p + ggtitle(
      paste("Pooled SC:", outcome_var, "(", treat_dummy, ", cohort", cohort_year, ")")
    )
    
    ggsave(
      filename = paste0("results_rec/plots/", outcome_var, "_pooled_sc.png"),
      plot = p,
      width = 8,
      height = 5,
      dpi = 300
    )
  } else {
    png(
      filename = paste0("results_rec/plots/", outcome_var, "_pooled_sc.png"),
      width = 8,
      height = 5,
      units = "in",
      res = 300
    )
    plot(fit)
    dev.off()
  }
}

combined_att <- bind_rows(all_att_results)

write.csv(
  combined_att,
  "results_rec/all_att_results.csv",
  row.names = FALSE
)

if (length(failed_models) > 0) {
  failed_df <- data.frame(
    Outcome = names(failed_models),
    Error = unlist(failed_models)
  )
  
  write.csv(
    failed_df,
    "results_rec/failed_models.csv",
    row.names = FALSE
  )
}
##########################################
# Pooled SC for medicinal marijuna

treat_dummy <- "D_MED"
cohort_year <- 2017

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

# -----------------------------
# First treatment year for D_MED
# -----------------------------
first_treat <- df %>%
  group_by(STATE) %>%
  summarise(
    first_treat = if (any(.data[[treat_dummy]] == 1, na.rm = TRUE)) {
      min(YEAR[.data[[treat_dummy]] == 1], na.rm = TRUE)
    } else {
      NA_real_
    },
    .groups = "drop"
  )

treated_states <- first_treat %>%
  filter(first_treat == cohort_year) %>%
  pull(STATE)

donor_states <- first_treat %>%
  filter(is.na(first_treat) | first_treat > cohort_year) %>%
  pull(STATE)

cat("Treated states:\n")
print(treated_states)
cat("Number of donor states:", length(donor_states), "\n")

# -----------------------------
# Analysis sample
# -----------------------------
analysis_df_base <- df %>%
  filter(STATE %in% c(treated_states, donor_states)) %>%
  mutate(
    treated_cohort = ifelse(STATE %in% treated_states & YEAR >= cohort_year, 1, 0)
  )

# -----------------------------
# Create folders
# -----------------------------
dir.create("results_med", showWarnings = FALSE)
dir.create("results_med/plots", showWarnings = FALSE)

# -----------------------------
# Storage objects
# -----------------------------
all_att_results <- list()
model_summary <- list()
failed_models <- list()

# -----------------------------
# Loop
# -----------------------------
for (outcome_var in crime_outcomes) {
  cat("\n=============================\n")
  cat("Running:", outcome_var, "\n")
  cat("=============================\n")
  
  analysis_df <- analysis_df_base %>%
    filter(!is.na(.data[[outcome_var]]))
  
  fit <- tryCatch(
    {
      augsynth(
        as.formula(paste(outcome_var, "~ treated_cohort")),
        unit = STATE,
        time = YEAR,
        t_int = cohort_year,
        data = analysis_df,
        progfunc = "none",
        scm = TRUE
      )
    },
    error = function(e) e
  )
  
  if (inherits(fit, "error")) {
    cat("Failed:", outcome_var, "\n")
    failed_models[[outcome_var]] <- fit$message
    next
  }
  
  summ <- summary(fit)
  model_summary[[outcome_var]] <- summ
  
  writeLines(
    capture.output(summary(fit)),
    paste0("results_med/", outcome_var, "_summary.txt")
  )
  
  att_tbl <- NULL
  
  if (!is.null(fit$att)) {
    att_tbl <- data.frame(
      YEAR = as.numeric(names(fit$att)),
      Estimate = as.numeric(fit$att)
    )
  }
  
  if (!is.null(summ$att)) {
    att_tbl <- as.data.frame(summ$att)
  }
  
  if (is.null(att_tbl) && !is.null(fit$inf)) {
    att_tbl <- as.data.frame(fit$inf)
  }
  
  if (!is.null(att_tbl)) {
    att_tbl$Outcome <- outcome_var
    att_tbl$Treatment <- treat_dummy
    att_tbl$Cohort <- cohort_year
    
    all_att_results[[outcome_var]] <- att_tbl
    
    write.csv(
      att_tbl,
      paste0("results_med/", outcome_var, "_att.csv"),
      row.names = FALSE
    )
  }
  
  # Save plot safely
  p <- tryCatch(plot(fit), error = function(e) NULL)
  
  if (inherits(p, "ggplot")) {
    p <- p + ggtitle(
      paste("Pooled SC:", outcome_var, "(", treat_dummy, ", cohort", cohort_year, ")")
    )
    
    ggsave(
      filename = paste0("results_med/plots/", outcome_var, "_pooled_sc.png"),
      plot = p,
      width = 8,
      height = 5,
      dpi = 300
    )
  } else {
    png(
      filename = paste0("results_med/plots/", outcome_var, "_pooled_sc.png"),
      width = 8,
      height = 5,
      units = "in",
      res = 300
    )
    plot(fit)
    dev.off()
  }
}

combined_att <- bind_rows(all_att_results)

write.csv(
  combined_att,
  "results_med/all_att_results.csv",
  row.names = FALSE
)

if (length(failed_models) > 0) {
  failed_df <- data.frame(
    Outcome = names(failed_models),
    Error = unlist(failed_models)
  )
  
  write.csv(
    failed_df,
    "results_med/failed_models.csv",
    row.names = FALSE
  )
}

# Determine the cohort year for maximum number of states for pooled sc

# df %>%
#   group_by(STATE) %>%
#   summarise(
#     first_med = if (any(D_REC == 1, na.rm = TRUE)) {
#       min(YEAR[D_MED == 1], na.rm = TRUE)
#     } else {
#       NA_real_
#     },
#     .groups = "drop"
#   ) %>%
#   count(first_med, sort = TRUE)


# df %>%
#   group_by(STATE) %>%
#   summarise(
#     first_med = if (any(D_MED == 1, na.rm = TRUE)) {
#       min(YEAR[D_MED == 1], na.rm = TRUE)
#     } else {
#       NA_real_
#     },
#     .groups = "drop"
#   ) %>%
#   count(first_med, sort = TRUE)
