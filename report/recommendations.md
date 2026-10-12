# Consultancy Recommendations

## Evidence status
Statistical evidence is generated in `outputs/`. Literature and expert evidence must be added only after verification and real consultation.

Every final recommendation must have three evidence fields. A recommendation is not fully supported until all available fields are completed or the missing evidence is explicitly reported as a limitation.

## Strategic
Use department-level absenteeism intelligence to support workforce planning and targeted investigation. Do not treat model output as proof of employee fault or cause.

## Operational
Monitor department and business-unit summaries, staffing pressure, and absenteeism trends. Prioritise groups with statistically reliable differences and meaningful effect sizes.

## HR
Use findings to guide supportive wellbeing, workload, scheduling, and return-to-work conversations. Apply human review and allow employees to challenge inaccurate records.

## Data
Validate age and service fields, record collection dates in future systems, define absenteeism measures, and document data lineage and retention.

## Technology
Implement a role-based dashboard showing trends, uncertainty, group summaries, model performance, and explanations. Avoid exposing unnecessary personally identifiable information.

## Risk management
Monitor drift, calibration, subgroup performance, missingness, and false positives. Establish model review and rollback procedures.

## Ethical
Use predictions for support and resource allocation, not automatic punishment, surveillance, or discrimination. Minimise personal data and secure access.

## Future research
Conduct sensitivity analyses, collect longitudinal data, validate with HR experts, and evaluate supportive interventions using a pre-registered CRD or blocked RCBD where ethical and feasible.

## Evidence mapping table
| Recommendation | Statistical evidence | Literature evidence | Expert evidence | Status |
|---|---|---|---|---|
| Supportive department-level planning | `group_summary.csv`, `hypothesis_results.csv`, `model_comparison.csv` | Literature review: decision support, manufacturing, and intervention evidence | Complete after expert consultation | Statistical and literature evidence available; expert evidence pending |
| Improve data quality | `data_validation.json`, `age_sensitivity_summary.csv`, `regression_diagnostics.csv` | Literature review: measurement and risk-factor limitations | Complete after expert consultation | Statistical evidence available; expert evidence pending |
| Use regularised prediction with human oversight | `model_comparison.csv`, `age_sensitivity_models.csv` | Literature review: predictive modelling and ethical limitations | Complete after expert consultation | Statistical and literature evidence available; expert evidence pending |
| Collect dated department-level records | No valid time variable in current data | Literature review: historical profiles and longitudinal occupational studies | Complete after expert consultation | Future proposal; expert evidence pending |
| Avoid punitive individual predictions | Observational design and model limitations | Literature review: risk factors, interventions, and ethical decision support | Complete after expert consultation | Ethical requirement; expert evidence pending |

## Recommendation writing format

For each final recommendation, use this structure:

**Recommendation:** State the action for senior management.

**Statistical evidence:** Cite the generated table, figure, test, effect size, model result, or limitation.

**Literature evidence:** Cite the verified paper(s) and explain the relevant finding or methodological lesson.

**Industry expert evidence:** Summarise the real expert's feedback and identify the evidence record.

**Implementation:** State owner, resources, timing, and success measure.

**Risk and ethics:** State privacy, fairness, misuse, uncertainty, and human-oversight controls.
