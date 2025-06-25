# Visualize Better with R
[![MethodsHub❤️ Guidelines](https://img.shields.io/badge/MethodsHub_Tutorial-GuidelinesV3-lightblue)](https://github.com/GESIS-Methods-Hub/guidelines-for-tutorials)
 ![](https://img.shields.io/badge/License-MIT-blue) ![](https://img.shields.io/badge/PR's-Welcome-lightgreen)

**Author:** Shyam Gupta ([ORCID](https://orcid.org/0009-0003-4639-5618))  
**Email:** shyam.gupta@gesis.org  
**Affiliation:** GESIS Leibniz Institute for the Social Sciences  
**Date:** 2025-04-10  


---
### Learning Objective
I was working on a social science research project—trying to decode the relationship between people’s well-being and their social interactions. After spending hours collecting survey responses, I realized that raw numbers alone weren’t telling the entire story.

> “I needed a better way to visualize my data to spot trends, patterns, and outliers.”  
> That is when my journey with data visualization in **R** began.

In this tutorial, I’ll walk you through the plots and visual techniques. I’ll share each plot in the order I stumbled upon them, explaining *why* you might want to use them, *what* they reveal, and *how* to make them.

By the end of this tutorial, you’ll have a handy arsenal of 5–8 powerful visualization techniques perfect for social science data exploration. Let’s get started!

### Duration

Around 20–30 mins

---

## 1. Swarm Plots over Scatter Plots

**The Discovery:**  
My first big “aha” moment came when I had to compare numerical data (like response scores) across different groups (like age brackets). I found that regular scatter plots overlapped points too much—making it hard to see the data distribution.

**The Hero (Swarm Plot):**  
A **swarm plot** is useful when you want to display the distribution of a numerical variable across different categories *without losing individual data points*. Unlike simple scatter plots, swarm plots arrange points to avoid overlap, helping you see each observation more clearly.

**When to Use:**  
- You have a moderate number of data points (not too large).  
- You want to see each individual data point by category.  
- You want a more “transparent” view of the distribution than a box or violin plot alone can provide.

```r
# Install/load the required packages (uncomment if needed)
# install.packages(c("dplyr","tidyr","ggplot2","ggbeeswarm"))

library(dplyr)
library(tidyr)
library(ggplot2)
library(ggbeeswarm)

set.seed(42)
df <- data.frame(
  radius_mean    = runif(100, 12, 16),
  texture_mean   = runif(100, 15, 25),
  perimeter_mean = runif(100, 70, 110),
  area_mean      = runif(100, 350, 750),
  concavity_mean = runif(100, 0.1, 0.5),
  symmetry_mean  = runif(100, 0.15, 0.25),
  diagnosis      = sample(c("Group A", "Group B"), 100, TRUE)
)

df_long <- df %>%
  pivot_longer(
    radius_mean:symmetry_mean,
    names_to  = "feature",
    values_to = "value"
  )

ggplot(df_long, aes(x = feature, y = value, color = diagnosis)) +
  geom_beeswarm(size = 1.5, cex = 1) +
  theme_minimal(base_size = 14) +
  labs(
    title = "Distribution of Mean Features by Group",
    x     = "Feature",
    y     = "Value"
  ) +
  theme(
    axis.text.x    = element_text(angle = 45, hjust = 1),
    legend.position = "top"
  )
````

![](images/Screenshot_2025-05-22_at_01.22.31.png)
<img width="843" alt="image" src="https://github.com/user-attachments/assets/3040f1b8-0d87-4144-95be-6c360db1cc29" />

---

## 2. Density Plots

**The Discovery:**
Next, I wanted to understand the distribution of responses for certain questions (like “level of trust in institutions”) across two demographic segments. A bar chart wasn’t capturing the shape of each distribution. A histogram might work, but I wanted a smoothed look.

**The Hero (Density Plot):**
A density plot provides a smoothed curve of the distribution. It’s like a refined histogram where you can compare the shapes of different groups without the rough bin edges.

**When to Use:**

* You want to see the distribution (shape, skew, modality) of a numerical variable.
* You have one or more categorical variables to compare (e.g., Group A vs. Group B).
* A smoother visualization of distribution is more intuitive than a histogram.

```r
library(ggplot2)
# Using `df` from above
ggplot(df, aes(x = area_mean, fill = diagnosis)) +
  geom_density(alpha = 0.6) +
  theme_minimal() +
  labs(
    title = "Density Plot of Area Mean by Group",
    x     = "Area Mean",
    y     = "Density",
    fill  = "Group"
  )
```
<img width="843" alt="image" src="https://github.com/user-attachments/assets/8ad738df-3386-41a5-8931-c608ab129b8e" />


---

## 3. Box Plots with Jitter

**The Discovery:**
Sometimes, I needed a quick sense of how responses (like “support for policy X”) varied across multiple categories (such as different regions). A **box plot** shows median, quartiles, and outliers, but I still wanted to see *some* individual points.

**The Hero (Box Plot + Jitter):**
By adding a jittered layer of points over the box plot, you get summary statistics and a look at each observation. This helps you see if outliers are truly outliers or part of a cluster.

**When to Use:**

* You have at least one categorical variable and one numeric variable.
* You want summary statistics plus raw data.
* You’re dealing with moderate sample sizes.

```r
library(ggplot2)
set.seed(123)
data <- data.frame(
  name  = c(rep("A",500), rep("B",500), rep("C",20), rep("D",100)),
  value = c(rnorm(500,10,5), rnorm(500,13,1), rnorm(20,25,4), rnorm(100,12,1))
)

ggplot(data, aes(x = name, y = value, fill = name)) +
  geom_boxplot() +
  geom_jitter(color = "black", size = 0.4, alpha = 0.9) +
  theme_minimal() +
  labs(title = "Box Plot with Jitter", x = "", y = "Value") +
  theme(legend.position = "none")
```

<img width="843" alt="image" src="https://github.com/user-attachments/assets/e4bc737b-9bdf-4fee-9c73-55548497e8c3" />

---

## 4. Violin Plot

**The Discovery:**
I wanted to see not just the median and quartiles but the full *kernel density* shape of my data. A **violin plot** shows both summary statistics and density.

**The Hero (Violin Plot):**
Violin plots combine box plot and density plot ideas, giving you a wider view of distribution for each category.

**When to Use:**

* Similar to box plots, but you care about the full distribution shape.
* Comparing multiple groups where you want a holistic view.

```r
library(ggplot2)
library(dplyr)
library(forcats)

data <- read.csv(
  "https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/10_OneNumSevCatSubgroupsSevObs.csv"
) %>%
  mutate(tip = round(tip/total_bill * 100, 1))

ggplot(data, aes(x = fct_reorder(day, tip), y = tip, fill = sex)) +
  geom_violin(position = position_dodge(width = 0.9), alpha = 0.5, outlier.shape = NA) +
  labs(x = "", y = "Tip (%)", title = "Violin Plot of Tip Percentage by Day and Sex") +
  coord_cartesian(ylim = c(0, 40)) +
  theme_minimal()
```
<img width="843" alt="image" src="https://github.com/user-attachments/assets/ea6b8e00-7eb9-4b43-8983-6e11a6b6a9fb" />


---

## 5. Bar + Line Plot

**The Discovery:**
When analyzing time-series survey data (e.g., monthly participant counts), I wanted both bar-chart values and a trend line.

**The Hero (Bar + Line Combo):**
Use bars for absolute values and overlay a line to depict the trend over time.

**When to Use:**

* Showing period values (bars) and overall trend (line) for time-series data.

```r
library(ggplot2)
library(zoo)

data("AirPassengers")
df_air <- data.frame(
  Month      = as.Date(as.yearmon(time(AirPassengers))),
  Passengers = as.numeric(AirPassengers)
)

ggplot(df_air, aes(x = Month)) +
  geom_col(aes(y = Passengers), width = 25) +
  geom_line(aes(y = Passengers), size = 1) +
  labs(
    title    = "Monthly International Airline Passengers (1949–1960)",
    subtitle = "Data from the AirPassengers dataset",
    x        = "Month",
    y        = "Passengers"
  ) +
  theme_minimal()
```

<img width="843" alt="image" src="https://github.com/user-attachments/assets/aaa9955b-7c6c-4273-9721-98e19e04f86b" />

---

## 6. Correlation Heatmap

**The Discovery:**
I needed an overview of how numerical features related. Rather than a numeric matrix, a **correlation heatmap** highlights associations at a glance.

**The Hero (Correlation Heatmap):**
A color-scaled matrix showing strength and direction of correlations.

**When to Use:**

* Dealing with multiple numerical variables.
* Quickly assessing which pairs are highly correlated.

```r
library(corrplot)

num_cols    <- c("radius_mean","texture_mean","perimeter_mean",
                 "area_mean","concavity_mean","symmetry_mean")
corr_matrix <- cor(df[, num_cols])

corrplot(
  corr_matrix,
  method    = "color",
  type      = "upper",
  addCoef.col = "black",
  tl.col    = "black",
  title     = "Correlation Heatmap of Synthetic Features",
  mar       = c(0,0,2,0)
)
```
<img width="778" alt="image" src="https://github.com/user-attachments/assets/61b8c043-1348-45db-b773-2ff7c1108be6" />


---

## 7. Scatter Plot with Regression Line

**The Discovery:**
I often wondered if one factor could predict another—like, does “annual income” predict “charitable donations”?

**The Hero (Scatter + Regression):**
Overlay a linear regression line on a scatter plot to gauge trend direction and strength.

**When to Use:**

* Examining relationship between two numerical variables.
* Getting a quick visual indication of a linear trend.

```r
ggplot(df, aes(x = radius_mean, y = area_mean, color = diagnosis)) +
  geom_point(size = 2, alpha = 0.7) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Scatter Plot with Regression Line",
    x     = "Radius Mean",
    y     = "Area Mean"
  ) +
  theme_minimal()
```
<img width="790" alt="image" src="https://github.com/user-attachments/assets/af021ee0-a19a-460b-9baf-6cd624623634" />


---

## 8. Stacked Bar Charts

**The Discovery:**
I wanted to show how responses divided among categories (like political affiliation vs. policy preference). A **stacked bar chart** does this intuitively.

**The Hero (Stacked Bar Chart):**
Compares total counts and internal composition of each group.

**When to Use:**

* You have two or more categorical variables.
* You want overall counts and proportional breakdown.

```r
set.seed(123)
df_stack <- data.frame(
  Region     = sample(c("North","South","East","West"), 200, TRUE),
  Preference = sample(c("Support","Oppose","Neutral"), 200, TRUE)
)

ggplot(df_stack, aes(x = Region, fill = Preference)) +
  geom_bar(position = "stack") +
  labs(
    title = "Stacked Bar Chart of Preferences by Region",
    x     = "Region",
    y     = "Count"
  ) +
  theme_minimal()
```
<img width="790" alt="image" src="https://github.com/user-attachments/assets/038875a1-a8ae-4c8b-b6d7-ad713111c04d" />


---

## 9. Maps: Choropleth & Point Map

```r
# US Choropleth Map
library(ggplot2)
library(maps)
library(dplyr)

states_map <- map_data("state")
state_data <- data.frame(
  region       = tolower(state.name),
  social_index = runif(50, 0, 100)
)

us_data <- left_join(states_map, state_data, by = "region")

ggplot(us_data, aes(long, lat, group = group, fill = social_index)) +
  geom_polygon(color = "white") +
  coord_fixed(1.3) +
  theme_minimal() +
  labs(
    title = "US States Social Index Choropleth",
    fill  = "Social Index"
  )

# World Point Map
world_map <- map_data("world")
cities    <- data.frame(
  city        = paste("City", 1:30),
  long        = runif(30, -180, 180),
  lat         = runif(30, -90, 90),
  event_count = sample(1:100, 30, TRUE)
)

ggplot() +
  geom_polygon(
    data = world_map,
    aes(long, lat, group = group),
    fill  = "gray90",
    color = "white"
  ) +
  geom_point(
    data  = cities,
    aes(long, lat, size = event_count),
    alpha = 0.7
  ) +
  coord_fixed(1.3) +
  theme_minimal() +
  labs(
    title = "Global Social Event Locations (Synthetic Data)",
    size  = "Event Count"
  )
```
<img width="797" alt="image" src="https://github.com/user-attachments/assets/dfe0b73d-6fb3-4f17-bd81-9351c634b920" />
<img width="797" alt="image" src="https://github.com/user-attachments/assets/ce89a182-dcbd-4712-89a3-ae33e032fdac" />

---

## Conclusion

With this tutorial, you now have more weapons in your arsenal to use R and visualize better to draw insights from your data.

---

## References and Reading Material

* **South East Asia Analytics** – [Kaggle Notebook](https://www.kaggle.com/code/caesarmario/southeast-asia-happiness-report-2021#3.-%7C-Top-4-Countries-%F0%9F%8F%864%EF%B8%8F%E2%83%A3)
* **Mental Health Viz** – [Kaggle Notebook](https://www.kaggle.com/code/melissamonfared/mental-health-music-relationship-analysis-eda)
* **R for Data Science** (Wickham & Grolemund) – A comprehensive guide on data manipulation and visualization in R.
* **Data to Viz** – [data-to-viz.com](https://www.data-to-viz.com/) for insights on selecting the right chart type.

