# Load necessary libraries
library(dplyr)
library(ggplot2)
library(readr)

# Specify the file path to your CSV file
file_path <- "C:/Users/kevin/OneDrive/Desktop/Data Analysis Projects/data sets/2021-2022 NBA Player Stats - Playoffs.csv"

# Load the data using read_delim with UTF-8 encoding
nba_data <- read_delim(file_path, delim = ";", locale = locale(encoding = "UTF-8"))

# Normalize text to handle special characters, then manually fix known issues
nba_data$Player <- iconv(nba_data$Player, from = "UTF-8", to = "ASCII//TRANSLIT")

# Manually correct player names to avoid any encoding issues
nba_data$Player <- nba_data$Player %>%
  gsub("Dvis Bertns", "Davis Bertans", .) %>%
  gsub("Luka Don.i.", "Luka Doncic", .) %>%
  gsub("Nikola Jokic", "Nikola Jokic", .) %>%
  gsub("Juancho Hernangomez", "Juancho Hernangomez", .) %>%
  gsub("Giannis Antetokounmpo", "Giannis Antetokounmpo", .)

# Calculate AST/TO ratio (Assists to Turnover ratio)
nba_data <- nba_data %>%
  mutate(AST_TO = AST / TOV)

# Define the categories to analyze (Points, Assists, Rebounds, Blocks, Steals)
categories <- c("PTS", "AST", "TRB", "BLK", "STL")

# Function to retrieve the top players with enhanced tie-breaking logic
get_top_players <- function(data, category, top_n = 5, min_games = 10) {
  # Define tie-breakers specific to each category
  tie_breakers <- list(
    "PTS" = c("G", "eFG%", "FT%", "MP"),
    "AST" = c("G", "AST_TO", "MP"),
    "TRB" = c("G", "DRB", "MP"),
    "BLK" = c("G", "PF", "MP"),
    "STL" = c("G", "PF", "MP")
  )
  
  # Rank players based on the category and apply the tie-breaking logic
  ranked_data <- data %>%
    filter(G >= min_games) %>%
    arrange(desc(.data[[category]]), desc(G), !!!syms(tie_breakers[[category]])) %>%
    mutate(rank = dense_rank(desc(.data[[category]])))
  
  # Return only the top N players for the category
  ranked_data %>%
    filter(rank <= top_n) %>%
    arrange(desc(.data[[category]]), desc(G), !!!syms(tie_breakers[[category]])) %>%
    select(Player, !!rlang::sym(category), !!!syms(tie_breakers[[category]]))
}

# Recalculate top players in each category using the function
top_players <- lapply(categories, function(cat) {
  get_top_players(nba_data, cat, min_games = 10)
})

# Print the top 5 players for each category
for (i in seq_along(categories)) {
  cat("\nTop 5 Players in", categories[i], ":\n")
  print(top_players[[i]])
}

# Define NBA-style weights for each category (based on importance)
nba_weights <- c(PTS = 0.35, AST = 0.25, TRB = 0.20, STL = 0.10, BLK = 0.10)

# Calculate the weighted overall score
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

# Select the top 5 weighted overall players
top_5_overall_weighted <- nba_data_overall_weighted %>%
  select(Player, Weighted_Overall_Score, all_of(categories), G, MP) %>%
  slice(1:5)

# Print the top 5 weighted overall players to verify
cat("\nTop 5 Weighted Overall Players:\n")
print(top_5_overall_weighted)

# Define team-specific colors for the top 5 overall players
team_colors <- c(
  "Giannis Antetokounmpo" = "darkgreen",  # Bucks' green
  "Luka Doncic" = "blue",                # Mavericks' blue
  "Jimmy Butler" = "red",                # Heat's red
  "Jayson Tatum" = "green",            # Celtics' green
  "Stephen Curry" = "gold"               # Warriors' gold
)

# Plot the top 5 weighted overall players
ggplot(top_5_overall_weighted, aes(x = reorder(Player, -Weighted_Overall_Score), y = Weighted_Overall_Score, fill = Player)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = team_colors) +
  labs(title = "Top 5 Weighted Overall Players", x = "Players", y = "Weighted Overall Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Function to plot top 5 players for each category with specific colors
plot_top_5 <- function(data, category, title, color) {
  ggplot(data %>% slice(1:5), aes(x = reorder(Player, -!!sym(category)), y = !!sym(category))) +
    geom_bar(stat = "identity", fill = color) +
    labs(title = title, x = "Players", y = category) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}

# Define the colors for each category
category_colors <- c("PTS" = "blue", "AST" = "gold", "TRB" = "purple", "BLK" = "black", "STL" = "red")

# Plot and print only the top 5 players for each category
for (i in seq_along(categories)) {
  plot_data <- top_players[[i]] %>% slice(1:5)  # Ensure only top 5 are used
  print(plot_top_5(plot_data, categories[i], paste("Top 5 Players -", categories[i]), category_colors[categories[i]]))
}
