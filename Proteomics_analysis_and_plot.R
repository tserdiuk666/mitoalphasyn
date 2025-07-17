# Analysis of LiP-MS structural proteomics data on a peptide level with Median Normalization
# This script performs t-tests on proteomics data 
# using median normalization. Adjusted p-values are computed with BH correction.
# A volcano plot is generated to highlight significantly changing proteins.

# === Load Required Libraries ===
library(dplyr)
library(tidyr)
library(limma)      # for normalizeMedianValues()
library(ggplot2)

# === Load and Prepare Data ===
# Assuming 'raw_proteomics_data' is already loaded (e.g., via read.csv or read_excel)
# It should have columns: Ctrl_1, Ctrl_2, ..., Treat_4

# Remove rows with any missing values
proteomics_data <- drop_na(raw_proteomics_data)

# Combine intensity values into matrix (rows = proteins, columns = samples)
intensity_matrix <- as.matrix(proteomics_data[, c(
  "Ctrl_1", "Ctrl_2", "Ctrl_3", "Ctrl_4",
  "Treat_1", "Treat_2", "Treat_3", "Treat_4"
)])

# === Median Normalization ===
normalized_matrix <- normalizeMedianValues(intensity_matrix)

# === Statistical Testing ===
# Compute p-values using two-sample t-tests
proteomics_data$p_value <- apply(normalized_matrix, 1, function(x) {
  t.test(x[1:4], x[5:8])$p.value
})

# Compute group means and fold change
ctrl_means <- apply(normalized_matrix[, 1:4], 1, mean)
treat_means <- apply(normalized_matrix[, 5:8], 1, mean)
proteomics_data$FoldChange <- treat_means / ctrl_means
proteomics_data$FoldChange_log2 <- log2(proteomics_data$FoldChange)

# Adjust p-values using Benjamini-Hochberg method
proteomics_data$adj_p_value <- p.adjust(proteomics_data$p_value, method = "BH")

# === Basic Histograms ===
hist(proteomics_data$p_value, main = "Raw p-values", xlab = "p-value")
hist(proteomics_data$adj_p_value, main = "Adjusted p-values", xlab = "FDR (adj. p-value)")

# === Volcano Plot ===

# Define significant hits
sig_hits <- subset(proteomics_data,
                   abs(FoldChange_log2) > 0.58 & adj_p_value < 0.05)

# Base volcano plot
with(proteomics_data, plot(
  FoldChange_log2,
  -log10(adj_p_value),
  pch = 20,
  col = "gray40",
  xlim = c(-6, 6),
  xlab = "log2(Fold Change)",
  ylab = "-log10(adjusted p-value)",
  main = "Volcano Plot"
))

# Highlight significant points
with(sig_hits, points(
  FoldChange_log2,
  -log10(adj_p_value),
  pch = 20,
  col = "red"
))

box()
