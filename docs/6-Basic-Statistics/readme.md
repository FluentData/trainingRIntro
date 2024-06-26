# Basic Statistics 

 

- [Introduction](#introduction)

- [Prerequisites](#prerequisites)

- [Descriptive Statistics](#descriptive-statistics)

- [Measures of Central Tendency and Dispersion](#measures-of-central-tendency-and-dispersion)

- [Statistical Tests](#statistical-tests)

- [Other Statistical Tests](#other-statistical-tests)

- [Correlation Analysis](#correlation-analysis)

## Introduction

R was originally developed as a statistical programming language and its built-in functions are commonly used for basic statistics. There are also many community developed packages that make it easy to perform statistical analyses. This tutorial will cover descriptive statistics functions and some statistical tests that might be used on environmental data.


## Prerequisites

This lesson assumes you are familiar with the material in the lesson on Functions and Importing Data.

Statistical functions are used in this lesson that require installation of the `envstats` package.


```{r ex-03e4e6e355b4, eval = FALSE}
install.packages("envstats")

```

The data used throughout these lessons is available from this package.


## Descriptive Statistics

R has many built-in functions for descriptive statistics. We will use
these functions to understand the ozone data in the `chicago_air` data
frame.


```{r ex-8517d97aaedf, exercise = FALSE, eval = TRUE, exercise.cap = 'Extract example data'}
data("chicago_air")

ozone <- chicago_air$ozone

```

Most of the functions we'll be using have an argument named `na.rm` that stands
for `NA` remove. If the argument is set to `TRUE` then the function will remove
all missing values from the data set. Otherwise, the function will error.

These functions tell us the range of the data values, i.e., the highest and
lowest values.


```{r ex-fddee11c2342, exercise = FALSE, eval = TRUE, exercise.cap = 'Find minimum value'}
min(ozone, na.rm=TRUE)

```

```{r ex-90da1e37e6ea, exercise = FALSE, eval = TRUE, exercise.cap = 'Find maximum value'}
max(ozone, na.rm=TRUE)

```

```{r ex-6f0999a25617, exercise = FALSE, eval = TRUE, exercise.cap = 'Find range of values'}
range(ozone, na.rm=TRUE)

```

We can also get the mean and the quartile values from the `summary()` function.


```{r ex-d4a27016db41, exercise = FALSE, eval = TRUE, exercise.cap = 'Summary statistics'}
summary(ozone)

```

The `IQR()` function gives us the interquartile range, which lets us know how large
the spread is for the values in the central range of the distribution, i.e. between
the 25th percentile and the 75th percentile.


```{r ex-61b3ee890248, exercise = FALSE, eval = TRUE, exercise.cap = 'Calculate IQR'}
IQR(ozone, na.rm=TRUE)

```

We can use the `boxplot()` function to visualize the interquartile range. The outline
of the box itself shows the middle 50% of the data, while the line in the middle
of the box shows the median.


```{r ex-075999b4d751, exercise = FALSE, eval = TRUE, exercise.cap = 'Visualize IQR with boxplot'}
boxplot(ozone)

```

## Measures of Central Tendency and Dispersion

R has functions for finding the mean and median of a set of values.


```{r ex-f1cc48ad013e, exercise = FALSE, eval = TRUE, exercise.cap = 'Calculate mean'}
mean(ozone, na.rm=TRUE)

```

```{r ex-8fbc6f8c0282, exercise = FALSE, eval = TRUE, exercise.cap = 'Calculate median'}
median(ozone, na.rm=TRUE)

```

The functions `var()` and `sd()` calculate the variance and standard
deviation, respectively.


```{r ex-c1c9a388e295, exercise = FALSE, eval = TRUE, exercise.cap = 'Calculate variance'}
var(ozone, na.rm=TRUE)

```

```{r ex-39d21c711d4b, exercise = FALSE, eval = TRUE, exercise.cap = 'Calculate standard deviation'}
sd(ozone, na.rm=TRUE)

```

## Statistical Tests

R has many built-in functions for statistical tests. As an example, we'll
use the `t.test()` function to perform a two sample t-test on the Chicago
ozone data.

First, let's visualize our dataset.


```{r ex-1b8d0bda5c30, warning = FALSE, message = FALSE, exercise = FALSE, eval = TRUE, exercise.cap = 'Visualize dataset'}
library(ggplot2)

ggplot(chicago_air, aes(factor(month), ozone)) + geom_boxplot()

```

We could compare ozone months in July and October and see if there is
a significant difference in concentrations. Below is a plot of those two
months side by side.


```{r ex-ca11aff787eb, warning = FALSE, message = FALSE, exercise = FALSE, eval = TRUE, exercise.cap = 'Compare two groups'}
library(dplyr)

ozone_july_october <- filter(chicago_air, month == 7 | month == 10)

ggplot(ozone_july_october, aes(factor(month), ozone)) + geom_boxplot()

```

We should also check for normality before doing any statistical tests. Below
are histograms of the datasets.


```{r ex-18852fd57412, exercise = FALSE, eval = TRUE, exercise.cap = 'Check for normality with histograms'}
ggplot(ozone_july_october, aes(ozone)) +
  facet_grid(rows = "month") +
  geom_histogram()

```

If plotting does not obviously show normality, we can use the built-in function
`shapiro.test()`. This function performs the Shapiro-Wilk test on a dataset, which
assumes that the dataset is normal. So the null hypothesis is that the dataset
comes from a normal distribution. If the p-value of the test is less than .05,
we reject the null hypothesis and conclude the data is not normal.


```{r ex-2484da21aadb, exercise = FALSE, eval = TRUE, exercise.cap = 'Shapiro-Wilk test for Group1'}
chicago_july <- filter(chicago_air, month == 7)

shapiro.test(chicago_july$ozone)

```

```{r ex-7a9950b84de1, exercise = FALSE, eval = TRUE, exercise.cap = 'Shapiro-Wilk test for Group2'}
chicago_october <- filter(chicago_air, month == 10)

shapiro.test(chicago_october$ozone)

```

The p-values for the tests are well above 0.05, so we assume the null
hypothesis is true. Meaning, we can assume the distributions of ozone
in the two months are normal.

Now we can do some comparisons between these 2 months of measurements
using the Student's t-test. The test is meant to determine if the two
means from the two datasets are from the same distribution or not. The
assumption, or null hypothesis, is that they are in fact mean values from
the same distribution.


```{r ex-c661b23c8185, exercise = FALSE, eval = TRUE, exercise.cap = 'Students t test between two groups'}
t.test(chicago_july$ozone, chicago_october$ozone)

```

The `t.test()` output shows a p-value well below .05, so we reject the null hypothesis.
Meaning, the two means are not from the same distribution, and we can consider the
two data sets significantly different in that sense.


## Other Statistical Tests

Below is a reference table of a few popular tests for categorical data analysis in R.


| test | function |
| --- | --- |
| Chi Square Test | `chisq.test()` |
| Fisher's Test | `fisher.test()` |
| Analysis of Variance | `aov()` |

The `EnvStats` package has a comprehensive list of basic and more advanced statistical
tests for Environmental Data.


```{r ex-1b9ce6350343, eval = FALSE}
library(EnvStats)

?FcnsByCatHypothTests

```

## Correlation Analysis

If we are interested in how closely the variables in our dataset are related
to each other, we can perform a correlation analysis.

A correlation matrix tells us how positively or negatively correlated each variable
is to the other variables. Below, we use the `cor()` function to print a correlation
matrix of the numeric columns in the `chicago_air` data frame, specifying in the
arguments that we only want to include complete observations and the Pearson method
of finding correlations.


```{r ex-a55ca0fd83da, exercise = FALSE, eval = TRUE, exercise.cap = 'Correlation matrix of select variables'}
data(chicago_air)

cor(chicago_air[, c("ozone", "temp", "pressure")],
    use = "complete.obs",
    method ="pearson")

```

Along the diagonal, the correlation value is 1, because each variable
is perfectly correlated with itself. The closer the other values are to
1 or -1, the more correlated the two variables are. A correlation value
of 0 means the two variables are not correlated at all. The matrix above
shows a weak correlation between ozone and temperature, a weak negative
correlation between air pressure and temperature, and no correlation between
ozone and air pressure.

We could also perform a correlation test using the `cor.test()` function.
Here we test the correlation between ozone and temperature.


```{r ex-fb10ff3825c6, exercise = FALSE, eval = TRUE, exercise.cap = 'Test correlation between two variables'}
cor.test(chicago_air$ozone, chicago_air$temp, method = "pearson")

```

The null hypothesis of the test is that the correlation is 0, there is
no correlation at all. The p-value is well below .05 so we reject the
null hypothesis and conclude that ozone and temperature are correlated
to some degree.

Running the test between ozone and air pressure gives a p-value above
.05 so we do not reject the null hypothesis. We conclude there is no
correlation between ozone and air pressure.


```{r ex-065a892b4a58, exercise = FALSE, eval = TRUE, exercise.cap = 'Test correlation between another set of two variables'}
cor.test(chicago_air$ozone, chicago_air$pressure, method = "pearson")

```

It's also useful to see pairwise plots for numeric values to see the
relationships between the variables. The built in `pairs()` function will
display a scatter plot between each pair of columns in the data frame.
Setting `lower.panel = panel.smooth` will draw a smooth line through the
scatter plots on the lower panels.


```{r ex-952a98f8db0e, exercise = FALSE, eval = TRUE, exercise.cap = 'Pairwise plots of select variables'}
pairs(chicago_air[, c("ozone", "temp", "pressure")], lower.panel = panel.smooth)

```

You can see from the lower panel plots the increasing slope of the line
for ozone and temp; a decreasing slope for temp and pressure; and a flat
line for ozone and pressure.



## Exercises


### Exercise 1

Find the mean and median of a specific column in the example data frame and compare the two values.

<details><summary>Click for Hint</summary>

> # Use the `mean()` function to calculate the mean of a specific column in a data frame. For example, `mean(data_frame$column_name)`.

</details>

<details><summary>Click for Hint</summary>

> # Similarly, use the `median()` function to find the median: `median(data_frame$column_name)`.

</details>

<details><summary>Click for Hint</summary>

> # To compare the mean and median, calculate the absolute difference between them using `abs(mean - median)`.

</details>

<details><summary>Click for Solution</summary>

#### Solution

Use the `mean()` and `median()` functions to calculate the mean and median of a specific column in the example data frame, respectively. To compare these two statistics, the absolute difference between them can be found using the `abs()` function. This comparison can help in understanding the distribution of the data, especially in identifying skewness.


```r
column_mean <- mean(data$column)
column_median <- median(data$column)
difference <- abs(column_mean - column_median)
list(mean = column_mean, median = column_median, difference = difference)

```

</details>

---


### Exercise 2

Use the Shapiro-Wilk normality test to see if a specific column in the example data frame is normally distributed.

<details><summary>Click for Hint</summary>

> # To perform a Shapiro-Wilk test, use the `shapiro.test()` function on the column of interest.

</details>

<details><summary>Click for Hint</summary>

> # For a specific column in the example data frame, the syntax is `shapiro.test(data_frame$column)`.

</details>

<details><summary>Click for Hint</summary>

> # Evaluate the p-value in the test's result to infer normality. A common threshold for normality is a p-value greater than .05.

</details>

<details><summary>Click for Solution</summary>

#### Solution

The Shapiro-Wilk normality test, applied with the `shapiro.test()` function, checks the hypothesis that a sample comes from a normally distributed population. In this case, applying it to a specific column in the example data frame provides a p-value, which, if above .05, suggests that the data can be considered normally distributed.


```r
test_results <- shapiro.test(data$column)
test_results

```

</details>

---


### Exercise 3

Create a correlation matrix of the numeric columns in the built-in `airquality` data frame. Use `data("airquality")` to load the data frame.

<details><summary>Click for Hint</summary>

> # First, load the `airquality` data frame into your R session using `data("aircount")`.

</details>

<details><summary>Click for Hint</summary>

> # Use the `cor()` function to calculate correlations among numeric columns. For selected columns, use `data_frame[, c("Column1", "Column2")]`.

</details>

<details><summary>Click for Hint</summary>

> # To handle missing values, add the argument `use = "complete.obs"` within the `cor()` function.

</details>

<details><summary>Click for Solution</summary>

#### Solution

To explore the relationships among the numeric variables in the `airquality` data frame, a correlation matrix can be generated using the `cor()` function. This matrix helps in identifying potential relationships between variables like Ozone, Solar.R, Wind, and Temp, considering only rows with complete observations.


```r
data("airquality")
correlation_matrix <- cor(airquality[, c("Ozone", "Solar.R", "Wind", "Temp")], use = "complete.obs")
correlation_matrix

```

</details>

---


### Exercise 4

Create pairwise plots for all of the numeric columns in the `airquality` data frame. Have the lower-panel plots generate a smooth line representing relationship between the two variables.

<details><summary>Click for Hint</summary>

> # Use the `pairs()` function to create pairwise plots for selected numeric columns in a data frame.

</details>

<details><summary>Click for Hint</summary>

> # To include a smooth line in the lower-panel plots, specify the argument `lower.panel = panel.smooth` in your `pairs()` function call.

</details>

<details><summary>Click for Hint</summary>

> # Select the numeric columns you want to plot by using `data_frame[, c("Column1", "Column2")]` syntax.

</details>

<details><summary>Click for Solution</summary>

#### Solution

Pairwise plots offer a comprehensive view of the relationships between all pairs of numeric variables in a dataset. In this case, applying the `pairs()` function to the `airquality` data frame, with the addition of a smooth line in the lower-panel plots using `panel.smooth`, provides insights into how variables like Ozone, Solar.R, Wind, and Temp interact with each other.


```r
pairs(airquality[, c("Ozone", "Solar.R", "Wind", "Temp")], lower.panel = panel.smooth)
```

</details>

---



