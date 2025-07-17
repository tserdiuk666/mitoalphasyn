
# Proteomics Analysis & Figure Reproduction

This repository contains R scripts used for the analysis and visualization of LiP-MS structural proteomics data, as well as code for generating figures from our manuscript (Alpha-synuclein interacts with regulators of ATP homeostasis in mitochondria", specifically **Figure 4b–4g**).

---

##  Repository Structure

```
.
├── Proteomics_analysis_and_plot.R   # Median-normalized t-tests + volcano plot
├── Figure_4b_barplot.R                 # Grouped bar plot with error bars and jitter
├── Figure_4c_g_lineplot.R             # Time-series plots for deltaC and controls
├── Source_data/                        # Input Excel files and raw data
├── output/                             # Generated PDF figures
└── README.md                           # This file
```

---

##  1. Structural proteomics analysis

**Script:** `Proteomics_analysis_and_plot.R`

This script performs statistical testing on proteomics data on a peptide level using median normalization and two-sample t-tests. It generates volcano plots and computes adjusted p-values using Benjamini-Hochberg correction.

### Workflow Summary

- Removes rows with missing values
- Normalizes columns to the same median using `normalizeMedianValues()` from **limma**
- Performs unpaired two-sample t-tests between control and treatment groups
- Computes:
  - Raw p-values
  - Adjusted p-values (FDR)
  
- Generates:
  - Histograms of p-values and FDR
  - A volcano plot highlighting significant hits

### Required Libraries

```r
library(dplyr)
library(tidyr)
library(limma)
library(ggplot2)
```

### Input

Provide a `data.frame` named `raw_proteomics_data` 

### Output

- `proteomics_data` with p-values, adjusted p-values, log2 fold change
- Volcano plot (optional PDF output)
- Optional CSV export of full results

---

##  2. Figure 4b – Grouped Bar Plot with Error Bars

**Script:** `Figure_4b_barplot.R`

Generates a grouped bar plot showing average values and standard deviations across multiple treatment conditions. Individual measurements are overlaid as dots.

### Key Features

- Reads headers and values from Excel
- Reshapes and summarizes data
- Uses `ggplot2` to:
  - Plot group means ± SD
  - Overlay raw data points
  - Insert visual spacers between groups
  - Format labels and layout for publication

### Input

- Excel file: `Figure_4b.xlsx` in `Source_data/` folder  (Ensure first two rows are `Group` and `Concentration` headers)

### Output

- `Figure_4b.pdf` saved in working directory

---

## ️ 3. Figure 4c–4g – Time-Resolved Intensity Plots

**Script:** `Figure_4c_g_lineplot.R`

Generates time-series plots of intensity values for three different samples (deltaC, AK2.1, AK2.2), with standard deviation error bars.

### Input

A `data.frame` named `AK2_WT` must contain:

| Column Name | Description                   |
| ----------- | ----------------------------- |
| `Time`      | Time points (numeric)         |
| `DC`        | Mean intensity for deltaC     |
| `DC.S.D`    | Standard deviation for deltaC |
| `AK2.1`     | Mean intensity for AK2.1      |
| `AK2.1.S.D` | Standard deviation for AK2.1  |
| `AK2.2`     | Mean intensity for AK2.2      |
| `AK2.2.S.D` | Standard deviation for AK2.2  |

### Output

- `AK2_DLS_condition_deltaC_test.pdf` with plotted time series and legend

---

##  Notes

- All figures are saved as PDFs.
- `normalizeMedianValues()` is a median normalization function from **limma**, designed by Gordon Smyth.

---

## License

This repository is shared for transparency and reproducibility. Please cite the associated manuscript when using this code.
