# Literature Review: Employee Absenteeism

## Evidence note
This review was prepared from the 18 PDF files supplied in `Research Papers/`. The papers address absenteeism determinants, occupational health, manufacturing, prediction, decision support, and workplace interventions. DOI and bibliographic verification is recorded in [citation_audit.md](citation_audit.md). The review does not treat file names as citations, and it does not invent DOI, sample-size, or method details that were not visible in the supplied article text.

## Introduction

Employee absenteeism is an organizational problem because absence can affect staffing continuity, workload distribution, productivity, service delivery, and employee wellbeing. However, absenteeism is not a single-factor outcome. The literature links absence to worker characteristics, physical and psychosocial working conditions, health, non-work stressors, job context, and organizational arrangements.

This creates two analytical challenges. Management needs to understand which observable groups or characteristics are associated with higher absence, while also ensuring that predictions are not treated as proof of employee fault. The literature therefore supports a consultancy approach that combines statistical inference, predictive modelling, organizational interpretation, and ethical governance. The present project follows this approach by analysing continuous `AbsentHours`, comparing interpretable and regularised regression, and evaluating how results could support workforce planning without punitive individual decisions.

## Literature landscape
The supplied literature falls into four connected streams:

1. **Determinants and risk factors:** systematic reviews and occupational-health studies examine worker, workplace, physical, psychosocial, health, and non-work factors associated with absence.
2. **Prediction and analytics:** recent studies apply machine learning, penalised regression, association analysis, network analysis, and decision-support tools to absenteeism prediction.
3. **Intervention and organizational action:** intervention reviews examine ways of reducing sickness absence and emphasise that prediction should connect to feasible, ethical support.
4. **Manufacturing and sector context:** manufacturing-focused work uses multilevel or workplace-level approaches to account for clustered employees and health-related factors.

## Paper inventory and relevance matrix

| File | Verified title | Authors shown in supplied PDF | Journal/source shown | Year shown | Main relevance | Method/finding to verify in full text |
|---|---|---|---|---:|---|---|
| `1-s2.0-S2590005626000895-main.pdf` | Predicting employee absenteeism: A framework and its validation | Rashid Anzoom; Syed Mithun Ali; Prattusha Bhattacharjee; Golam Kabir; Sanjoy Kumar Paul | Article PDF; journal metadata to verify | 2026 | Recent predictive framework and validation; highly relevant to the consultancy framework | Confirm dataset, target definition, algorithms, validation design, and final performance claims |
| `IJITIS_164.pdf` | Data-Driven Predictive Modelling of Employee Absenteeism Using Workflow Automation Platforms | Mohammed Alars; Abbas Albakry | International Journal of Innovative Technology and Interdisciplinary Sciences | 2026 issue; received/accepted dates shown | Directly relevant predictive modelling and workflow implementation; the abstract states an enterprise dataset of 8,336 employees | Verify peer-review status, dataset provenance, binary target definition, variables, and performance results |
| `Predicting_Absenteeism_at_Workplace_Using_Machine_.pdf` | Predicting Absenteeism at Workplace Using Machine Learning and Network Analysis | Donggeun Kim; Jai Woo Lee | SAGE Open | 2025 | Directly relevant; combines association analysis, odds ratios, network analysis, PCA, penalised regression, and imbalanced classification | Verify exact sample, variables, algorithms, validation, and whether PCA improved prediction |
| `s12995-025-00482-5.pdf` | Title and metadata to be transcribed from article cover | Authors and journal metadata to be transcribed | Journal article PDF | 2025 shown in filename/cover context | Recent occupational-health evidence likely relevant to absenteeism and wellbeing | Read full article and verify title, objective, sample, method, and findings before citation |
| `Predicting_Employee_Absence_from_Historical_Absenc.pdf` | Predicting Employee Absence from Historical Absence Profiles with Machine Learning | Peter Zupancic; Pan Panov | Applied Sciences | 2024 | Uses historical time-and-attendance and employee demographic data; relevant to future longitudinal/time-series data collection | Verify target construction, temporal split, models, and limitations |
| `s12144-022-03013-1.pdf` | Presenteeism and absenteeism in the manufacturing sector: A multilevel approach identifying underlying factors and relations to health | Joshua Nowak and co-authors | Current Psychology | 2023 | Direct manufacturing-sector relevance; supports multilevel thinking and health-related interpretation | Verify sample, hierarchical structure, variables, model specification, and findings |
| `information-13-00320.pdf` | Incorporating a Machine Learning Model into a Web-Based Administrative Decision Support Tool for Predicting Workplace Absenteeism | Gopal Nath; Yawei Wang; Austin Coursey; Krishna K. Saha; Srikanth Prabhu; Saptarshi Sengupta | Information | 2022 | Supports the proposed dashboard and decision-support framework | Verify data, target definition, model comparison, interface, validation, and practical limitations |
| `oemed-2020-106554.pdf` | Associations between physical and psychosocial work environment factors and sickness absence incidence depend on the lengths of the sickness absence episodes: a prospective study of 27,678 Danish employees | Sannie V. Thorsen; Mari-Ann Flyvholm; Jacob Pedersen; Ute Bültmann; Lars L. Andersen; Jakob Bue Bjorner | Occupational and Environmental Medicine | 2021 | Strong evidence that work-environment associations may vary by absence-episode length; supports cautious interpretation of a single continuous target | Verify statistical model, episode definitions, covariates, and limitations |
| `Predicting_employee_absenteeism_for_cost_effective.pdf` | Predicting employee absenteeism for cost effective interventions | Natalie Lawrance; George Petrides; Marie-Anne Guerry | Decision Support Systems | 2021 | Directly links prediction to cost-effective intervention rather than accuracy alone | Verify dataset, cost model, algorithms, validation, and intervention recommendations |
| `fpubh-11-1326334.pdf` | Evaluation of physical and mental health conditions related to employees’ absenteeism | Kazumitsu Nawata | Frontiers in Public Health | 2023 issue indicated by filename | Supports health and wellbeing interpretation of absence-related variables | Verify study design, population, health variables, statistical methods, and causal limitations |
| `ijerph-18-11214.pdf` | Exploratory Analysis of Related Factors with Absenteeism and Presenteeism on Workers: Using the Fourth Korea Working Condition Survey | Young-Hyeon Bae and co-authors | International Journal of Environmental Research and Public Health | 2021 issue indicated by volume | Supports exploratory factor analysis using worker and workplace conditions | Verify sample, survey design, regression/association methods, and findings |
| `ijerph-17-06132.pdf` | Unplanned Absenteeism: The Role of Workplace and Non-Workplace Stressors | Nur Adibah Mat Saruan; Hanizah Mohd Yusoff; Mohd Fadhli Mohd Fauzi; Sharifa Ezat Wan Puteh and co-authors | International Journal of Environmental Research and Public Health | 2020 issue indicated by volume | Supports inclusion of workplace and non-workplace stressors in the research landscape | Verify sample, measures, model, and study limitations |
| `fpsyg-13-958748.pdf` | Revealing underlying factors of absenteeism: A machine learning approach | Francis Bowen; Carolyn Gentle-Genitty; Janaina Siegler; Marlin Jackson | Frontiers in Psychology | 2022 issue indicated by article identifier | Supports machine-learning exploration of absenteeism factors | Verify dataset, feature construction, algorithms, validation, and interpretability |
| `socsci-07-00120.pdf` | The Determinants and Outcomes of Absence Behavior: A Systematic Literature Review | Vedrana Cikes; Helga Maskarin Ribaric; Kristina Crnjar | Social Sciences | 2018 issue indicated by volume | Provides broad theoretical synthesis of determinants and outcomes | Verify review search strategy, included studies, findings, and research gaps |
| `wagner-et-al-2014-modifiable-worker-risk-factors-contributing-to-workplace-absence-a-stakeholder-centred-best-evidence.pdf` | Modifiable worker risk factors contributing to workplace absence: A stakeholder-centred best-evidence synthesis of systematic reviews | Shannon Wagner; Marc White; Izabela Z. and co-authors | Work | 2014 | Supports stakeholder-centred identification of modifiable risk factors and intervention design | Verify complete author list, review method, evidence grading, and findings |
| `white-et-al-2015-non-modifiable-worker-and-workplace-risk-factors-contributing-to-workplace-absence-a-stakeholder.pdf` | Non-modifiable worker and workplace risk factors contributing to workplace absence: A stakeholder-centred synthesis of systematic reviews | Marc I. White; Shannon L. Wagner; Izabela Z. and co-authors | Work | 2015 | Supports separation of non-modifiable characteristics from intervention targets | Verify complete author list, review method, risk-factor categories, and findings |
| `kqs198.pdf` | Systematic review of active workplace interventions to reduce sickness absence | M. Odeen; L. H. Magnussen; S. Maeland; L. Larun; H. R. Eriksen; T. H. Tveito | Occupational Medicine | 2013 | Supports CRD/RCBD discussion and the need to connect analytics to evaluated interventions | Verify included interventions, evidence quality, outcomes, and conclusions |
| `yoi200013supp1_prod.pdf` | Supplementary content for *Psychosocial Stressors at Work and the Risk of Sickness Absence Due to a Diagnosed Mental Disorder: A Systematic Review and Meta-analysis* | C. S. Duchaine; K. Aubé; M. Gilbert-Ouimet and co-authors | JAMA Psychiatry supplementary content | 2020 | Supports psychosocial-risk and mental-health context | Cite the main article once using DOI `10.1001/jamapsychiatry.2020.0322`; do not count the supplement as a separate paper |

## Critical synthesis

### Methodological patterns
The papers show a movement from descriptive and occupational-health research toward predictive analytics and decision-support systems. Recent prediction studies use machine learning, penalised regression, association analysis, network analysis, PCA, historical absence profiles, and web-based tools. This supports comparing interpretable linear regression with Ridge, LASSO, and Elastic Net in the present consultancy rather than treating accuracy as the only criterion.

### Determinants and risk factors
The review literature presents absenteeism as a multidimensional organizational outcome. Wagner et al. focus on modifiable worker risk factors, while White et al. distinguish non-modifiable worker and workplace factors. Cikes et al. provide a broader synthesis of determinants and outcomes. Together, these papers imply that organizations should distinguish between characteristics that describe differences in absence and factors that can realistically be changed through intervention.

The occupational-health studies extend this argument by emphasizing physical, psychosocial, and health-related conditions. Thorsen et al. report that work-environment associations may depend on the length of absence episodes. Saruan et al. examine workplace and non-workplace stressors, while Nawata considers physical and mental health conditions. These findings suggest that a single aggregate measure such as `AbsentHours` may combine different types of absence. The present analysis should therefore treat `AbsentHours` as an overall outcome and identify episode type, cause, and time period as important future data requirements.

### Prediction and decision support
The prediction studies show increasing interest in machine learning and operational decision support. Bowen et al. use machine learning to investigate underlying absenteeism factors. Kim and Lee combine association analysis, network analysis, PCA, and penalised modelling. Zupancic and Panov focus on historical absence profiles, which is relevant to future longitudinal attendance data. Nath et al. connect prediction to a web-based administrative decision-support tool, while Lawrance et al. frame prediction around cost-effective interventions.

These studies justify comparing several models in the present project. Regularised models may improve predictive stability when categorical variables are encoded into many related predictors, while multiple linear regression provides a more direct inferential baseline. The final recommendation should therefore consider test error, cross-validation stability, coefficient behaviour, assumptions, transparency, and the consequences of operational use.

### Manufacturing and multilevel context
Nowak et al. address absenteeism and presenteeism in manufacturing using a multilevel perspective. This is relevant because employees may be clustered within departments, locations, job categories, or work environments. Employees in the same unit may share schedules, supervisors, workloads, and physical conditions.

The current dataset does not provide enough repeated or contextual information to claim a full multilevel causal analysis. It does contain department, division, store location, business unit, and job-title variables. The project can therefore conduct cautious group comparisons and regression modelling while identifying hierarchical modelling as a future extension.

### Interventions and experimental evidence
Odeen et al. review active workplace interventions to reduce sickness absence. This is important because prediction is useful only when it informs a feasible response. A future CRD could evaluate a supportive intervention against a control condition, while an RCBD could randomise within departments or locations to account for known organizational differences.

The intervention literature also creates an ethical constraint. Absence-reduction interventions should not become surveillance or punishment. They should address staffing, workload, wellbeing, work design, or access to support, with safeguards against coercion, contamination, unequal access, and stigmatization.

### Methodological tensions
Four tensions recur across the literature:

1. **Explanation versus prediction:** occupational-health studies often prioritize interpretable associations, while machine-learning studies may prioritize prediction performance.
2. **Continuous versus categorical outcomes:** binary high-risk labels simplify decisions but can discard information and introduce threshold sensitivity.
3. **Individual versus organizational intervention:** individual predictions may be operationally attractive but create greater privacy and fairness risks than department-level planning.
4. **Cross-sectional versus longitudinal evidence:** cross-sectional data identify associations, while historical and prospective data are needed for temporal ordering, recurrence, forecasting, and intervention evaluation.

The present consultancy retains these tensions rather than claiming that one method is universally superior. It uses a continuous target, compares regularised regression with an interpretable baseline, evaluates PCA rather than assuming it is necessary, and treats Bayesian, time-series, and experimental methods as conditional extensions.

### Key strengths in prior work
- Large or longitudinal samples in several occupational-health studies.
- Use of prospective or multilevel designs in some studies.
- Explicit connection between prediction and intervention in decision-support research.
- Recognition that absence is influenced by health, psychosocial, physical, workplace, and non-work factors.

### Key limitations and gaps
- Many studies use different definitions of absence, making direct comparison difficult.
- Classification targets may discard information contained in a continuous absence-hours measure.
- Predictive studies may not provide enough explanation for HR decision-making.
- Cross-sectional employee data cannot establish causality.
- Individual-level prediction raises privacy, fairness, and punitive-misuse risks.
- The current dataset has no time variable, so temporal forecasting cannot be claimed.
- The current dataset contains implausible ages that require sensitivity analysis.

### Contribution of this consultancy project
This project addresses the identified gap by combining: (1) explicit data-quality auditing, (2) continuous `AbsentHours` modelling, (3) robust group comparisons, (4) interpretable and regularised regression, (5) critical PCA/Bayesian evaluation, and (6) an ethical decision-support proposal. It should report associations and predictive performance without claiming that demographic or organizational variables cause absence.

## Research gap and project contribution

The reviewed studies leave a practical gap for an organization that has employee-level records but lacks detailed absence dates, absence causes, intervention history, and repeated measurements. Such an organization needs an approach that is statistically defensible but understandable to HR and operations managers. It must also separate descriptive evidence from causal claims and prevent individual-level predictions from becoming automatic disciplinary decisions.

This consultancy addresses that gap by combining data-quality auditing, continuous `AbsentHours` modelling, robust group comparisons, interpretable and regularised regression, critical evaluation of PCA and Bayesian methods, and an ethical decision-support proposal. The contribution is not to claim a universal absenteeism model. It is to demonstrate a reproducible workflow for deciding what the available data can support, what it cannot support, and what additional data or experimental design would be required for stronger organizational decisions.

## Analytical framework justified by the literature

The literature supports the following sequence:

1. Audit the dataset and identify invalid or implausible records.
2. Describe the distribution of `AbsentHours` and the composition of employee groups.
3. Test differences between meaningful groups using robust methods when variances or group sizes are unequal.
4. Examine age and service-length relationships using Pearson or Spearman correlation as appropriate.
5. Compare multiple linear regression with Ridge, LASSO, and Elastic Net using leakage-safe preprocessing and cross-validation.
6. Evaluate residual assumptions, multicollinearity, model stability, and sensitivity to flagged records.
7. Translate reliable results into aggregate workforce planning and supportive intervention recommendations.

This framework is consistent with the literature's combined emphasis on risk-factor understanding, predictive validation, intervention feasibility, and ethical organizational use.

## Citation audit before submission
- Use [citation_audit.md](citation_audit.md) as the record of DOI and metadata verification.
- Confirm journal peer-review policies or article types before counting sources toward the assignment requirement.
- Resolve the Anzoom et al. publisher record before citing or counting that paper.
- Confirm that at least five papers fall within the lecturer's definition of the last five years.
- Read each paper's method and results sections before stating numerical findings.
- Add the final reference style consistently to the consultancy report.
