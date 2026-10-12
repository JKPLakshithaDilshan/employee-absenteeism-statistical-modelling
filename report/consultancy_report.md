# Employee Absenteeism Analysis and Prediction
## Consultancy Report Draft

> This document is a structured evidence report. Numeric findings must be taken from `outputs/` after running `Rscript R/main.R`. Do not replace placeholders with invented results.

## 1. Executive Summary
**Business problem:** Employee absence can reduce productivity and increase staffing and operational pressure.

**Data:** The supplied file contains 8,336 records and 13 variables. It has no missing values or duplicate employee identifiers. Quality concerns include 34 implausibly young ages and one service-age inconsistency.

**Current evidence:** `AbsentHours` has mean 61.284, median 56.006, standard deviation 49.038, and 15.83% zero values. Age has a strong observed Pearson correlation with `AbsentHours` (r = 0.8302), but this is observational and should be checked for data-generation artefacts and sensitivity to flagged ages.

**Recommendation:** Complete the generated inference and model tables, select a model using predictive performance, assumptions, stability, and management interpretability, and use outputs for supportive workforce planning rather than automated individual sanctions.

## 2. Introduction
### 2.1 Industry background
Discuss manufacturing/Human Resources workforce continuity, staffing, wellbeing, and operational costs using verified sources.
### 2.2 Organizational context
Describe the client context without claiming facts not supplied by the organization.
### 2.3 Business problem and stakeholders
Cover employees, HR, supervisors, operations, finance, senior management, and data governance stakeholders.
### 2.4 Consultancy objectives
Link objectives to RQ1-RQ10.

## 3. Research Questions and Hypotheses
Use alpha = 0.05. Final hypotheses must be selected after inspecting group sizes and assumptions. Examples include gender mean comparison, department mean differences, and numeric associations. For every test report H0, H1, method, assumptions, statistic, p-value, confidence interval/effect size where appropriate, decision, and business interpretation.

## 4. Literature Review
The supplied `Research Papers/` folder contains 18 PDF files covering absenteeism determinants, occupational health, manufacturing, predictive modelling, machine learning, decision support, and workplace interventions. One file is supplementary content for a JAMA Psychiatry article, so it should not be counted as a separate paper. The detailed inventory and comparison matrix are in [literature_review.md](literature_review.md), and DOI/status verification is in [citation_audit.md](citation_audit.md).

The literature indicates that absenteeism is associated with multiple worker, workplace, health, psychosocial, and non-work factors. Recent studies increasingly use machine learning, penalised regression, network analysis, historical attendance profiles, and decision-support tools. However, definitions of absence vary across studies, prediction does not establish causality, and individual-level HR prediction creates privacy, fairness, and punitive-misuse risks.

This project addresses the gap by modelling the supplied continuous `AbsentHours` outcome, auditing implausible records, comparing interpretable and regularised regression, and translating results into an ethical decision-support framework. Before submission, resolve the one unresolved publisher record and confirm the required peer-review and publication-date counts from the full papers.

## 5. Dataset and Methodology
Document the 13 observed variables, raw-file preservation, quality checks, excluded identifiers, sensitivity analysis for flagged records, 80/20 split, cross-validation, and leakage-safe preprocessing.

## 6. Descriptive Analysis
Insert `outputs/tables/descriptive_statistics.csv`, `categorical_summary.csv`, and `group_summary.csv`, plus figures. Explain operational implications without causal language.

## 7. Statistical Inference
Insert generated `hypothesis_results.csv`, `posthoc_results.csv`, and `correlation_results.csv`. Prefer Welch/Kruskal-Wallis where assumptions or group imbalance require it. Report practical effect sizes, not p-values alone.

## 8. Predictive Statistical Modelling
Compare multiple regression, Ridge, LASSO, and Elastic Net. Report cross-validation MAE/RMSE, test MAE/RMSE/R2, coefficients, uncertainty for the inferential model, residual diagnostics, heteroscedasticity, independence, normality, and VIF. Do not select solely on RMSE.

### 8.1 Regression assumption diagnostics
The OLS diagnostic output is in `outputs/tables/regression_diagnostics.csv`, with residual observations in `outputs/tables/residual_observations.csv` and figures in `outputs/figures/regression_residual_diagnostics.png` and `outputs/figures/regression_residual_qq.png`.

For the numeric OLS baseline using `Age` and `LengthService`, $R^2$ is 0.6971 and adjusted $R^2$ is 0.6970. The Breusch-Pagan test is significant (LM = 266.90, p < 0.001), providing evidence of non-constant residual variance. The Jarque-Bera test is significant (JB = 116.69, p < 0.001), so residual normality is not supported. The Durbin-Watson statistic is 1.991; because the data are cross-sectional rather than ordered time-series observations, this is only a limited independence diagnostic and should not be interpreted as time-series evidence. The maximum Cook's distance is 0.0804 and 427 observations exceed the high-leverage screening threshold used in the diagnostic output. These observations should be investigated, not automatically deleted.

Because heteroscedasticity and non-normal residuals are present, conventional OLS p-values should be interpreted cautiously. The regularised models should be compared using cross-validation and held-out error, while any inferential coefficient claims should report limitations and, where required, heteroscedasticity-robust standard errors in the final statistical appendix.

### 8.2 Age-record sensitivity analysis
The sensitivity outputs are `outputs/tables/age_sensitivity_summary.csv` and `outputs/tables/age_sensitivity_models.csv`. Removing the 34 records flagged for implausible age or service-age inconsistency changes mean `AbsentHours` from 61.2840 to 61.5350, Pearson correlation between Age and `AbsentHours` from 0.8302 to 0.8331, and the numeric OLS $R^2$ from 0.6971 to 0.7020. The age coefficient changes from 4.1192 to 4.1992, while the statistical significance conclusion is unchanged.

For the full dataset, LASSO has the lowest test RMSE (25.956). After excluding the flagged records, Elastic Net has the lowest test RMSE (25.219), followed closely by LASSO (25.252). This indicates that the broad predictive conclusion is reasonably stable, but the exact regularised-model ranking is sensitive to the flagged records. The final recommendation should therefore report both analyses and avoid presenting one model as universally superior.

## 9. PCA Critical Evaluation
The current numerical feature set is small. Use `pca_results.csv` and the cumulative-variance figure. Explain whether dimensionality reduction improves prediction enough to justify reduced interpretability.

## 10. Bayesian Methods
Naive Bayes is a classification method and is not directly suitable for continuous `AbsentHours`. Bayesian regression may add credible intervals, priors, hierarchical structure, and updating, but requires prior-sensitivity analysis. The implementation status is recorded in `bayesian_status.json`; do not claim it was run unless it was.

## 11. Experimental Design
No experiment was conducted. Evaluate a future CRD comparing supportive intervention and control, and an RCBD blocking by department, division, job category, or location. Discuss contamination, ethics, feasibility, randomisation, and causal interpretation.

## 12. Time Series
No valid time variable exists in this dataset. Propose collection of dated department-level records and evaluate trend, seasonality, moving averages, ARIMA/SARIMA, forecast intervals, staffing, and early-warning use.

## 13. Innovation Proposal
The proposed innovation is the **Employee Absenteeism Risk Intelligence and Decision Support Framework**, described fully in [conceptual_framework.md](conceptual_framework.md). It converts validated employee and workforce records into aggregate absenteeism insights, model predictions, uncertainty information, and supportive management actions.

The business need is to help HR and operations understand where absenteeism pressure is concentrated and how staffing, workload, scheduling, and wellbeing resources could be allocated. The solution includes a data-quality and privacy layer, statistical insight layer, prediction layer, risk segmentation, role-based dashboard, supportive intervention workflow, and monitoring feedback loop.

Expected benefits include earlier identification of department-level staffing pressure, more targeted workforce planning, consistent reporting of uncertainty, better coordination between HR and operations, and a repeatable process for updating the model when dated data become available. The solution is deliberately designed for organizational decision support rather than automatic employee surveillance or punishment.

Implementation challenges include invalid records, small group sizes, model drift, algorithmic bias, privacy, causal overinterpretation, and user adoption. Required resources include an HR owner, operations representative, statistician, data engineer, dashboard developer, privacy or ethics reviewer, secure storage, role-based access, version control, audit logging, and a data dictionary. A phased roadmap covers governance, data foundation, analytical pilot, dashboard pilot, intervention evaluation, and ongoing monitoring.

Organizational impact includes a shift from periodic descriptive reporting to governed, evidence-based workforce planning. Success should be assessed using data-quality resolution, model stability, subgroup performance, dashboard adoption, staffing-response time, supportive-intervention outcomes, employee feedback, and privacy incidents. A reduction in recorded absence alone should not be treated as proof of success.

## 14. Industry Expert Validation
Industry expert validation must be completed using [expert_feedback_template.md](expert_feedback_template.md). The consultation should involve at least one real HR, manufacturing, workforce-planning, occupational-health, or relevant industry expert. The team must present the problem, selected findings, proposed framework, recommendations, and implementation risks, then record professional feedback about relevance, practicality, feasibility, and organizational impact.

The final report should include the expert's role and consultation date, consultation method, anonymised feedback summary, evidence reference, key themes, and a table showing which recommendations changed because of the feedback. Acceptable evidence includes an interview summary, meeting minutes, email communication, completed feedback form, or permitted meeting screenshot. Do not fabricate feedback or imply that the proposal was validated before the consultation occurred.

At the current stage, expert evidence is **pending**. The recommendations must therefore distinguish statistical evidence and literature evidence from unavailable expert evidence.

## 15-19. Recommendations, risks, limitations, future research, conclusion
Use [recommendations.md](recommendations.md). Recommendations must cover strategic action, operational action, risk management, ethics, and future research. Each recommendation must separately identify statistical evidence, literature evidence, expert evidence, implementation owner/resources, success measures, and remaining uncertainty. Mark expert evidence as pending until the real consultation is completed.

## 20. References

Bae, Y.-H. (2021). Exploratory analysis of related factors with absenteeism and presenteeism on workers: Using the Fourth Korea Working Condition Survey. *International Journal of Environmental Research and Public Health*. https://doi.org/10.3390/ijerph182111214

Bowen, F., Gentle-Genitty, C., Siegler, J., & Jackson, M. (2022). Revealing underlying factors of absenteeism: A machine learning approach. *Frontiers in Psychology*. https://doi.org/10.3389/fpsyg.2022.958748

Cikes, V., Maskarin Ribaric, H., & Crnjar, K. (2018). The determinants and outcomes of absence behavior: A systematic literature review. *Social Sciences*. https://doi.org/10.3390/socsci7080120

Duchaine, C. S., Aubé, K., Gilbert-Ouimet, M., Vézina, M., Ndjaboué, R., Massamba, V., Talbot, D., Lavigne-Robichaud, M., Trudel, X., Pena-Gralle, A.-P. B., Lesage, A., Moore, L., Milot, A., Laurin, D., & Brisson, C. (2020). Psychosocial stressors at work and the risk of sickness absence due to a diagnosed mental disorder: A systematic review and meta-analysis. *JAMA Psychiatry*. https://doi.org/10.1001/jamapsychiatry.2020.0322

Kim, D., & Lee, J. W. (2025). Predicting absenteeism at workplace using machine learning and network analysis. *SAGE Open*. https://doi.org/10.1177/21582440251336019

Lawrance, N., Petrides, G., & Guerry, M.-A. (2021). Predicting employee absenteeism for cost effective interventions. *Decision Support Systems*. https://doi.org/10.1016/j.dss.2021.113539

Llamas Blázquez, P. (2025). Predicting workplace absenteeism using machine learning: A pilot study in occupational health. *Journal of Occupational Medicine and Toxicology*. https://doi.org/10.1186/s12995-025-00482-5

Nath, G., Wang, Y., Coursey, A., Saha, K. K., Prabhu, S., & Sengupta, S. (2022). Incorporating a machine learning model into a web-based administrative decision support tool for predicting workplace absenteeism. *Information, 13*, 320. https://doi.org/10.3390/info13070320

Nawata, K. (2024). Evaluation of physical and mental health conditions related to employees' absenteeism. *Frontiers in Public Health*. https://doi.org/10.3389/fpubh.2023.1326334

Nowak, J., Emmermacher, A., Wendsche, J., Döbler, A.-S., & Wegge, J. (2023). Presenteeism and absenteeism in the manufacturing sector: A multilevel approach identifying underlying factors and relations to health. *Current Psychology*. https://doi.org/10.1007/s12144-022-03013-1

Odeen, M., Magnussen, L. H., Maeland, S., Larun, L., Eriksen, H. R., & Tveito, T. H. (2013). Systematic review of active workplace interventions to reduce sickness absence. *Occupational Medicine, 63*, 7-16. https://doi.org/10.1093/occmed/kqs198

Saruan, N. A. M., Yusoff, H. M., Fauzi, M. F. M., Wan Puteh, S. E., et al. (2020). Unplanned absenteeism: The role of workplace and non-workplace stressors. *International Journal of Environmental Research and Public Health*. https://doi.org/10.3390/ijerph17176132

Thorsen, S. V., Flyvholm, M.-A., Pedersen, J., Bültmann, U., Andersen, L. L., & Bjorner, J. B. (2021). Associations between physical and psychosocial work environment factors and sickness absence incidence depend on the lengths of the sickness absence episodes: A prospective study of 27,678 Danish employees. *Occupational and Environmental Medicine, 78*, 46-53. https://doi.org/10.1136/oemed-2020-106554

Wagner, S., White, M., Schultz, I., Murray, E., Bradley, S. M., Hsu, V., McGuire, L., & Schulz, W. (2014). Modifiable worker risk factors contributing to workplace absence: A stakeholder-centred best-evidence synthesis of systematic reviews. *Work, 49*, 541-558. https://doi.org/10.3233/WOR-131709

White, M. I., Wagner, S. L., Schultz, I. Z., Murray, E., Bradley, S. M., Hsu, V., McGuire, L., & Schulz, W. (2015). Non-modifiable worker and workplace risk factors contributing to workplace absence: A stakeholder-centred synthesis of systematic reviews. *Work, 52*, 353-373. https://doi.org/10.3233/WOR-152134

Zupančič, P., & Panov, P. (2024). Predicting employee absence from historical absence profiles with machine learning. *Applied Sciences, 14*, 7037. https://doi.org/10.3390/app14167037

Alars, M., & Albakry, A. (2026). Data-driven predictive modelling of employee absenteeism using workflow automation platforms. *International Journal of Innovative Technology and Interdisciplinary Sciences, 9*(1), 115-136. https://doi.org/10.15157/IJITIS.2026.9.1.115-136

The Anzoom et al. paper in the supplied folder is excluded from this final list because its publisher, DOI, journal, and peer-review status remain unresolved. See [citation_audit.md](citation_audit.md).

## 21. Appendices
Include data dictionary, validation output, model diagnostics, sensitivity analysis, expert evidence, contribution statement, and reproducibility instructions.
