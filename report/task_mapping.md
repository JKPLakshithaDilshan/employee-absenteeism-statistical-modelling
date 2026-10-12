# IT3081 Assignment Task Mapping

This guide shows where each assignment task belongs in the consultancy project.

## Task 1: Understanding the Industry Problem

Include:

- Human Resources and manufacturing context
- Employee absenteeism business problem
- Productivity, staffing, wellbeing, and operational implications
- Stakeholders
- Consultancy objectives

Primary location: [consultancy_report.md](consultancy_report.md), Sections 1-2.

## Task 2: Research Landscape and Literature Review

Include:

- At least 15 verified peer-reviewed papers
- Industry practices
- Existing absenteeism methods
- Predictive modelling research
- Workplace intervention research
- Manufacturing-sector evidence
- Research limitations and gaps
- Justification for the selected methods

Primary locations:

- [literature_review.md](literature_review.md)
- [citation_audit.md](citation_audit.md)
- Section 4 of [consultancy_report.md](consultancy_report.md)
- `Research Papers/`

## Task 3: Dataset Understanding and Descriptive Analysis

Include:

- Dataset source and description
- Variable definitions
- Data types
- Missing-value analysis
- Duplicate analysis
- Unique-value counts
- Outlier analysis
- Numerical summaries
- Categorical summaries
- Initial organizational insights

Primary locations:

- [R/main.R](../R/main.R)
- `outputs/tables/descriptive_statistics.csv`
- `outputs/tables/categorical_summary.csv`
- `outputs/tables/group_summary.csv`
- `outputs/figures/`

## Task 4: Statistical Inference

Include:

- Research hypotheses
- Null and alternative hypotheses
- Significance level alpha = 0.05
- Test selection and assumptions
- Gender comparison
- Department comparison
- Division and business-unit comparisons
- Age and service-length correlations
- P-values, effect sizes, and confidence intervals where appropriate
- Business interpretation

Primary locations:

- [R/main.R](../R/main.R)
- Section 7 of [consultancy_report.md](consultancy_report.md)
- `outputs/tables/hypothesis_results.csv`
- `outputs/tables/posthoc_results.csv`
- `outputs/tables/correlation_results.csv`

## Task 5: Predictive Statistical Modelling

Include:

- Multiple linear regression
- Ridge regression
- LASSO regression
- Elastic Net
- Train-test split
- Cross-validation
- MAE, RMSE, and R-squared
- Model comparison
- Interpretability and business suitability
- Limitations and assumptions

Primary locations:

- [R/main.R](../R/main.R)
- Section 8 of [consultancy_report.md](consultancy_report.md)
- `outputs/tables/model_comparison.csv`
- `outputs/models/ols_summary.txt`

## Task 6: Experimental Design Evaluation

Discuss future experiments only. Do not claim that an experiment was conducted.

Include:

- Completely Randomized Design
- Randomized Complete Block Design
- Treatment and control groups
- Possible absenteeism-reduction intervention
- Department, division, job, or location blocking
- Randomization
- Contamination
- Ethical issues
- Practical feasibility

Primary location: Section 11 of [consultancy_report.md](consultancy_report.md).

## Task 7: Principal Component Analysis Evaluation

Include:

- Purpose of PCA
- Numerical-variable dimensionality
- Correlation structure
- Explained variance
- Scree or cumulative-variance plot
- Impact on multicollinearity
- Impact on predictive performance
- Loss of interpretability
- Organizational recommendation

Primary locations:

- [R/main.R](../R/main.R)
- `outputs/tables/pca_results.csv`
- `outputs/figures/pca_scree_cumulative.png`
- Section 9 of [consultancy_report.md](consultancy_report.md)

## Task 8: Bayesian Methods Evaluation

Include:

- Naive Bayes limitation for continuous `AbsentHours`
- Bayesian regression
- Priors, likelihood, and posterior distributions
- Credible intervals
- Prior sensitivity
- Bayesian decision-making
- Advantages and limitations

Primary locations:

- [R/main.R](../R/main.R)
- `outputs/statistical_results/bayesian_status.json`
- Section 10 of [consultancy_report.md](consultancy_report.md)

## Task 9: Time-Series Analysis Evaluation

The current dataset contains no valid time variable. Do not create a fake date.

Discuss:

- Trend analysis
- Seasonality
- Moving averages
- ARIMA and SARIMA
- Forecast uncertainty
- Workforce planning
- Staffing and early-warning systems
- Future data requirements

Primary location: Section 12 of [consultancy_report.md](consultancy_report.md).

## Task 10: Industry Innovation Proposal

Include:

- Business need
- Employee Absenteeism Risk Intelligence and Decision Support Framework
- Data-quality layer
- Statistical-analysis layer
- Prediction layer
- Risk segmentation
- Dashboard
- Supportive intervention
- Monitoring and feedback loop
- Expected benefits
- Required resources
- Implementation challenges
- Organizational impact
- Success measures
- Ethics and governance

Primary locations:

- [conceptual_framework.md](conceptual_framework.md)
- Section 13 of [consultancy_report.md](consultancy_report.md)
- [recommendations.md](recommendations.md)

## Task 11: Industry Expert Validation

Consult at least one real industry expert. Do not fabricate feedback.

Include:

- Expert role and relevant experience
- Consultation date and method
- Problem relevance
- Practicality of recommendations
- Dashboard usefulness
- Implementation feasibility
- Organizational impact
- Ethical concerns
- Additional data requirements
- Changes made because of feedback
- Supporting evidence such as minutes, email, feedback form, or permitted screenshot

Primary locations:

- [expert_feedback_template.md](expert_feedback_template.md)
- Section 14 of [consultancy_report.md](consultancy_report.md)
- Appendices with evidence

## Task 12: Final Consultancy Recommendations

Include recommendations for:

- Strategic action
- Operational action
- HR practice
- Data improvement
- Technology
- Risk management
- Ethical governance
- Future research

Every recommendation must identify:

1. Statistical evidence
2. Literature evidence
3. Industry expert evidence
4. Implementation owner and resources
5. Success measure
6. Risk and ethical controls

Primary locations:

- [recommendations.md](recommendations.md)
- Sections 15-19 of [consultancy_report.md](consultancy_report.md)

## Reproducibility

Run the complete R analysis from the project root:

```powershell
Rscript R/main.R
```

The generated outputs are saved in:

- `outputs/tables/`
- `outputs/figures/`
- `outputs/statistical_results/`
- `outputs/models/`

## Final submission checklist

- [ ] All report sections are written in complete paragraphs.
- [ ] Every table and figure has a title, source, and interpretation.
- [ ] Statistical findings are translated into organizational meaning.
- [ ] Causal language is avoided for observational data.
- [ ] At least 15 papers are verified and referenced consistently.
- [ ] Expert feedback is real and supported by evidence.
- [ ] Recommendations contain statistical, literature, and expert evidence.
- [ ] Group contributions are added.
- [ ] Presentation slides and speaker notes are completed.
- [ ] Viva questions have been rehearsed.
