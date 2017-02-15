setwd(paste("~/Documents/Koulu/Multivarite Statistical Analysis",
            "/Multivariate-Statistical-Analysis-of-Stock-Returns",sep = ""))
rm(list = ls())
library(ggplot2)
library(reshape)

returns <- read.csv('returns_data',header = TRUE, row.names = 1)
# standardize data
scaled.returns = scale(returns)

# PCA
pca.return <- princomp(scaled.returns[,-1])
plot(pca.return)
summary(pca.return)

# Replicate index with 1st. principal component
pred <- predict((pca.return), as.data.frame(returns[,-1]))


# Visualize
df <- as.data.frame(cbind(1:2014,-1*pred[,1],returns[,1]))
g <- ggplot(df, aes(V1)) +
  geom_line(aes(y=V2), colour="red") +
  geom_line(aes(y=V3), colour="green")
g


