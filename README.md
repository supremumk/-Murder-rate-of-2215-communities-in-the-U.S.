# Murder-rate-of-2215-communities-in-the-U.S.
Suppose we are interested in studying the murder rate (per 100K people) of n = 2215 communities in the U.S. Our goal is to
predict the murder rate as a linear function of these attributes. For the purposes of interpretation, it would be helpful to 
have a linear model involving only a small subset of these attributes.

### Fit the data using ridge regression and lasso that has approximately 5 degrees of freedom.

### Produce a plot that has parameter vs. coefficient estimatefor ridge and lasso. 

![alt tag](https://github.com/supremumk/-Murder-rate-of-2215-communities-in-the-U.S./blob/master/lasso%20vs.%20ridge.png)

With reference to Figure 5, whereas all but 5 of the 101 variables have coefficients shrunk to exactly 0 in LASSO regression; all of the 101 variables have non-zero, albeit small or almost zero, coefficients in ridge regression.
LASSO regression is easier to interpret, as the fact that it shrinks some coefficients to exactly zero provides a means of variable selection, leading to a model with only 5 predictors that is relatively easy to comprehend. In contrast, ridge regression does not allow for variable selection, leading to a model with 101 predictors. The sheer number of predictors present in the ridge regression model makes it hard to interpret, which is further complicated by the fact that many of the predictors have very tiny yet non-zero coefficient estimates.
