# Sparse regression example for murder data Abstract: Communities in the US.
# Data combines socio-economic data from the '90 Census, law enforcement
# data from the 1990 Law Enforcement Management and Admin Stats survey, and
# crime data from the 1995 FBI UCR
# Download data from UCI Machine Learning Repository: http://archive.ics.uci.edu/ml/datasets/Communities+and+ Crime+Unnormalized.
dat <- read.table("CommViolPredUnnormalizedData.txt", sep = ",", header = FALSE) dim(dat)

dat[dat == "?"] = NA
x <- as.matrix(dat[, 6:129])
x <- matrix(as.numeric(x), nrow = nrow(x)) y <- as.numeric(dat[, 131])
names <- read.table("CommViolNames.txt", sep = "\n", header = FALSE) names <- as.character(unlist(names))
for (i in 1:length(names)) {
names[i] <- substring(text = strsplit(names[i], ":")[[1]][1], first = 4) }
colnames(x) <- names[6:129]
# Remove columns with NA's
i <- which(colSums(is.na(x)) > 0) x <- x[, -i]
p <- ncol(x)

library(lars)
library(MASS)
# center x and y, and scale x
yc <- y - mean(y)
xc <- scale(x, center = TRUE, scale = TRUE)
# target df
tar.df <- 5

 Ridge
# To start,  try out a few different lambda values that are
# well spaced out from each other to get a sense of what range of values you
# would want to search in
# fit ridge regression using lambdas froms 20000 to 30000
lam.seq <-seq(from = 20000, to = 30000, by = 500) mod.rid = lm.ridge(yc ~ xc + 0, lambda = lam.seq) # calculate degrees of freedom at each lambda df.rid = sapply(lam.seq, function(lam) {
sum(diag(xc %*% solve(t(xc) %*% xc + lam * diag(1, p)) %*% t(xc))) })
# find lambda at which degree of freedom is closest to 5
df.rid

(lam.rid <- lam.seq[which.min(abs(df.rid - 5))])

# extract coefficients from model with lam.rid 
dim(mod.rid$coef) # row: variable; column: lambda

coef.rid <- mod.rid$coef[, which(mod.rid$lambda == lam.rid)] # clean up variable names by removing the leading 'xc's names(coef.rid) = substring(names(coef.rid), 3)
# are all coefficients non-zero?
sum(coef.rid != 0)

#With ridge regression, λ = 27500 results in a model with approximately 5 degrees of freedom. All of the 101 variables have non-zero coefficients in this model (as expected). The coefficient estimates are reported in Figure 5.

# LASSO
# fit lasso regression using the default range of lambdas used by lars()
mod.las <- lars(x = xc, y = yc, type = "lasso", trace = FALSE, normalize = FALSE, intercept = FALSE)
# find lambda at which degree of freedom is 5
(lam.las <- mod.las$lambda[mod.las$df == tar.df])

# extract coefficients from model with lam.las
coef.las <- predict(mod.las, type = "coef", s = lam.las, mode = "lambda")$coef # alternative (first row in $beta is all 0 and corresponds to when lambda=0; # therefore you need to +1 to the row index):
coef.las.alter <- mod.las$beta[which(mod.las$df == tar.df) + 1, ]
# verify that the number of non-zero coefficients is 5
sum(coef.las != 0)
# what are the variables with non-zero coefficients?
round(coef.las[coef.las != 0], 3)

# With LASSO regression, λ = 3536.114 results in a model with exactly 5 degrees of freedom. That is, 5 of the 101 variables have non-zero coefficients. These variables and their coefficient estimates are:
#• percentage of population that is 12-29 in age (0.711)
#• percentage of population that is 16-24 in age (-1.819)
#• number of kids born to never married (-0.684)
#• percentage of immigrants who immigated within last 10 years (1.383) • owner occupied housing - lower quartile value (1.023)

# visualization

# plot ridge regression coefficient estimates
par(mar = c(7, 5, 4, 2) + 0.1) 
plot(x = 1:p, y = coef.rid, ylim = range(c(coef.rid, coef.las)), xaxt = "n",
    xlab = "", ylab = "Coefficient Estimates", col = "red", pch = 1, cex.lab = 1.5,
cex.axis = 1.5, cex = 0.7)
axis(side = 1, at = 1:p, labels = names(coef.rid), las = 2, cex.axis = 0.5) mtext(text = "Parameters", side = 1, line = 6, cex = 1.5)
# plot lasso regression coefficient estimates
points(x = 1:p, y = coef.las, col = "blue", cex = 0.7, pch = 4)
# plot legend
legend("bottomright", legend = c("Ridge", "LASSO"), col = c("red", "blue"),
pch = c(1, 4), cex = 1.5)
