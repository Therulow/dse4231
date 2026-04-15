# Script for plotting the graphs
library(dplyr)
library(ggplot)

######################################################
### Separate SCM 
######################################################

### Medical

files <- c(
  "lnASSAULT_att.csv",
  "lnAUTO_att.csv",
  "lnBURGLARY_att.csv",
  "lnLARCENY_att.csv",
  "lnMURDER_att.csv",
  "lnPROPERTY_att.csv",
  "lnRAPE_att.csv",
  "lnROBBERY_att.csv", 
  "lnVIOLENT1_att.csv"
)

titles <- c(
  "Aggravated Assault",
  "Auto Theft",
  "Burglary",
  "Larceny",
  "Murder",
  "Property Crime",
  "Rape",
  "Robbery", 
  "Violent Crimes"
)

for (i in seq_along(files)) {
  
  # read data
  df <- read.csv(paste0("../../results_med_separate/", files[i]))
  
  # split data
  avg   <- subset(df, Level == "Average")
  post  <- subset(avg, Time >= 0)
  units <- subset(df, Level != "Average")
  
  # create plot
  p <- ggplot() +
    geom_line(
      data = units,
      aes(x = Time, y = Estimate, group = Level),
      alpha = 0.3,
      color = "grey60"
    ) +
    
    geom_ribbon(
      data = post,
      aes(x = Time, ymin = lower_bound, ymax = upper_bound),
      fill = "grey70",
      alpha = 0.4
    ) +
    
    geom_line(
      data = avg,
      aes(x = Time, y = Estimate),
      color = "black",
      linewidth = 1.2
    ) +
    
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed") +
    
    labs(
      title = paste("Medical Legalization:", titles[i]),
      x = "Time Relative to Treatment",
      y = paste("Effect on", titles[i])
    ) +
    
    theme_minimal()
  
  # save plot
  ggsave(
    filename = paste0("medical/", gsub("_att.csv", "_plot.png", files[i])),
    plot = p,
    width = 8,
    height = 5,
    dpi = 300
  )
}

# recreational 
files <- c(
  "lnASSAULT_att.csv",
  "lnAUTO_att.csv",
  "lnBURGLARY_att.csv",
  "lnLARCENY_att.csv",
  "lnMURDER_att.csv",
  "lnPROPERTY_att.csv",
  "lnRAPE_att.csv",
  "lnROBBERY_att.csv", 
  "lnVIOLENT1_att.csv"
)

titles <- c(
  "Aggravated Assault",
  "Auto Theft",
  "Burglary",
  "Larceny",
  "Murder",
  "Property Crime",
  "Rape",
  "Robbery", 
  "Violent Crimes"
)

for (i in seq_along(files)) {
  
  # read data
  df <- read.csv(paste0("../../results_rec_separate/", files[i]))
  
  # split data
  avg   <- subset(df, Level == "Average")
  post  <- subset(avg, Time >= 0)
  units <- subset(df, Level != "Average")
  
  # create plot
  p <- ggplot() +
    geom_line(
      data = units,
      aes(x = Time, y = Estimate, group = Level),
      alpha = 0.3,
      color = "grey60"
    ) +
    
    geom_ribbon(
      data = post,
      aes(x = Time, ymin = lower_bound, ymax = upper_bound),
      fill = "grey70",
      alpha = 0.4
    ) +
    
    geom_line(
      data = avg,
      aes(x = Time, y = Estimate),
      color = "black",
      linewidth = 1.2
    ) +
    
    geom_vline(xintercept = 0, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed") +
    
    labs(
      title = paste("Recreational Legalization:", titles[i]),
      x = "Time Relative to Treatment",
      y = paste("Effect on", titles[i])
    ) +
    
    theme_minimal()
  
  # save plot
  ggsave(
    filename = paste0("recreational/", gsub("_att.csv", "_plot.png", files[i])),
    plot = p,
    width = 8,
    height = 5,
    dpi = 300
  )
}


