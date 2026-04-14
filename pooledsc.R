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

covariates = c("GOV_DEM", 
               "STATE_DEM", 
               "POV_RATE", 
               "UNRATE", 
               "POP_DENSITY", 
               "lnREALINC")

##########################################
# Pooled SC for recreational marijuna

treat_dummy <- "D_REC"


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
      data = df,
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
  
  summary_text <- tryCatch(
    capture.output(summary(fit)),
    error = function(e) paste("Summary failed:", e$message)
  )
  
  writeLines(
    summary_text,
    paste0("results_rec/", outcome_var, "_summary.txt")
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
      paste0("results_rec/", outcome_var, "_att.csv"),
      row.names = FALSE
    )
  }
  
  # -----------------------------
  # Save plot
  # -----------------------------
  p <- tryCatch(plot(fit), error = function(e) NULL)
  
  if (inherits(p, "ggplot")) {
    p <- p + ggtitle(
      paste("Multisynth:", outcome_var, "(", treat_dummy, ")")
    )
    
    ggsave(
      filename = paste0("results_rec/plots/", outcome_var, "_multisynth.png"),
      plot = p,
      width = 8,
      height = 5,
      dpi = 300
    )
  } else {
    png(
      filename = paste0("results_rec/plots/", outcome_var, "_multisynth.png"),
      width = 8,
      height = 5,
      units = "in",
      res = 300
    )
    try(plot(fit), silent = TRUE)
    dev.off()
  }
}

# -----------------------------
# Combine ATT results
# -----------------------------
if (length(all_att_results) > 0) {
  combined_att <- bind_rows(all_att_results)
  
  write.csv(
    combined_att,
    "results_rec/all_att_results.csv",
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
    "results_rec/failed_models.csv",
    row.names = FALSE
  )
}
