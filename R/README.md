# R analysis pipeline

Install the R dependencies once:

```r
install.packages(c("readr", "dplyr", "tidyr", "tibble", "ggplot2", "jsonlite", "glmnet"))
```

Run the complete analysis from the project root:

```powershell
Rscript R/main.R
```

The script reads `data/raw/MFGEmployees4.csv` and writes the complete analysis output under `outputs/`, including descriptive summaries, hypothesis tests, figures, PCA, regression diagnostics, penalized models, and age/service sensitivity analysis.