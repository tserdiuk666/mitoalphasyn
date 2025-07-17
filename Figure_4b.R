
# --------------------------------------------------------------
# Script: Figure_4b.R
# Description: This script reads an Excel file containing grouped
# experimental data, reshapes it, summarizes statistics, and 
# plots a grouped bar plot with error bars and individual points points.
# 
# --------------------------------------------------------------

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

df_raw <- read_excel('~/Source_data/Figure_4b.xlsx', col_names = FALSE)
# Extract group and concentration headers
groups <- df_raw[1, ] %>% unlist(use.names = FALSE)
concs <- df_raw[2, ] %>% unlist(use.names = FALSE)

# Extract values starting from 3rd row
values <- df_raw[-c(1, 2), ]
colnames(values) <- paste(groups, concs, sep = "_")

# Convert to long format
df_long <- values %>%
  mutate(row = row_number()) %>%
  pivot_longer(-row, names_to = "group_conc", values_to = "value") %>%
  separate(group_conc, into = c("Group", "Concentration"), sep = "_") %>%
  mutate(value = as.numeric(value))

# Summarize mean and SD
df_summary <- df_long %>%
  group_by(Group, Concentration) %>%
  summarise(mean = mean(value, na.rm = TRUE),
            sd = sd(value, na.rm = TRUE),
            .groups = "drop")

df_plot <- left_join(df_long, df_summary, by = c("Group", "Concentration"))

# Set factor levels for concentration and group
df_plot <- df_plot %>%
  mutate(
    Concentration = factor(Concentration, levels = c("0.238 uM", "1.2 uM", "4.8 uM")),
    Group = factor(Group, levels = c("Monomer", "fibrils", "deltaC", "Alone")),
    Condition = case_when(
      Group == "Alone" ~ "Alone",
      TRUE ~ paste(Concentration, Group, sep = "_")
    )
  )

# Define desired order of bars
condition_levels <- c(
  "Alone",
  paste(rep(c("0.238 uM", "1.2 uM", "4.8 uM"), each = 3), c("Monomer", "fibrils", "deltaC"), sep = "_")
)

df_plot$Condition <- factor(df_plot$Condition, levels = condition_levels)

df_plot$Condition_grouped <- factor(df_plot$Condition, levels = c(
  "Alone",
  "0.238 uM_Monomer", "0.238 uM_fibrils", "0.238 uM_deltaC",
  "1.2 uM_Monomer", "1.2 uM_fibrils", "1.2 uM_deltaC",
  "4.8 uM_Monomer", "4.8 uM_fibrils", "4.8 uM_deltaC"
))


# Create spacer rows
spacers <- data.frame(
  Condition = c("spacer0", "spacer1", "spacer2"),
  value = 0,
  Group = NA
)

# Combine with spacer
df_plot_extended <- bind_rows(df_plot, spacers)

# Re-factor levels to include spacers
df_plot_extended$Condition_grouped <- factor(df_plot_extended$Condition, levels = c(
  "Alone",
  "spacer0",
  "0.238 uM_Monomer", "0.238 uM_fibrils", "0.238 uM_deltaC",
  "spacer1",
  "1.2 uM_Monomer", "1.2 uM_fibrils", "1.2 uM_deltaC",
  "spacer2",
  "4.8 uM_Monomer", "4.8 uM_fibrils", "4.8 uM_deltaC"
))

pdf('~/Source_data/Figure_4b.pdf',8,5, pointsize=20)

ggplot(df_plot_extended, aes(x = Condition_grouped, y = value, fill = Group)) +
  geom_bar(stat = "summary", fun = "mean", width = 0.6, alpha = 0.8, color = "black", na.rm = TRUE) +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1), geom = "errorbar", width = 0.2) +
  geom_jitter(data = filter(df_plot_extended, !grepl("spacer", Condition_grouped)),
              width = 0.1, size = 4, shape = 16, alpha = 1) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, NA)) +
  scale_x_discrete(labels = function(x) {
    ifelse(grepl("spacer", x), "", gsub("_", "\n", x))
  }) +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 0, size = 10, hjust = 0.5),
    axis.title = element_text(size = 12)
  ) +
  labs(x = "Condition", y = "Value", title = "Barplot_4b")

dev.off()

