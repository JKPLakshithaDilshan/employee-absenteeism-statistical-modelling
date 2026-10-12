required_packages <- c("readr", "dplyr", "tidyr", "tibble", "ggplot2", "jsonlite", "glmnet")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages) > 0) {
  stop("Missing packages: ", paste(missing_packages, collapse = ", "), ". Install them with install.packages().")
}

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(ggplot2)
  library(jsonlite)
})

ROOT <- normalizePath(getwd(), mustWork = FALSE)
if (!file.exists(file.path(ROOT, "data", "raw", "MFGEmployees4.csv"))) {
  ROOT <- normalizePath(file.path(ROOT, ".."), mustWork = FALSE)
}
DATA_PATH <- file.path(ROOT, "data", "raw", "MFGEmployees4.csv")
OUTPUTS <- file.path(ROOT, "outputs")
TARGET <- "AbsentHours"
EXPECTED_COLUMNS <- c("EmployeeNumber", "Surname", "GivenName", "Gender", "City", "JobTitle",
                      "DepartmentName", "StoreLocation", "Division", "Age", "LengthService",
                      "AbsentHours", "BusinessUnit")
GROUPING_COLUMNS <- c("Gender", "DepartmentName", "Division", "BusinessUnit")
CATEGORICAL_PREDICTORS <- c("Gender", "City", "JobTitle", "DepartmentName", "StoreLocation", "Division", "BusinessUnit")

make_output_dirs <- function() {
  dir.create(file.path(OUTPUTS, "figures"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(OUTPUTS, "tables"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(OUTPUTS, "statistical_results"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(OUTPUTS, "models"), recursive = TRUE, showWarnings = FALSE)
}

load_data <- function(path) {
  if (!file.exists(path)) stop("Dataset not found: ", path)
  data <- readr::read_csv(path, show_col_types = FALSE)
  missing <- setdiff(EXPECTED_COLUMNS, names(data))
  unexpected <- setdiff(names(data), EXPECTED_COLUMNS)
  if (length(missing) > 0 || length(unexpected) > 0) {
    stop("Schema mismatch. Missing=", paste(missing, collapse = ", "),
         "; unexpected=", paste(unexpected, collapse = ", "))
  }
  data %>% select(all_of(EXPECTED_COLUMNS))
}

validate_data <- function(data) {
  numeric_data <- data %>% select(where(is.numeric))
  target <- data[[TARGET]]
  list(
    shape = c(nrow(data), ncol(data)), columns = names(data),
    dtypes = vapply(data, function(x) class(x)[1], character(1)),
    missing_values = lapply(data, function(x) sum(is.na(x))),
    duplicate_rows = sum(duplicated(data)),
    duplicate_employee_numbers = sum(duplicated(data$EmployeeNumber)),
    unique_counts = lapply(data, function(x) n_distinct(x, na.rm = FALSE)),
    negative_numeric_values = lapply(numeric_data, function(x) sum(x < 0, na.rm = TRUE)),
    impossible_age_records = sum(data$Age < 15 | data$Age > 100, na.rm = TRUE),
    service_greater_than_age = sum(data$LengthService > data$Age, na.rm = TRUE),
    zero_absent_hours = sum(target == 0, na.rm = TRUE),
    target_iqr_high_outliers = sum(target > quantile(target, .75, na.rm = TRUE) +
      1.5 * IQR(target, na.rm = TRUE), na.rm = TRUE)
  )
}

numerical_summary <- function(data) {
  columns <- c("Age", "LengthService", TARGET)
  bind_rows(lapply(columns, function(column) {
    values <- data[[column]]
    tibble(Variable = column, Count = sum(!is.na(values)), Mean = mean(values, na.rm = TRUE),
           Median = median(values, na.rm = TRUE), StdDev = sd(values, na.rm = TRUE),
           Variance = var(values, na.rm = TRUE), Minimum = min(values, na.rm = TRUE),
           Maximum = max(values, na.rm = TRUE), Q1 = unname(quantile(values, .25, na.rm = TRUE)),
           Q3 = unname(quantile(values, .75, na.rm = TRUE)), IQR = IQR(values, na.rm = TRUE),
           Skew = mean((values - mean(values, na.rm = TRUE))^3, na.rm = TRUE) / sd(values, na.rm = TRUE)^3)
  }))
}

categorical_summary <- function(data) {
  data %>% select(where(~ !is.numeric(.x))) %>% pivot_longer(everything(), names_to = "Variable", values_to = "Category") %>%
    mutate(Category = replace_na(as.character(Category), "NA")) %>% count(Variable, Category, name = "Frequency") %>%
    group_by(Variable) %>% mutate(Percentage = Frequency / sum(Frequency) * 100) %>% ungroup()
}

group_summary <- function(data) {
  bind_rows(lapply(GROUPING_COLUMNS, function(column) {
    data %>% group_by(.data[[column]]) %>% summarise(Count = sum(!is.na(.data[[TARGET]])),
      Mean = mean(.data[[TARGET]], na.rm = TRUE), Median = median(.data[[TARGET]], na.rm = TRUE),
      StdDev = sd(.data[[TARGET]], na.rm = TRUE), .groups = "drop") %>%
      rename(Group = all_of(column)) %>% mutate(GroupingVariable = column, .before = 1)
  }))
}

target_summary <- function(data) {
  target <- data[[TARGET]]
  tibble(mean = mean(target, na.rm = TRUE), median = median(target, na.rm = TRUE),
         std = sd(target, na.rm = TRUE), skewness = mean((target - mean(target, na.rm = TRUE))^3, na.rm = TRUE) /
           sd(target, na.rm = TRUE)^3, zero_percentage = mean(target == 0, na.rm = TRUE) * 100,
         coefficient_of_variation = sd(target, na.rm = TRUE) / mean(target, na.rm = TRUE))
}

correlation_results <- function(data) {
  bind_rows(lapply(c("Age", "LengthService"), function(variable) {
    complete <- data %>% select(x = all_of(variable), y = all_of(TARGET)) %>% drop_na()
    pearson <- cor.test(complete$x, complete$y, method = "pearson")
    spearman <- cor.test(complete$x, complete$y, method = "spearman", exact = FALSE)
        tibble(Method = c("pearson", "spearman"), Variable1 = variable, Variable2 = TARGET,
           Correlation = c(unname(pearson$estimate), unname(spearman$estimate)),
          PValue = c(pearson$p.value, spearman$p.value),
          CILower = c(pearson$conf.int[1], NA_real_), CIUpper = c(pearson$conf.int[2], NA_real_),
          Alpha = .05)
  }))
}

group_tests <- function(data) {
  inference <- list(); posthoc <- list()
  for (column in GROUPING_COLUMNS) {
    groups <- split(data[[TARGET]], data[[column]])
    groups <- groups[vapply(groups, length, integer(1)) >= 10]
    if (length(groups) < 2) next
    long <- data.frame(value = unlist(groups), group = rep(names(groups), lengths(groups)))
    levene <- oneway.test(abs(long$value - ave(long$value, long$group, FUN = median)) ~ long$group)
    welch <- oneway.test(value ~ group, data = long, var.equal = FALSE)
    kruskal <- kruskal.test(value ~ group, data = long)
    eta_squared <- sum(vapply(groups, function(values) length(values) * (mean(values) - mean(long$value))^2, numeric(1))) /
      sum((long$value - mean(long$value))^2)
    inference[[length(inference) + 1]] <- tibble(Variable = column,
      NullHypothesis = paste0("Mean absent hours are equal across included ", column, " groups"),
      AlternativeHypothesis = paste0("At least one ", column, " group mean differs"),
      Alpha = .05, GroupsIncluded = length(groups),
      LeveneStatistic = unname(levene$statistic), LevenePValue = levene$p.value,
      WelchStatistic = unname(welch$statistic), WelchPValue = welch$p.value,
      KruskalStatistic = unname(kruskal$statistic), KruskalPValue = kruskal$p.value,
      EtaSquared = eta_squared, Decision = ifelse(welch$p.value < .05, "Reject H0", "Fail to reject H0"))
    if (welch$p.value < .05) {
      pairs <- combn(names(groups), 2)
      posthoc[[length(posthoc) + 1]] <- bind_rows(lapply(seq_len(ncol(pairs)), function(i) {
        test <- t.test(groups[[pairs[1, i]]], groups[[pairs[2, i]]], var.equal = FALSE)
         pooled_sd <- sqrt(((length(groups[[pairs[1, i]]]) - 1) * var(groups[[pairs[1, i]]]) +
           (length(groups[[pairs[2, i]]]) - 1) * var(groups[[pairs[2, i]]])) /
           (length(groups[[pairs[1, i]]]) + length(groups[[pairs[2, i]]]) - 2))
         tibble(Variable = column, Group1 = pairs[1, i], Group2 = pairs[2, i],
           Statistic = unname(test$statistic), RawPValue = test$p.value,
           MeanDifference = mean(groups[[pairs[1, i]]]) - mean(groups[[pairs[2, i]]]),
           CILower = test$conf.int[1], CIUpper = test$conf.int[2],
           CohenD = (mean(groups[[pairs[1, i]]]) - mean(groups[[pairs[2, i]]])) / pooled_sd)
      }))
    }
  }
  posthoc_data <- if (length(posthoc)) bind_rows(posthoc) else tibble(Variable = character(), Group1 = character(),
    Group2 = character(), Statistic = numeric(), RawPValue = numeric())
  if (nrow(posthoc_data)) {
    posthoc_data$AdjustedPValue <- p.adjust(posthoc_data$RawPValue, method = "holm")
    posthoc_data$Decision <- ifelse(posthoc_data$AdjustedPValue < .05, "Reject H0", "Fail to reject H0")
  }
  list(inference = if (length(inference)) bind_rows(inference) else tibble(), posthoc = posthoc_data)
}

write_plot <- function(plot, filename, width = 8, height = 5) {
  ggsave(file.path(OUTPUTS, "figures", filename), plot, width = width, height = height, dpi = 220)
}

run_visualizations <- function(data) {
  write_plot(ggplot(data, aes(.data[[TARGET]])) + geom_histogram(bins = 35, fill = "#176B87") +
    labs(title = "Distribution of employee absenteeism", x = "Absent hours", y = "Employees") + theme_minimal(),
    "absent_hours_distribution.png")
  write_plot(ggplot(data, aes(Age, .data[[TARGET]])) + geom_point(alpha = .25, color = "#176B87") +
    labs(title = "Age and absent hours", x = "Age (years)", y = "Absent hours") + theme_minimal(), "numeric_relationships.png")
  write_plot(ggplot(data, aes(Gender, .data[[TARGET]])) + geom_boxplot(fill = "#F2A65A") +
    labs(title = "Absent hours by gender", x = "Gender", y = "Absent hours") + theme_minimal(), "absenteeism_by_gender.png")
  correlation <- cor(data[c("Age", "LengthService", TARGET)], use = "complete.obs", method = "spearman")
  heat <- as.data.frame(as.table(correlation))
  write_plot(ggplot(heat, aes(Var1, Var2, fill = Freq)) + geom_tile() + geom_text(aes(label = round(Freq, 2))) +
    scale_fill_gradient2(limits = c(-1, 1), low = "#D95F59", mid = "white", high = "#176B87") +
    labs(title = "Spearman correlation matrix", x = NULL, y = NULL) + theme_minimal(), "correlation_heatmap.png")
  for (column in c("DepartmentName", "Division", "BusinessUnit")) {
    means <- data %>% group_by(.data[[column]]) %>% summarise(Mean = mean(.data[[TARGET]], na.rm = TRUE), .groups = "drop")
    plot <- ggplot(means, aes(reorder(.data[[column]], Mean), Mean)) + geom_col(fill = "#3B8EA5") + coord_flip() +
      labs(title = paste("Mean absent hours by", column), x = column, y = "Mean absent hours") + theme_minimal()
    write_plot(plot, paste0("mean_absenteeism_by_", tolower(column), ".png"), 10, max(4, nrow(means) * .35))
  }
}

design_matrix <- function(data) {
  formula <- as.formula(paste(TARGET, "~ Age + LengthService +", paste(CATEGORICAL_PREDICTORS, collapse = " + ")))
  model.matrix(formula, data = data)[, -1, drop = FALSE]
}

metrics <- function(actual, predicted) {
  c(MAE = mean(abs(actual - predicted)), RMSE = sqrt(mean((actual - predicted)^2)),
    R2 = 1 - sum((actual - predicted)^2) / sum((actual - mean(actual))^2))
}

fit_models <- function(data, seed = 42) {
  clean <- data %>% drop_na(all_of(c(TARGET, "Age", "LengthService", CATEGORICAL_PREDICTORS)))
  set.seed(seed); test_indices <- sample(seq_len(nrow(clean)), floor(.2 * nrow(clean)))
  x <- design_matrix(clean); y <- clean[[TARGET]]
  x_train <- x[-test_indices, , drop = FALSE]; x_test <- x[test_indices, , drop = FALSE]
  y_train <- y[-test_indices]; y_test <- y[test_indices]
  model_specs <- list(MultipleLinearRegression = list(alpha = NULL, lambda = 0), Ridge = list(alpha = 0, lambda = 10),
                      LASSO = list(alpha = 1, lambda = .05), ElasticNet = list(alpha = .5, lambda = .05))
  fit_predict <- function(name, train_x, train_y, new_x) {
    spec <- model_specs[[name]]
    if (is.null(spec$alpha)) {
      fitted <- lm.fit(cbind(1, train_x), train_y)$coefficients
      fitted[is.na(fitted)] <- 0
      as.numeric(cbind(1, new_x) %*% fitted)
    } else {
      fitted <- glmnet::glmnet(train_x, train_y, alpha = spec$alpha, lambda = spec$lambda, standardize = TRUE)
      as.numeric(predict(fitted, newx = new_x, s = spec$lambda))
    }
  }
  folds <- sample(rep(1:5, length.out = nrow(x_train)))
  rows <- lapply(names(model_specs), function(name) {
    spec <- model_specs[[name]]
    cv_predictions <- numeric(length(y_train))
    for (fold in 1:5) {
      training <- folds != fold
      cv_predictions[!training] <- fit_predict(name, x_train[training, , drop = FALSE], y_train[training],
        x_train[!training, , drop = FALSE])
    }
    prediction <- fit_predict(name, x_train, y_train, x_test)
    test_metrics <- metrics(y_test, prediction)
    tibble(Model = name, CV_MAE = mean(abs(y_train - cv_predictions)), CV_RMSE = sqrt(mean((y_train - cv_predictions)^2)),
           Test_MAE = test_metrics["MAE"], Test_RMSE = test_metrics["RMSE"], Test_R2 = test_metrics["R2"],
           Interpretability = ifelse(name == "MultipleLinearRegression", "High", "Moderate"))
  })
  bind_rows(rows) %>% arrange(Test_RMSE)
}

ols_model <- function(data) lm(as.formula(paste(TARGET, "~ Age + LengthService")), data = data)

regression_diagnostics <- function(data) {
  clean <- data %>% select(all_of(c(TARGET, "Age", "LengthService"))) %>% drop_na()
  model <- ols_model(clean); residual_values <- residuals(model); fitted_values <- fitted(model)
  auxiliary <- lm(I(residual_values^2) ~ clean$Age + clean$LengthService)
  bp_statistic <- nrow(clean) * summary(auxiliary)$r.squared
  jb_statistic <- nrow(clean) / 6 * (mean((residual_values - mean(residual_values))^3) / sd(residual_values)^3)^2 +
    nrow(clean) / 24 * (mean((residual_values - mean(residual_values))^4) / sd(residual_values)^4 - 3)^2
  coefficients <- as.data.frame(confint(model)) %>% rownames_to_column("Term") %>%
    rename(CILower = `2.5 %`, CIUpper = `97.5 %`) %>% mutate(Estimate = coef(model), PValue = summary(model)$coefficients[, 4])
  influence <- cooks.distance(model); leverage <- hatvalues(model)
  diagnostics <- tibble(Model = "OLS: Age + LengthService", Observations = nobs(model), R2 = summary(model)$r.squared,
    AdjustedR2 = summary(model)$adj.r.squared, BreuschPaganLM = bp_statistic,
    BreuschPaganPValue = pchisq(bp_statistic, df = 2, lower.tail = FALSE), BreuschPaganF = NA_real_, BreuschPaganFPValue = NA_real_,
    JarqueBera = jb_statistic, JarqueBeraPValue = pchisq(jb_statistic, df = 2, lower.tail = FALSE), ResidualSkewness = mean((residual_values - mean(residual_values))^3) / sd(residual_values)^3,
    ResidualKurtosis = mean((residual_values - mean(residual_values))^4) / sd(residual_values)^4,
    DurbinWatson = sum(diff(residual_values)^2) / sum(residual_values^2), MaxCookDistance = max(influence),
    HighLeverageCount = sum(leverage > 2 * length(coef(model)) / nrow(clean)))
  residual_table <- tibble(Fitted = fitted_values, Residual = residual_values, StandardizedResidual = rstandard(model), CookDistance = influence)
  list(diagnostics = diagnostics, residuals = residual_table, model = model, coefficients = coefficients)
}

run_pca <- function(data) {
  values <- data %>% select(Age, LengthService, all_of(TARGET)) %>% drop_na()
  pca <- prcomp(values, scale. = TRUE); explained <- pca$sdev^2 / sum(pca$sdev^2)
  result <- tibble(Component = seq_along(explained), ExplainedVariance = explained, CumulativeExplainedVariance = cumsum(explained))
  comparison_data <- data %>% select(all_of(c(TARGET, "Age", "LengthService"))) %>% drop_na()
  baseline <- summary(lm(as.formula(paste(TARGET, "~ Age + LengthService")), data = comparison_data))
  pc_values <- as.data.frame(pca$x[, 1:2, drop = FALSE])
  pc_values[[TARGET]] <- comparison_data[[TARGET]]
  pc_model <- summary(lm(as.formula(paste(TARGET, "~ PC1 + PC2")), data = pc_values))
  comparison <- tibble(Model = c("Numeric baseline: Age + LengthService", "PCA: PC1 + PC2"),
    R2 = c(baseline$r.squared, pc_model$r.squared), AdjustedR2 = c(baseline$adj.r.squared, pc_model$adj.r.squared),
    Recommendation = c("Retain original variables for interpretability", "Use only if dimension reduction is necessary"))
  write_csv(comparison, file.path(OUTPUTS, "tables", "pca_model_comparison.csv"))
  write_plot(ggplot(result, aes(Component, CumulativeExplainedVariance)) + geom_line(color = "#176B87") + geom_point(color = "#176B87") +
    geom_hline(yintercept = .8, linetype = "dashed", color = "#D95F59") + labs(title = "PCA cumulative explained variance", x = "Principal component", y = "Cumulative explained variance") + theme_minimal(),
    "pca_scree_cumulative.png", 7, 4)
  attr(result, "model_comparison") <- comparison
  result
}

bayesian_evaluation <- function() {
  list(Status = "evaluated_not_fitted", Outcome = TARGET,
    NaiveBayes = "Not suitable as the primary method because it is a classification model while AbsentHours is continuous.",
    BayesianRegression = list(Likelihood = "Normal or Student-t regression for continuous AbsentHours",
      Priors = "Weakly informative Normal(0, 10) coefficients and half-Normal(0, 10) residual scale after standardisation",
      Posterior = "Would provide coefficient posterior distributions and 95% credible intervals",
      Sensitivity = "Compare weakly informative priors with tighter Normal(0, 2.5) priors"),
    DecisionMaking = "Use posterior predictive distributions for aggregate staffing decisions, not automatic individual sanctions.",
    Advantages = "Prior information, uncertainty propagation, partial pooling, and direct probability statements.",
    Limitations = "Requires justified priors, MCMC diagnostics, computation, and longitudinal or contextual data for hierarchical extensions.",
    ReasonNotFitted = "The assignment requires critical evaluation; no defensible prior elicitation or approved organizational decision threshold is available.")
}

run_age_sensitivity <- function(data) {
  flagged <- data$Age < 15 | data$Age > 100 | data$LengthService > data$Age
  subsets <- list("All records" = data, "Exclude flagged age/service records" = data[!flagged, ])
  rows <- lapply(subsets, function(subset) {
    model <- ols_model(subset); summary_data <- target_summary(subset)
    tibble(Records = nrow(subset), MeanAbsentHours = summary_data$mean, MedianAbsentHours = summary_data$median,
      AgeAbsentHoursPearsonR = cor(subset$Age, subset[[TARGET]], use = "complete.obs"), AgeCoefficient = coef(model)["Age"],
      AgePValue = summary(model)$coefficients["Age", "Pr(>|t|)"], OLS_R2 = summary(model)$r.squared)
  })
  summary_data <- bind_rows(rows, .id = "AnalysisSet") %>% mutate(FlaggedRecordsExcluded = ifelse(AnalysisSet == "All records", 0, sum(flagged)))
  model_data <- bind_rows(lapply(names(subsets), function(label) fit_models(subsets[[label]]) %>% mutate(AnalysisSet = label, .before = 1)))
  list(summary = summary_data, models = model_data)
}

run_pipeline <- function() {
  make_output_dirs(); data <- load_data(DATA_PATH); validation <- validate_data(data)
  write_json(validation, file.path(OUTPUTS, "statistical_results", "data_validation.json"), pretty = TRUE, auto_unbox = TRUE)
  write_csv(numerical_summary(data), file.path(OUTPUTS, "tables", "descriptive_statistics.csv"))
  write_csv(categorical_summary(data), file.path(OUTPUTS, "tables", "categorical_summary.csv"))
  write_csv(group_summary(data), file.path(OUTPUTS, "tables", "group_summary.csv"))
  write_csv(correlation_results(data), file.path(OUTPUTS, "tables", "correlation_results.csv"))
  tests <- group_tests(data); write_csv(tests$inference, file.path(OUTPUTS, "tables", "hypothesis_results.csv")); write_csv(tests$posthoc, file.path(OUTPUTS, "tables", "posthoc_results.csv"))
  vif_values <- 1 / (1 - sapply(c("Age", "LengthService"), function(x) summary(lm(reformulate(setdiff(c("Age", "LengthService"), x), x), data = data))$r.squared))
  write_csv(tibble(Variable = c("constant", "Age", "LengthService"), VIF = c(NA, vif_values)), file.path(OUTPUTS, "tables", "vif_results.csv"))
  run_visualizations(data); pca <- run_pca(data); write_csv(pca, file.path(OUTPUTS, "tables", "pca_results.csv"))
  model_comparison <- fit_models(data); write_csv(model_comparison, file.path(OUTPUTS, "tables", "model_comparison.csv"))
  diagnostics <- regression_diagnostics(data); capture.output(summary(diagnostics$model), file = file.path(OUTPUTS, "models", "ols_summary.txt")); write_csv(diagnostics$diagnostics, file.path(OUTPUTS, "tables", "regression_diagnostics.csv")); write_csv(diagnostics$residuals, file.path(OUTPUTS, "tables", "residual_observations.csv")); write_csv(diagnostics$coefficients, file.path(OUTPUTS, "tables", "ols_coefficients.csv"))
  write_plot(ggplot(diagnostics$residuals, aes(Fitted, Residual)) + geom_point(alpha = .35, color = "#176B87") + geom_hline(yintercept = 0, linetype = "dashed", color = "#D95F59") + theme_minimal() + labs(title = "Residuals versus fitted values"), "regression_residual_diagnostics.png")
  write_plot(ggplot(diagnostics$residuals, aes(sample = Residual)) + stat_qq(color = "#176B87") + stat_qq_line() + theme_minimal() + labs(title = "OLS residual Q-Q plot"), "regression_residual_qq.png", 7, 5)
  sensitivity <- run_age_sensitivity(data); write_csv(sensitivity$summary, file.path(OUTPUTS, "tables", "age_sensitivity_summary.csv")); write_csv(sensitivity$models, file.path(OUTPUTS, "tables", "age_sensitivity_models.csv"))
  write_json(bayesian_evaluation(), file.path(OUTPUTS, "statistical_results", "bayesian_status.json"), pretty = TRUE, auto_unbox = TRUE)
  final_summary <- list(validation = validation, target_summary = target_summary(data), model_comparison = model_comparison, pca = pca, pca_model_comparison = attr(pca, "model_comparison"), regression_diagnostics = diagnostics$diagnostics, age_sensitivity = sensitivity$summary)
  write_json(final_summary, file.path(OUTPUTS, "statistical_results", "final_summary.json"), pretty = TRUE, auto_unbox = TRUE)
  print(toJSON(list(shape = validation$shape, target = target_summary(data), models = model_comparison), pretty = TRUE, auto_unbox = TRUE))
}

run_pipeline()
