
######################################################################

#Final Project: Initial Analysis Report
  
# Loading necessary libraries
library(psych)
library(tidyverse)
library(ggplot2)

#Importing the Dataset 
Energy_Usage <- read.csv("Energy Usage Dataset.csv")
View(Energy_Usage)

# Understanding the Dataset
describe(Energy_Usage)
summary(Energy_Usage)
str(Energy_Usage)

# Checking for missing values
missing_values <- colSums(is.na(Energy_Usage))
print(missing_values[missing_values > 0])

# Checking for duplicates
Energy_Usage <- Energy_Usage %>% distinct()

# Loading necessary libraries
library(tidyverse)

# Aggregating monthly total energy consumption by summing over the months
monthly_energy <- Energy_Usage %>%
  select(KWH.JANUARY.2010:KWH.DECEMBER.2010) %>%
  colSums()

# Converting into a data frame for easier plotting
monthly_energy_df <- data.frame(
  Month = c("January", "February", "March", "April", "May", "June", "July", 
            "August", "September", "October", "November", "December"),
  Total_KWH = monthly_energy
)

# Reordering the months to ensure chronological order
monthly_energy_df$Month <- factor(monthly_energy_df$Month, 
                                  levels = c("January", "February", "March", "April", 
                                             "May", "June", "July", "August", 
                                             "September", "October", "November", "December"))

# Plotting the monthly total energy consumption as a bar chart with correct month order
ggplot(monthly_energy_df, aes(x = Month, y = Total_KWH, fill = Month)) + 
  geom_bar(stat = "identity", show.legend = FALSE, color = "black", alpha = 0.8) + 
  labs(title = "Total Energy Consumption by Month", 
       x = "Month", 
       y = "Total Energy Consumption (KWH)") + 
  theme_minimal(base_size = 15) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"))

# Filtering the dataset for 'Commercial' and 'Residential' building types
filtered_data <- Energy_Usage %>% 
  filter(BUILDING.TYPE %in% c("Commercial", "Residential"))

# Bar plot of Total Energy Consumption for 'Commercial' and 'Residential'
ggplot(filtered_data, aes(x = BUILDING.TYPE, y = TOTAL.KWH, fill = BUILDING.TYPE)) + 
  geom_bar(stat = "identity", alpha = 0.8) + 
  theme_minimal(base_size = 14) + 
  scale_y_continuous(labels = scales::comma) + 
  labs(title = "Total Energy Consumption: Commercial vs Residential",  
       x = "Building Type",  
       y = "Total Energy Consumption (KWH)") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")


# Installing the plotly for interactivity
##install.packages("plotly")
library(plotly)
library(ggplot2)

# Q1- Method: Spearman Correlation Coefficient 
# Spearman Correlation Analysis

# Selecting relevant columns for correlation
correlation_data <- Energy_Usage %>% 
  select(TOTAL.KWH, OCCUPIED.HOUSING.UNITS)

# Calculating Spearman Correlation
spearman_correlation <- cor(correlation_data$TOTAL.KWH, correlation_data$OCCUPIED.HOUSING.UNITS, method = "spearman")

# Output of Spearman Correlation Result
cat("Spearman Correlation between Total Energy Consumption and Occupied Housing Units:", spearman_correlation, "\n")

# Visualizing the Relationship
ggplot(Energy_Usage, aes(x = OCCUPIED.HOUSING.UNITS, y = TOTAL.KWH)) + 
  geom_point(alpha = 0.6, color = "#1f77b4") + 
  geom_smooth(method = "lm", se = FALSE, color = "#d62728", linetype = "dashed") + 
  labs(title = "Relationship between Total Energy Consumption and Occupied Housing Units", 
       x = "Occupied Housing Units", 
       y = "Total Energy Consumption (KWH)") + 
  theme_minimal(base_size = 15) + 
  theme(plot.title = element_text(hjust = 0.5, face = "bold"), 
        axis.title.x = element_text(face = "bold"), 
        axis.title.y = element_text(face = "bold"))

# Q2 - Method: Kruskal-Wallis Test 
# Reshaping the data to long format for easier seasonal comparison
library(tidyverse)
library(dplyr)
energy_long <- Energy_Usage %>% 
  select(KWH.JANUARY.2010, KWH.FEBRUARY.2010, KWH.MARCH.2010, 
         KWH.APRIL.2010, KWH.MAY.2010, KWH.JUNE.2010, 
         KWH.JULY.2010, KWH.AUGUST.2010, KWH.SEPTEMBER.2010, 
         KWH.OCTOBER.2010, KWH.NOVEMBER.2010, KWH.DECEMBER.2010) %>% 
  pivot_longer(cols = everything(), names_to = "Month", values_to = "KWH")

# Categorizing the seasons
energy_long$Season <- case_when(
  energy_long$Month %in% c("KWH.MAY.2010", "KWH.JUNE.2010", "KWH.JULY.2010", "KWH.AUGUST.2010") ~ "Summer",
  energy_long$Month %in% c("KWH.NOVEMBER.2010", "KWH.DECEMBER.2010", "KWH.JANUARY.2010", "KWH.FEBRUARY.2010") ~ "Winter",
)

# Applying Kruskal-Wallis Test
kruskal_result <- kruskal.test(KWH ~ Season, data = energy_long)

# Output of the Kruskal-Wallis Test result
cat("Kruskal-Wallis Test Result:\n")
cat("Test Statistic:", kruskal_result$statistic, "\n")
cat("Degrees of Freedom:", kruskal_result$parameter, "\n")

# Q.3 - Time Series Forecasting with ARIMA and Exponential Smoothing

# Load necessary libraries
#install.packages("forecast")
#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("gridExtra")

library(tidyverse)
library(dplyr)
library(forecast)
library(ggplot2)
library(gridExtra)

# Assuming Energy_Usage is your dataset
energy_long <- Energy_Usage %>% 
  select(KWH.JANUARY.2010, KWH.FEBRUARY.2010, KWH.MARCH.2010, 
         KWH.APRIL.2010, KWH.MAY.2010, KWH.JUNE.2010, 
         KWH.JULY.2010, KWH.AUGUST.2010, KWH.SEPTEMBER.2010, 
         KWH.OCTOBER.2010, KWH.NOVEMBER.2010, KWH.DECEMBER.2010) %>% 
  pivot_longer(cols = everything(), names_to = "Month", values_to = "KWH")

# Categorizing the seasons
energy_long$Season <- case_when(
  energy_long$Month %in% c("KWH.MAY.2010", "KWH.JUNE.2010", "KWH.JULY.2010", "KWH.AUGUST.2010") ~ "Summer",
  energy_long$Month %in% c("KWH.NOVEMBER.2010", "KWH.DECEMBER.2010", "KWH.JANUARY.2010", "KWH.FEBRUARY.2010") ~ "Winter",
)

# Summing up energy consumption per month
monthly_kwh <- colSums(Energy_Usage %>% select(starts_with("KWH.")), na.rm = TRUE)

# Converting the monthly data to time series
energy_ts <- ts(monthly_kwh, start = c(2010, 1), frequency = 12)

# Defining seasonal months
summer_months <- c(5, 6, 7, 8)   # May, June, July, August
winter_months <- c(11, 12, 1, 2)  # November, December, January, February

# Extracting energy consumption for each season
summer_kwh <- monthly_kwh[summer_months]
winter_kwh <- monthly_kwh[winter_months]

# Ensuring there are enough data points
ensure_min_data <- function(kwh_values) {
  if (length(kwh_values) < 3) {
    kwh_values <- rep(mean(kwh_values, na.rm = TRUE), 3)  # Fill with mean if too short
  }
  return(kwh_values)
}

summer_kwh <- ensure_min_data(summer_kwh)
winter_kwh <- ensure_min_data(winter_kwh)

# Creating time series with correct frequency
summer_ts <- ts(summer_kwh, start = c(2010, 5), frequency = 12) 
winter_ts <- ts(winter_kwh, start = c(2010, 11), frequency = 12)

# Applying Exponential Smoothing (ETS) models
summer_ets <- ets(summer_ts, model = "ZZZ")
winter_ets <- ets(winter_ts, model = "ZZZ")

# Forecasting with a longer horizon (h = 6)
forecast_horizon <- 6
summer_forecast <- forecast(summer_ets, h = forecast_horizon)
winter_forecast <- forecast(winter_ets, h = forecast_horizon)

# Using Function to plot forecasts
plot_forecast <- function(forecast_obj, title_text) {
  autoplot(forecast_obj) +
    labs(title = title_text,
         subtitle = "Forecasted vs Actual Energy Consumption Over Time",
         x = "Month",
         y = "Energy Consumption (KWH)") +
    theme_minimal(base_size = 15) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"),
          plot.subtitle = element_text(hjust = 0.5, face = "italic"),
          axis.title.x = element_text(face = "bold"),
          axis.title.y = element_text(face = "bold"))
}

# Generating plots for each season
plot_summer <- plot_forecast(summer_forecast, "Exponential Smoothing Forecast for Summer Season")
plot_winter <- plot_forecast(winter_forecast, "Exponential Smoothing Forecast for Winter Season")

# Arranging the plots in a single output (stacked format)
grid.arrange(plot_summer, plot_winter, ncol = 1)