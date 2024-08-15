# NBA Player Performance Analysis: 2021-2022 Playoffs

# The goal of this project is to analyze the performance of NBA players during the 2021-2022 playoffs.
# The analysis includes data cleaning, exploration, identifying top players in key categories, 
# predictive modeling using regression and random forest, clustering players based on their performance,
# and comparing the top players using advanced visualization techniques.

# --------------------------------------------------------------
# Load Libraries
# --------------------------------------------------------------
library(dplyr)
library(ggplot2)
library(readr)
library(randomForest)
library(ggcorrplot)
library(ggrepel)
library(caret)
library(tidyr)
library(fmsb)

# --------------------------------------------------------------
# Data Loading and Cleaning
# --------------------------------------------------------------
# Load the data
file_path <- "C:/Users/kevin/OneDrive/Desktop/Data Analysis Projects/data sets/2021-2022 NBA Player Stats - Playoffs.csv"
nba_data <- read_delim(file_path, delim = ";", locale = locale(encoding = "UTF-8"))

# Correct Player Names and Handle Missing Values
nba_data$Player <- iconv(nba_data$Player, from = "UTF-8", to = "ASCII//TRANSLIT")

nba_data$Player <- nba_data$Player %>%
    gsub("Dvis Bertns", "Davis Bertans", .) %>%
    gsub("Luka Don.i.", "Luka Doncic", .) %>%
    gsub("Nikola Jokic", "Nikola Jokic", .) %>%
    gsub("Juancho Hernangomez", "Juancho Hernangomez", .) %>%
    gsub("Giannis Antetokounmpo", "Giannis Antetokounmpo", .)

# Handle Missing Values
nba_data <- nba_data %>%
    mutate_if(is.numeric, ~ifelse(is.na(.), median(., na.rm = TRUE), .))

# --------------------------------------------------------------
# Feature Engineering
# --------------------------------------------------------------
# Calculate AST/TO Ratio (Assists to Turnover Ratio)
nba_data <- nba_data %>%
    mutate(AST_TO = AST / TOV)

# --------------------------------------------------------------
# Correlation Matrix with Improved Annotation
# --------------------------------------------------------------
selected_vars <- nba_data %>% select(PTS, AST, TRB, BLK, STL, AST_TO, `eFG%`, `FT%`, MP)
correlation_matrix <- cor(selected_vars, use = "complete.obs")
ggcorrplot(correlation_matrix, lab = TRUE, title = "Correlation Matrix (Key Stats)") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
          axis.text.y = element_text(size = 8),
          plot.title = element_text(hjust = 0.5, size = 14))

# --------------------------------------------------------------
# Top Player Analysis by Categories
# --------------------------------------------------------------
categories <- c("PTS", "AST", "TRB", "BLK", "STL")

get_top_players <- function(data, category, top_n = 5, min_games = 10) {
    tie_breakers <- list(
        "PTS" = c("G", "eFG%", "FT%", "MP"),
        "AST" = c("G", "AST_TO", "MP"),
        "TRB" = c("G", "DRB", "MP"),
        "BLK" = c("G", "PF", "MP"),
        "STL" = c("G", "PF", "MP")
    )
    
    ranked_data <- data %>%
        filter(G >= min_games) %>%
        arrange(desc(.data[[category]]), desc(G), !!!syms(tie_breakers[[category]])) %>%
        mutate(rank = dense_rank(desc(.data[[category]])))
    
    ranked_data %>%
        filter(rank <= top_n) %>%
        arrange(desc(.data[[category]]), desc(G), !!!syms(tie_breakers[[category]])) %>%
        select(Player, !!rlang::sym(category), !!!syms(tie_breakers[[category]]))
}

top_players <- lapply(categories, function(cat) {
    get_top_players(nba_data, cat, min_games = 10)
})

for (i in seq_along(categories)) {
    cat("\nTop 5 Players in", categories[i], ":\n")
    print(top_players[[i]])
}

# --------------------------------------------------------------
# Visualization of Top 5 Players in Each Category
# --------------------------------------------------------------
category_colors <- c("PTS" = "blue", "AST" = "gold", "TRB" = "purple", "BLK" = "black", "STL" = "red")

plot_top_5 <- function(data, category, title, color) {
    ggplot(data %>% slice(1:5), aes(x = reorder(Player, -!!sym(category)), y = !!sym(category))) +
        geom_bar(stat = "identity", fill = color) +
        labs(title = title, x = "Players", y = category) +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

for (i in seq_along(categories)) {
    plot_data <- top_players[[i]] %>% slice(1:5)
    print(plot_top_5(plot_data, categories[i], paste("Top 5 Players -", categories[i]), category_colors[categories[i]]))
}

# --------------------------------------------------------------
# Weighted Overall Score Calculation with Sensitivity Analysis
# --------------------------------------------------------------
nba_weights <- c(PTS = 0.35, AST = 0.25, TRB = 0.20, STL = 0.10, BLK = 0.10)

nba_data_overall_weighted <- nba_data %>%
    filter(G >= 10) %>%
    mutate(across(all_of(categories), ~ scale(.) %>% as.numeric())) %>%
    rowwise() %>%
    mutate(Weighted_Overall_Score = sum(
        nba_weights["PTS"] * PTS,
        nba_weights["AST"] * AST,
        nba_weights["TRB"] * TRB,
        nba_weights["STL"] * STL,
        nba_weights["BLK"] * BLK,
        na.rm = TRUE
    )) %>%
    ungroup() %>%
    arrange(desc(Weighted_Overall_Score))

top_5_overall_weighted <- nba_data_overall_weighted %>%
    select(Player, Weighted_Overall_Score, all_of(categories), G, MP) %>%
    slice(1:5)

cat("\nTop 5 Weighted Overall Players:\n")
print(top_5_overall_weighted)

team_colors <- c(
    "Giannis Antetokounmpo" = "darkgreen",
    "Luka Doncic" = "blue",
    "Jimmy Butler" = "red",
    "Jayson Tatum" = "green",
    "Stephen Curry" = "gold"
)

ggplot(top_5_overall_weighted, aes(x = reorder(Player, -Weighted_Overall_Score), y = Weighted_Overall_Score, fill = Player)) +
    geom_bar(stat = "identity") +
    scale_fill_manual(values = team_colors) +
    labs(title = "Top 5 Weighted Overall Players", x = "Players", y = "Weighted Overall Score") +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Sensitivity Analysis: Explore how changing weights impacts player rankings
nba_weights_alt <- c(PTS = 0.4, AST = 0.2, TRB = 0.2, STL = 0.1, BLK = 0.1)

nba_data_overall_weighted_alt <- nba_data %>%
    filter(G >= 10) %>%
    mutate(across(all_of(categories), ~ scale(.) %>% as.numeric())) %>%
    rowwise() %>%
    mutate(Weighted_Overall_Score = sum(
        nba_weights_alt["PTS"] * PTS,
        nba_weights_alt["AST"] * AST,
        nba_weights_alt["TRB"] * TRB,
        nba_weights_alt["STL"] * STL,
        nba_weights_alt["BLK"] * BLK,
        na.rm = TRUE
    )) %>%
    ungroup() %>%
    arrange(desc(Weighted_Overall_Score))

top_5_overall_weighted_alt <- nba_data_overall_weighted_alt %>%
    select(Player, Weighted_Overall_Score, all_of(categories), G, MP) %>%
    slice(1:5)

cat("\nTop 5 Weighted Overall Players (Alternate Weights):\n")
print(top_5_overall_weighted_alt)

# --------------------------------------------------------------
# Regression Analysis: Predicting Points (PTS)
# --------------------------------------------------------------
lm_model <- lm(PTS ~ AST + TRB + STL + BLK, data = nba_data)
summary(lm_model)

# Split the data into training and testing sets
set.seed(42)
training_indices <- sample(1:nrow(nba_data), 0.8 * nrow(nba_data))
train_data <- nba_data[training_indices, ]
test_data <- nba_data[-training_indices, ]

# Build a linear regression model on the training data
lm_model <- lm(PTS ~ AST + TRB + STL + BLK, data = train_data)

# Predict on the test data
test_data$Predicted_PTS <- predict(lm_model, newdata = test_data)

# Evaluate the model
model_evaluation <- data.frame(
    RMSE = sqrt(mean((test_data$PTS - test_data$Predicted_PTS)^2)),
    MAE = mean(abs(test_data$PTS - test_data$Predicted_PTS)),
    R2 = summary(lm_model)$r.squared
)
print(model_evaluation)

# Scatter plot for Actual vs. Predicted Points
ggplot(test_data, aes(x = PTS, y = Predicted_PTS)) +
    geom_point(color = "blue") +
    geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
    labs(title = "Actual vs. Predicted Points", x = "Actual Points", y = "Predicted Points") +
    theme_minimal()

# --------------------------------------------------------------
# Random Forest Model with Cross-Validation and Model Comparison
# --------------------------------------------------------------
rf_model <- randomForest(PTS ~ AST + TRB + STL + BLK, data = nba_data, importance = TRUE)
varImpPlot(rf_model, main = "Variable Importance from Random Forest Model")

# Perform 10-fold cross-validation on the Random Forest model
control <- trainControl(method = "cv", number = 10)
tuned_rf <- train(PTS ~ AST + TRB + STL + BLK, data = nba_data, method = "rf", trControl = control)
plot(tuned_rf, main = "Cross-Validation RMSE vs. Number of Predictors")

# Evaluate the random forest model on the test data
test_data$RF_Predicted_PTS <- predict(rf_model, newdata = test_data)

rf_model_evaluation <- data.frame(
    RMSE = sqrt(mean((test_data$PTS - test_data$RF_Predicted_PTS)^2)),
    MAE = mean(abs(test_data$PTS - test_data$RF_Predicted_PTS)),
    R2 = cor(test_data$PTS, test_data$RF_Predicted_PTS)^2
)
print(rf_model_evaluation)

# Comparison of Linear Regression and Random Forest Models
cat("\nComparison of Linear Regression and Random Forest Models:\n")
print(data.frame(Model = c("Linear Regression", "Random Forest"),
                 RMSE = c(model_evaluation$RMSE, rf_model_evaluation$RMSE),
                 MAE = c(model_evaluation$MAE, rf_model_evaluation$MAE),
                 R2 = c(model_evaluation$R2, rf_model_evaluation$R2)))

# --------------------------------------------------------------
# Clustering and PCA Visualization with Enhanced Documentation
# --------------------------------------------------------------
# Filter out players who played less than 4 games
nba_filtered <- nba_data %>% filter(G >= 4)

# Normalize the relevant columns
nba_normalized <- nba_filtered %>%
    select(PTS, AST, TRB, STL, BLK) %>%  # Select relevant columns
    scale()  # Normalize the data

# Run K-Means Clustering
set.seed(42)
kmeans_result <- kmeans(nba_normalized, centers = 3)

# Perform PCA for visualization
pca_result <- prcomp(nba_normalized, scale. = TRUE)
pca_df <- data.frame(pca_result$x[, 1:2], Cluster = as.factor(kmeans_result$cluster), Player = nba_filtered$Player)

# Fix Nikola Jokic's name
pca_df$Player <- ifelse(pca_df$Player == "Nikola Joki?", "Nikola Jokic", pca_df$Player)
pca_df$Player <- ifelse(pca_df$Player == "Nikola Jokicc", "Nikola Jokic", pca_df$Player)

# Ensure any other names with "?" are corrected similarly
pca_df$Player <- ifelse(pca_df$Player == "Nikola Vu?evi?", "Nikola Vucevic", pca_df$Player)

# Assign new names to clusters
cluster_names <- c("Elite Players", "Key Players", "Role Players")
pca_df$ClusterName <- factor(kmeans_result$cluster, labels = cluster_names)

# Adjust the number of labeled players by cluster
expanded_label_data <- pca_df %>%
    group_by(Cluster) %>%
    arrange(PC1, PC2) %>%
    mutate(rank = row_number()) %>%
    filter((Cluster == 1 & rank <= 20) | 
               (Cluster == 2 & rank <= 25) | 
               (Cluster == 3 & rank <= 15))

# Plot the PCA clusters with adjusted number of player labels by cluster and named clusters
ggplot(pca_df, aes(x = PC1, y = PC2, color = ClusterName, shape = ClusterName)) +
    geom_point(size = 3) +
    geom_text_repel(data = expanded_label_data, aes(label = Player), 
                    size = 3.5, color = "black", max.overlaps = 25) +
    labs(title = "K-Means Clustering in Principal Component Space", x = "PC1", y = "PC2") +
    theme_minimal() +
    theme(legend.position = "right") +
    scale_color_manual(values = c("red", "green", "lightblue")) +
    scale_shape_manual(values = c(19, 17, 15))  # Different shapes for clusters

# --------------------------------------------------------------
# Player Comparison: Luka Dončić vs. Giannis Antetokounmpo
# --------------------------------------------------------------
# Radar Chart Comparison
luka_giannis <- nba_data %>%
    filter(Player %in% c("Luka Doncic", "Giannis Antetokounmpo")) %>%
    select(Player, PTS, AST, TRB, STL, BLK)

# Normalize the data for radar chart
luka_giannis_scaled <- as.data.frame(scale(luka_giannis[,-1]))
rownames(luka_giannis_scaled) <- luka_giannis$Player

# Add max and min rows for radar chart scaling
luka_giannis_scaled <- rbind(apply(luka_giannis_scaled, 2, max), apply(luka_giannis_scaled, 2, min), luka_giannis_scaled)

# Radar chart
radarchart(luka_giannis_scaled, axistype = 1,
           pcol = c("blue", "green"), pfcol = c(rgb(0.2,0.5,0.5,0.5), rgb(0.8,0.2,0.5,0.5)),
           plwd = 2, cglcol = "grey", cglty = 1, axislabcol = "grey", caxislabels = seq(-3,3,1), cglwd = 0.8,
           vlcex = 0.8, title = "Luka Dončić vs. Giannis Antetokounmpo")

legend("topright", legend = rownames(luka_giannis_scaled)[-c(1,2)], col = c("blue", "green"), lty = 1, lwd = 2)

# Side-by-Side Bar Plot Comparison
comparison_data <- nba_data %>%
    filter(Player %in% c("Luka Doncic", "Giannis Antetokounmpo")) %>%
    select(Player, PTS, AST, TRB, STL, BLK) %>%
    pivot_longer(cols = -Player, names_to = "Metric", values_to = "Value")

ggplot(comparison_data, aes(x = Metric, y = Value, fill = Player)) +
    geom_bar(stat = "identity", position = "dodge") +
    scale_fill_manual(values = c("green", "blue")) +
    labs(title = "Luka Dončić vs. Giannis Antetokounmpo: Metric Comparison", x = "Metric", y = "Value") +
    theme_minimal()

