 NBA Player Performance Analysis: 2021-2022 Playoffs
This project provides an in-depth analysis of NBA player performance during the 2021-2022 playoffs. The goal of the analysis is to evaluate player performance using advanced statistical methods and visualization techniques. This analysis can be used for player evaluation, scouting, and strategic decision-making by NBA teams.

Table of Contents
Introduction
Data Source
Methodology
Analysis
Top Player Analysis by Categories
Weighted Overall Score and Sensitivity Analysis
Regression Analysis
Random Forest Modeling
Clustering and PCA Visualization
Player Comparison: Luka Dončić vs. Giannis Antetokounmpo
Visualizations
Conclusion
Future Work
Technical Details
How to Run
Acknowledgments
Introduction
This project focuses on analyzing NBA player performance during the 2021-2022 playoffs using advanced statistical methods and visualization techniques. The objective is to derive actionable insights that NBA teams can leverage for player evaluation, scouting, and strategic decision-making.

Data Source
The dataset used for this analysis was sourced from Kaggle: NBA Player Stats. It includes detailed player statistics from the 2021-2022 NBA playoffs.

Methodology
Data Collection: The dataset was loaded and inspected to understand its structure and contents.
Data Cleaning:
Player names were corrected for special characters and inconsistencies.
Missing values were handled using median imputation for numeric columns.
Feature Engineering:
Calculated the Assist-to-Turnover (AST/TO) ratio to enhance analysis in the assists category.
Visualization:
Created a correlation matrix to understand relationships between key stats.
Visualized top players in key categories using bar plots.
Modeling and Analysis:
Conducted regression and random forest modeling to predict player performance.
Performed clustering and PCA for player categorization.
Compared key players using radar charts and side-by-side bar plots.
Analysis
Top Player Analysis by Categories
Points (PTS)
Assists (AST)
Rebounds (TRB)
Blocks (BLK)
Steals (STL)
For each category, the top 5 players were identified using custom tie-breaking logic that considers games played, shooting efficiency, free throw percentage, and minutes played.

Weighted Overall Score and Sensitivity Analysis
A weighted scoring system was used to rank players overall, with different weights assigned to each category:

Points (PTS): 35%
Assists (AST): 25%
Rebounds (TRB): 20%
Steals (STL): 10%
Blocks (BLK): 10%
The analysis also includes a sensitivity analysis to explore how changing these weights impacts player rankings.

Regression Analysis
A linear regression model was built to predict points (PTS) based on assists, rebounds, steals, and blocks. The model's performance was evaluated using metrics like RMSE, MAE, and R-squared.

Random Forest Modeling
A random forest model was also trained to predict points (PTS), and its performance was compared to the linear regression model using cross-validation. The random forest model showed superior predictive performance, as indicated by lower RMSE and higher R-squared values.

Clustering and PCA Visualization
Players were clustered into three groups (Elite Players, Key Players, and Role Players) based on their performance. Principal Component Analysis (PCA) was used to visualize the clusters in a reduced-dimensional space.

Player Comparison: Luka Dončić vs. Giannis Antetokounmpo
A radar chart and side-by-side bar plot were used to compare the performance metrics of Luka Dončić and Giannis Antetokounmpo across key categories.

Visualizations
[INSERT IMAGE] Correlation Matrix (Key Stats)
[INSERT IMAGE] Top 5 Players in Points (PTS)
[INSERT IMAGE] Top 5 Players in Assists (AST)
[INSERT IMAGE] Top 5 Players in Rebounds (TRB)
[INSERT IMAGE] Top 5 Players in Blocks (BLK)
[INSERT IMAGE] Top 5 Players in Steals (STL)
[INSERT IMAGE] Weighted Overall Score for Top 5 Players
[INSERT IMAGE] Sensitivity Analysis: Top 5 Players with Alternate Weights
[INSERT IMAGE] Regression Model: Actual vs. Predicted Points
[INSERT IMAGE] Random Forest Model: Variable Importance
[INSERT IMAGE] PCA Clustering of NBA Players
[INSERT IMAGE] Radar Chart Comparison: Luka Dončić vs. Giannis Antetokounmpo
[INSERT IMAGE] Bar Plot Comparison: Luka Dončić vs. Giannis Antetokounmpo
Conclusion
The analysis provides valuable insights into the performance of NBA players during the 2021-2022 playoffs. The weighted scoring system highlighted the top-performing players overall, while regression and random forest models provided predictive insights. Clustering and PCA helped categorize players based on performance, and the comparison between Luka Dončić and Giannis Antetokounmpo showcased differences in their playing styles.

Future Work
Expanded Metrics: Future analysis could include advanced metrics like Player Efficiency Rating (PER) and Win Shares (WS).
Predictive Analytics: Implement predictive analytics to forecast player performance in future seasons based on historical data.
Team-Level Analysis: Extend the analysis to evaluate team performance and identify key contributors.
Technical Details
R Version: 4.4.1
Libraries Used:
dplyr for data manipulation
ggplot2 for data visualization
readr for data loading and parsing
randomForest for random forest modeling
ggcorrplot for correlation matrix plotting
ggrepel for text labels
caret for cross-validation
tidyr for data tidying
fmsb for radar charts
How to Run
Clone the Repository:
git clone https://github.com/yourusername/NBA-Playoffs-Analysis.git
Install Required Libraries:
Ensure you have R and the following libraries installed: dplyr, ggplot2, readr, randomForest, ggcorrplot, ggrepel, caret, tidyr, fmsb.
Use install.packages("dplyr"), install.packages("ggplot2"), etc., if not already installed.
Run the Script:
Load the dataset into your R environment.
Run the provided R script NBA_Playoff_Analysis.R to generate the analysis and visualizations.
Acknowledgments
Data Source: Kaggle
Tools: R, ggplot2, dplyr, randomForest, ggcorrplot, ggplot2, ggrepel, caret, tidyr, fmsb
