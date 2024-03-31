# Import the housing data set
hp <- read.csv("C:/Users/ONGC/Desktop/Thane project/HousingData.csv")

# Summarize the data to check the missing value and mean and median
summary(hp)

#structure of data
str(hp)

# Plot histogram for all variables

hist(hp$CRIM)          # Positively skewed
hist(hp$ZN)            # Bimodal 
hist(hp$INDUS)         # Positively skewed
hist(hp$CHAS)          # Binary values
hist(hp$NOX)           # Positively skewed
hist(hp$RM)            # Normally Distributed
hist(hp$AGE)           # Negatively skewed
hist(hp$DIS)           # Positively skewed
hist(hp$RAD)           # Bimodal (categorical)
hist(hp$TAX)           # Bimodal 
hist(hp$PTRATIO)       # Negatively Skewed
hist(hp$B)             # Negatively skewed 
hist(hp$LSTAT)         # Positively skewed
hist(hp$MEDV)          # approx Normal distribution

# Replacing the missing values with mean of respective variables

hp$CRIM <- ifelse(is.na(hp$CRIM), mean(hp$CRIM, na.rm=TRUE), hp$CRIM)
hp$ZN <- ifelse(is.na(hp$ZN), mean(hp$ZN, na.rm=TRUE), hp$ZN)
hp$INDUS <- ifelse(is.na(hp$INDUS), mean(hp$INDUS, na.rm=TRUE), hp$INDUS)
hp$AGE <- ifelse(is.na(hp$AGE), mean(hp$AGE, na.rm=TRUE), hp$AGE)
hp$LSTAT <- ifelse(is.na(hp$LSTAT), mean(hp$LSTAT, na.rm=TRUE), hp$LSTAT)
hp$CHAS[is.na(hp$CHAS)] = 0

# Check the correlation between the variables
cor(hp, hp$MEDV)

# Plot the data
plot(hp)

# Plot the histogram for the dependent variable to check the distribution
hist(hp$MEDV)
qqnorm(hp$MEDV)

# Build the model 
model = lm(MEDV ~ ., data = hp)

vif(model)

# Reduced model after removing the insignificant variables
model = lm(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + PTRATIO + B + LSTAT, data = hp)

# Summary of model
summary(model)

# Load car data 
library(car)

# to check the Outliers
outlierTest(model)

hp = hp[-c(369, 372, 373), ]

model1 = lm(MEDV ~ ., data = hp)

model1 = lm(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + PTRATIO + B + LSTAT, data = hp)

summary(model1)

library(predictmeans)

CookD(model)

hp = hp[-c(366), ]

model2 = lm(MEDV ~ ., data = hp)

model2 = lm(MEDV ~ CRIM + ZN + CHAS + NOX + RM + DIS + PTRATIO + B + LSTAT, data = hp)

summary(model2)

# To check the multicollinearity
vif(model2)

plot(model2)

hist(residuals(model2))

qqnorm(residuals(model2))

durbinWatsonTest(model2)

stp1=step(model2, direction = "both")
summary(stp1)

AIC(model2)

step(model2)

var(hp)

library(MASS)

stp1$anova
