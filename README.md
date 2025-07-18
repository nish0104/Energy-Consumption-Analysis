# Energy-Consumption-Analysis

This project explores patterns in energy usage across residential and commercial buildings using statistical and forecasting methods. It was completed as part of the Intermediate Analytics course (ALY6015) at Northeastern University.

## Objective

To analyze how energy consumption is influenced by:
- Occupancy rates
- Seasonal patterns (summer vs. winter)
- Building types (residential vs. commercial)

We also aimed to **forecast future consumption** using time series models.

## Team Members

- Nishthaben Vaghani  
- Jainam Patel  
- Jayesh Patil  

## Dataset

The dataset contains **45,884 records** with 22 variables, including:
- Monthly KWH usage for 2010
- Building attributes (age, type, occupancy)
- Demographics (population, units)

No missing values; data required normalization due to **outliers** and **skewness**.

## Tools & Libraries

- **Language:** R  
- **Libraries:** `tidyverse`, `ggplot2`, `forecast`, `psych`, `plotly`, `gridExtra`  
- **Tests Used:** Spearman Correlation, Kruskal-Wallis Test  
- **Model:** Exponential Smoothing (ETS)  

## Methods & Insights

### 1. Correlation Analysis
- **Tool:** Spearman Correlation
- **Finding:** Weak positive correlation (ρ = 0.22) between occupancy and energy consumption.
- **Implication:** Other factors like building size and insulation significantly affect usage.

### 2. Seasonality Impact
- **Tool:** Kruskal-Wallis Test
- **Finding:** Significant seasonal consumption variation.
  - High usage in **June–August** (cooling demand)
  - Second peak in **Nov–Dec** (heating)

### 3. Forecasting
- **Model:** ETS (Exponential Smoothing)
- **Result:** Accurately captured seasonal trends and helped in projecting usage for operational planning.

## Visualizations

- Bar charts: residential vs. commercial use  
- Seasonal line plots  
- Scatter plots for correlation  
- Forecast visualizations using `forecast::ets`

## Key Takeaways

- **Residential buildings** have higher energy use.
- **Summer months** drive peak consumption due to cooling.
- Time-series forecasting aids in **resource planning and sustainability**.
- Insights support **policy formulation** for energy efficiency.

## References

- *Elementary Statistics* by Allan G. Bluman  
- *R in Action* by Robert Kabacoff  
- [StatLearning](https://www.statlearning.com)  
- [R-Bloggers: Cross-Validation in R](https://www.r-bloggers.com/2020/05/cross-validation-essentials-in-r/)



