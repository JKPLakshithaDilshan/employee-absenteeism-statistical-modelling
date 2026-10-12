# Employee Absenteeism Consultancy Project: Complete Overview

## 1. Project in one paragraph

This project is an IT3081 Statistical Modelling consultancy study for a Human Resources and manufacturing context. It analyses employee absenteeism using the continuous outcome `AbsentHours` and asks what the available employee records can safely tell management about absenteeism patterns, group differences, and prediction. The project combines data validation, descriptive statistics, statistical inference, regression modelling, model diagnostics, sensitivity analysis, critical method evaluation, literature review, and an ethical workforce decision-support proposal. The evidence describes associations and predictive performance; it does not prove that any employee characteristic causes absence.

## 2. Business problem

Employee absence can create staffing pressure, workload redistribution, productivity concerns, and wellbeing challenges. Management needs evidence about where absenteeism pressure is concentrated and how workforce-planning or supportive resources might be allocated.

The project deliberately avoids treating a prediction as proof of employee fault. The proposed use is department-, division-, business-unit-, or location-level workforce planning. Individual names and employee identifiers are excluded from modelling, and individual predictions must not be used automatically for discipline, dismissal, promotion, or denial of opportunity.

## 3. Dataset

Source file: `data/raw/MFGEmployees4.csv`

- Records: 8,336 employees
- Observed variables: 13
- Outcome: `AbsentHours`
- Numeric variables: `EmployeeNumber`, `Age`, `LengthService`, `AbsentHours`
- Categorical variables: `Gender`, `City`, `JobTitle`, `DepartmentName`, `StoreLocation`, `Division`, `BusinessUnit`
- Identity fields retained for audit only: `EmployeeNumber`, `Surname`, `GivenName`
- Model predictors: `Age`, `LengthService`, and categorical organisational/employee fields
- Raw data are preserved; no variables are invented

The dataset has no valid time variable, so it cannot support genuine trend, seasonality, forecasting, or time-series claims.

## 4. What happens in the R pipeline

The reproducible entry point is `R/main.R`. Run it from the project root with:

```powershell
Rscript R/main.R
```

The pipeline follows this sequence:

### Step 1: Prepare and validate the environment

The script checks for `readr`, `dplyr`, `tidyr`, `tibble`, `ggplot2`, `jsonlite`, and `glmnet`. It creates output folders for figures, tables, statistical results, and models.

### Step 2: Load and check the raw data

The CSV is loaded and checked against the expected 13-column schema. Unexpected or missing columns stop the pipeline. The analysis uses the expected columns in a fixed order.

### Step 3: Perform data-quality validation

The pipeline records:

- Dataset shape, column names, data types, and unique counts
- Missing values
- Duplicate rows and duplicate employee numbers
- Negative numeric values
- Implausible ages below 15 or above 100
- Records where `LengthService > Age`
- Zero-absence records
- High `AbsentHours` values above the 1.5-IQR rule

Current validation result: there are no missing values, no duplicate rows, no duplicate employee numbers, and no negative numeric values. There are 34 implausible age records, one service-age inconsistency, 1,320 zero-absence records, and 44 high-IQR target outliers. These records are retained for the main audit and examined through sensitivity analysis rather than silently deleted.

### Step 4: Produce descriptive summaries

The pipeline creates numerical summaries for `Age`, `LengthService`, and `AbsentHours`, including count, mean, median, standard deviation, variance, minimum, maximum, quartiles, IQR, and skewness. It also creates frequency and percentage summaries for categorical variables and group summaries of mean, median, and standard deviation of `AbsentHours`.

Main target description:

- Mean `AbsentHours`: 61.284
- Median: 56.006
- Standard deviation: 49.038
- Skewness: 0.642
- Zero-absence proportion: 15.83%
- Coefficient of variation: 0.800

### Step 5: Create exploratory figures

The pipeline produces:

- Distribution of absent hours
- Age versus absent hours
- Absent hours by gender
- Spearman correlation heatmap
- Mean absent hours by department
- Mean absent hours by division
- Mean absent hours by business unit

These figures are exploratory evidence. They help identify patterns but do not establish causality.

### Step 6: Test numeric relationships

For `Age` and `LengthService` against `AbsentHours`, the pipeline calculates Pearson and Spearman correlations, p-values, and the Pearson confidence interval.

Observed results:

- Age and `AbsentHours`: Pearson $r = 0.8302$, Spearman $r_s = 0.8419$, statistically significant at alpha = 0.05
- Length of service and `AbsentHours`: Pearson $r = -0.0442$, statistically significant but very small; Spearman $r_s = -0.0141$, not statistically significant

These are observed relationships in this dataset, not causal effects.

### Step 7: Test group differences

The grouping variables are `Gender`, `DepartmentName`, `Division`, and `BusinessUnit`. Groups with fewer than 10 usable observations are excluded from the group tests. For each grouping variable, the pipeline calculates:

- A median-based Levene-style variance test
- Welch's unequal-variance ANOVA
- Kruskal-Wallis test
- Eta-squared effect size
- A decision at alpha = 0.05

Where Welch's test is significant, pairwise Welch t-tests are run and p-values are adjusted using Holm correction.

Current overall result: Welch tests reject the equal-means null hypothesis for gender, department, division, and business unit. The effect sizes are small in the saved output, so statistical significance should not automatically be treated as operational importance. Pairwise post-hoc results should be interpreted with adjusted p-values, group sizes, and practical differences together.

### Step 8: Check multicollinearity

The pipeline produces VIF values for `Age` and `LengthService`. These help assess whether the two numeric predictors contain overlapping information that could destabilise coefficient interpretation.

### Step 9: Evaluate PCA

PCA is run on the standardised numeric variables `Age`, `LengthService`, and `AbsentHours`.

- PC1 explains 61.01% of variance
- PC2 explains 33.52%
- PC1 + PC2 explain 94.53%
- PC3 explains 5.47%

The numeric baseline `AbsentHours ~ Age + LengthService` has $R^2 = 0.6971$. The saved PCA comparison using PC1 and PC2 reports $R^2 = 0.9186$. PCA can reduce the three-variable representation substantially, but principal components are less directly interpretable than age and service. Therefore the pipeline recommends retaining original variables unless dimension reduction is required for a later modelling purpose. The PCA result should also be checked carefully because the target is included in the PCA input and the comparison is not the same as the full predictive model comparison.

### Step 10: Compare predictive regression models

Rows with missing values in the outcome, numeric predictors, or model categorical predictors are removed for modelling. The design matrix contains `Age`, `LengthService`, and the specified categorical predictors. The data are split into an 80% training set and a 20% test set using seed 42. Five-fold cross-validation is performed on the training set.

The models are:

1. Multiple linear regression: highest interpretability baseline
2. Ridge regression: L2 regularisation
3. LASSO regression: L1 regularisation and coefficient shrinkage
4. Elastic Net: combined L1/L2 regularisation

Performance is assessed with MAE, RMSE, and $R^2$ for cross-validation and the held-out test set.

Full-data model comparison:

| Model | CV MAE | Test MAE | Test RMSE | Test R2 | Interpretability |
|---|---:|---:|---:|---:|---|
| LASSO | 20.666 | 20.446 | 26.215 | 0.707 | Moderate |
| Elastic Net | 20.721 | 20.489 | 26.264 | 0.706 | Moderate |
| Multiple Linear Regression | 20.812 | 20.553 | 26.320 | 0.705 | High |
| Ridge | 21.597 | 21.569 | 27.499 | 0.678 | Moderate |

LASSO has the best full-data test RMSE, but the differences from Elastic Net and multiple regression are small. A final management choice must consider stability, assumptions, transparency, and ethical use, not RMSE alone.

### Step 11: Check OLS assumptions and influential observations

The diagnostic OLS model uses `AbsentHours ~ Age + LengthService` and all 8,336 observations.

- $R^2 = 0.6971$; adjusted $R^2 = 0.6970$
- Breusch-Pagan LM = 266.90, p < 0.001: evidence of heteroscedasticity
- Jarque-Bera = 116.36, p < 0.001: residual normality is not supported
- Durbin-Watson = 1.991: only a limited diagnostic here because the data are cross-sectional, not ordered time-series data
- Maximum Cook's distance = 0.0804
- 427 observations exceed the screening threshold for high leverage

OLS p-values and confidence intervals should therefore be interpreted cautiously. High-leverage observations require investigation, not automatic deletion. The project should use robust uncertainty methods if formal coefficient inference is required in the final appendix.

### Step 12: Run age/service sensitivity analysis

The pipeline compares all records with a subset excluding records flagged for implausible age or service-age inconsistency.

- Records: 8,336 to 8,302
- Mean `AbsentHours`: 61.284 to 61.535
- Age Pearson correlation: 0.8302 to 0.8331
- Numeric OLS $R^2$: 0.6971 to 0.7020
- Age coefficient: 4.1192 to 4.1992

The broad age relationship is stable. However, the regularised-model ranking changes: the full data favour LASSO, while the cleaned sensitivity run favours Elastic Net, followed closely by LASSO. The conclusion should therefore report a stable broad predictive signal but avoid claiming that one algorithm is universally best.

### Step 13: Evaluate Bayesian methods

Bayesian analysis is evaluated but not fitted. Naive Bayes is a classification method and is not appropriate as the primary method for continuous `AbsentHours`. A future Bayesian regression could use a Normal or Student-t likelihood, weakly informative priors, posterior distributions, credible intervals, posterior predictive checks, and prior-sensitivity analysis. The current project does not claim Bayesian fitted results because no defensible prior elicitation or approved organisational decision threshold was available.

### Step 14: Evaluate experimental designs

No experiment was conducted. A future completely randomised design could compare a supportive intervention with a control group. A randomised complete block design could block by department, division, job category, or location before assigning intervention conditions. Any future experiment would need ethical approval, informed safeguards, practical randomisation, contamination controls, and pre-specified outcomes. The intervention must support employees rather than punish them.

### Step 15: Evaluate time-series analysis

Time-series analysis is not valid for the current data because there is no date or repeated time measure. Future data collection should include dated department-level absence records, absence episode definitions, staffing levels, schedules, and intervention dates. With those data, the project could examine trends, seasonality, moving averages, ARIMA/SARIMA models, forecast intervals, and early-warning staffing use.

### Step 16: Save all outputs

The script writes results to:

- `outputs/tables/`: CSV summaries, tests, model comparisons, diagnostics, coefficients, residuals, PCA, and sensitivity results
- `outputs/figures/`: exploratory and diagnostic PNG figures
- `outputs/statistical_results/`: JSON validation, final summary, and Bayesian status
- `outputs/models/`: OLS summary text

## 5. Assignment task coverage

### Task 1: Understand the industry problem

Explain absenteeism in HR/manufacturing, staffing and wellbeing implications, stakeholders, and consultancy objectives. Main source: `report/consultancy_report.md`, Sections 1-2.

### Task 2: Literature review

Use the supplied research papers to cover absenteeism determinants, occupational health, manufacturing, predictive modelling, decision support, and interventions. At least 15 peer-reviewed papers must be verified before submission. The project currently identifies 18 PDF files, but the supplementary JAMA Psychiatry file is not a separate paper. Check `report/literature_review.md` and `report/citation_audit.md` before final submission.

### Task 3: Dataset and descriptive analysis

Document the dataset, variables, data types, missingness, duplicates, unique counts, invalid records, outliers, numerical summaries, categorical summaries, group summaries, and figures.

### Task 4: Statistical inference

State hypotheses, alpha = 0.05, test assumptions, test methods, p-values, effect sizes, confidence intervals where appropriate, decisions, and business meaning. Use `hypothesis_results.csv`, `posthoc_results.csv`, and `correlation_results.csv`.

### Task 5: Predictive statistical modelling

Compare multiple linear regression, Ridge, LASSO, and Elastic Net using an 80/20 split, five-fold cross-validation, MAE, RMSE, and $R^2$. Report interpretability, limitations, diagnostics, and sensitivity.

### Task 6: Experimental design evaluation

Discuss future CRD and RCBD designs only. Do not claim that an experiment was conducted.

### Task 7: PCA evaluation

Explain dimensionality reduction, explained variance, multicollinearity, predictive comparison, interpretability, and whether PCA is justified.

### Task 8: Bayesian methods evaluation

Explain why Naive Bayes is unsuitable for a continuous outcome and evaluate Bayesian regression, priors, likelihood, posterior uncertainty, sensitivity, advantages, and limitations. Do not claim a fitted Bayesian model.

### Task 9: Time-series evaluation

Explain why the current cross-sectional data cannot support time-series analysis and specify the future data needed for trends and forecasting.

### Task 10: Industry innovation proposal

Present the Employee Absenteeism Risk Intelligence and Decision Support Framework: data-quality and privacy layer, statistical insight layer, prediction layer, aggregate risk segmentation, dashboard, supportive intervention, and monitoring feedback loop. Main source: `report/conceptual_framework.md`.

### Task 11: Industry expert validation

Consult at least one real HR, manufacturing, occupational-health, workforce-planning, or relevant industry expert. Record role, date, method, feedback, evidence, and recommendation changes. This is currently pending and must not be fabricated. Use `report/expert_feedback_template.md`.

### Task 12: Final recommendations

Cover strategic planning, operations, HR practice, data improvement, technology, risk management, ethical governance, and future research. Every recommendation should identify statistical evidence, literature evidence, expert evidence, implementation ownership/resources, success measures, and uncertainty. Main source: `report/recommendations.md`.

## 6. Proposed innovation: decision-support framework

The proposed system is the **Employee Absenteeism Risk Intelligence and Decision Support Framework**. Its workflow is:

1. Collect necessary employee and workforce data with documented lineage.
2. Validate data quality, privacy, missingness, duplicates, outliers, and inconsistent records.
3. Produce descriptive and inferential statistical insights.
4. Compare predictive models and report uncertainty and performance.
5. Aggregate results at department, division, business-unit, or location level.
6. Display group summaries, uncertainty, model performance, data-quality warnings, and supportive actions in a role-based dashboard.
7. Use the evidence for staffing, workload, scheduling, wellbeing, and return-to-work support.
8. Monitor outcomes, model drift, subgroup performance, fairness, false positives, privacy incidents, and user feedback.
9. Reassess the model when dated data and intervention results become available.

Recommended dashboard views are executive summary, department comparison, workforce planning, model drivers, and governance. Names, surnames, and individual scores should not appear by default.

## 7. Implementation roadmap

| Phase | Activity | Deliverable |
|---|---|---|
| 1 | Governance and permitted-use decisions | Approved governance register |
| 2 | Add dated absence data, definitions, lineage, and validation | Quality-controlled data model |
| 3 | Re-run statistics, models, sensitivity, and fairness checks | Validated analytical pilot |
| 4 | Build an aggregate role-based dashboard | Dashboard pilot |
| 5 | Evaluate supportive interventions using an ethical CRD or RCBD | Intervention evaluation |
| 6 | Monitor drift, outcomes, fairness, quality, and feedback | Ongoing model review cycle |

Required roles include HR, operations, a statistician/data analyst, data engineering, dashboard development, privacy or ethics review, and employee representation where appropriate. Required controls include secure storage, role-based access, audit logging, a data dictionary, model card, retention rules, correction process, review calendar, and rollback procedure.

## 8. Ethical rules and limitations

- This is observational data: associations are not causes.
- Do not infer medical conditions or personal causes from the supplied variables.
- Do not use predictions as sole evidence for discipline or employment decisions.
- Do not expose unnecessary personal information or individual scores.
- Require human review for consequential actions.
- Allow employees and managers to challenge incorrect records.
- Report uncertainty, sample sizes, data-quality warnings, and model limitations.
- Check subgroup performance and fairness before operational use.
- Treat the 34 flagged age/service records through investigation and sensitivity analysis.
- Do not claim time trends, causal intervention effects, or fitted Bayesian results from the current data.
- Expert validation is pending and must be completed with real evidence.

## 9. Current project status

### Completed or generated

- Reproducible R pipeline
- Dataset schema and quality validation
- Descriptive, categorical, and group summaries
- Correlation analysis
- Welch/Kruskal-Wallis group testing and post-hoc analysis
- PCA evaluation
- Multiple regression, Ridge, LASSO, and Elastic Net comparison
- Regression diagnostics and residual outputs
- Age/service sensitivity analysis
- Bayesian method evaluation status
- Literature inventory and consultancy framework draft
- Ethical recommendations and implementation roadmap

### Still required before final submission

- Complete the full written report using generated tables and figures.
- Verify the citation audit, peer-review status, publication years, DOI records, and the unresolved Anzoom publisher record.
- Confirm the required number of recent and peer-reviewed sources from full texts.
- Add real industry expert consultation evidence and document changes made because of feedback.
- Consider robust standard errors for final inferential OLS reporting.
- Explain the PCA target-inclusion limitation and avoid presenting it as a direct replacement for the full model comparison.
- Add a data dictionary, model card, contribution statement, and reproducibility appendix.
- Re-run `Rscript R/main.R` after any data or code change and check every generated output.

## 10. One-sentence conclusion

The project shows that this dataset supports reproducible descriptive analysis, statistically significant but mostly small group differences, strong observed age association, and moderately accurate regression prediction; it does not support causal conclusions, time-series forecasting, automatic individual decisions, or claims of universal model superiority, so the defensible outcome is an ethical, aggregate workforce decision-support framework with stronger longitudinal data and expert validation as the next steps.
