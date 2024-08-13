 # NBA Playoffs Player Performance Analysis

This project provides an in-depth analysis of NBA player performance during the 2021-2022 playoffs. The goal of the analysis is to evaluate player performance using advanced statistical methods and visualization techniques, which can be used for player evaluation, scouting, and strategic decision-making by NBA teams.

## Table of Contents

- [Introduction](#introduction)
- [Data Source](#data-source)
- [Methodology](#methodology)
- [Analysis](#analysis)
- [Challenges & Solutions](#challenges--solutions)
- [Visualizations](#visualizations)
- [Conclusion](#conclusion)
- [Future Work](#future-work)
- [Technical Details](#technical-details)
- [How to Run](#how-to-run)
- [Acknowledgments](#acknowledgments)

## Introduction

This project focuses on analyzing NBA player performance during the 2021-2022 playoffs using advanced statistical methods and visualization techniques. The goal is to provide actionable insights that NBA teams can use for player evaluation, scouting, and strategic decision-making.

## Data Source

The dataset used for this analysis was sourced from [Kaggle: NBA Player Stats](https://www.kaggle.com/datasets/vivovinco/nba-player-stats/data). It includes detailed player statistics from the 2021-2022 NBA playoffs.

## Methodology

1. **Data Collection**: Loaded the dataset and inspected its structure to understand the available columns and their types.
2. **Data Cleaning**: 
   - Normalized player names to handle special characters and applied manual corrections to ensure consistency.
   - Calculated the Assist-to-Turnover (AST/TO) ratio to improve the analysis in the assists category.
3. **Tie-Breaking Logic**: 
   - Implemented a tie-breaking system focusing on games played, effective field goal percentage (eFG%), free throw percentage (FT%), and minutes played (MP) to accurately rank players.
4. **Weighted Scoring**: 
   - Applied an NBA-style weighted scoring system to determine the top-performing players overall. Categories were weighted based on importance: Points (PTS), Assists (AST), Rebounds (TRB), Blocks (BLK), and Steals (STL).
5. **Visualization**: 
   - Generated professional visualizations using `ggplot2` to present the analysis results in an accessible and actionable manner.

## Analysis

- **Top 5 Players in Each Category**: 
  - Identified the top 5 players in Points, Assists, Rebounds, Blocks, and Steals using the custom tie-breaking logic.
- **Overall Top 5 Players**: 
  - Determined the top 5 overall players using the weighted scoring system. This analysis highlights key players who excelled across multiple categories.

## Challenges & Solutions

- **Data Quality**: 
  - Encountered issues with special character encoding in player names, which were resolved by normalizing text and applying manual corrections.
- **Tie-Breaking Logic**: 
  - Developed a robust tie-breaking system to ensure that players with similar statistics were ranked fairly, with an emphasis on games played and other key metrics.

## Visualizations

The following visualizations were created as part of the analysis:

1. **Top 5 Players in Points (PTS)**
2. **Top 5 Players in Assists (AST)**
3. **Top 5 Players in Rebounds (TRB)**
4. **Top 5 Players in Blocks (BLK)**
5. **Top 5 Players in Steals (STL)**
6. **Overall Top 5 Players (Weighted)**

Each visualization was generated using `ggplot2` in R, with specific colors chosen to represent different categories and teams.

## Conclusion

The analysis provided valuable insights into the performance of NBA players during the 2021-2022 playoffs. By applying advanced analytics and custom ranking methods, the project identified key players who significantly contributed to their teams. These findings can influence strategic decisions such as player development, game strategy, and scouting.

## Future Work

- **Predictive Analytics**: 
  - Future analysis could include predictive analytics to forecast player performance in future seasons based on historical data.
- **Expanded Metrics**: 
  - The model could be expanded to include advanced metrics like Player Efficiency Rating (PER) and Win Shares (WS).

## Technical Details

- **R Version**: 4.4.1
- **Libraries Used**: 
  - `dplyr` for data manipulation
  - `ggplot2` for data visualization
  - `readr` for data loading and parsing

## How to Run

1. **Clone the Repository**: 
   - `git clone https://github.com/yourusername/NBA-Playoffs-Analysis.git`
2. **Install Required Libraries**:
   - Ensure you have R and the following libraries installed: `dplyr`, `ggplot2`, `readr`.
   - Use `install.packages("dplyr")`, `install.packages("ggplot2")`, `install.packages("readr")` if not already installed.
3. **Run the Script**:
   - Load the dataset into your R environment.
   - Run the provided R script `NBA_Playoff_Analysis.R` to generate the analysis and visualizations.

## Acknowledgments

- Data Source: Kaggle
- Tools: R, ggplot2, dplyr, readr

