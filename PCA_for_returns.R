setwd(paste("~/Documents/Koulu/Multivarite Statistical Analysis",
            "/Multivariate-Statistical-Analysis-of-Stock-Returns",sep = ""))
rm(list = ls())
library(ggplot2)
library(factoextra)

returns <- read.csv('returns_data',header = TRUE, row.names = 1)

# PCA
djia_index <- length(returns)
pca.returns <- prcomp(returns[,-djia_index],center = T, scale. = T)
score1 <- scale(pca.returns$x)[,1]
fviz_screeplot(pca.returns)
summary(pca.returns)

# Visualize cumulative return when only first principle component is interpreted
djiaCumulativeReturn <- 100 * exp(cumsum(returns[,djia_index]))
pcaCumulativeReturn <- 100 * exp(cumsum(score1 * 
                                          sd(returns[,djia_index])))
dates <- as.Date(row.names(returns),format = "%Y-%m-%d")

plotDF1 <- data.frame(dates,pcaCumulativeReturn,djiaCumulativeReturn)
colnames(plotDF1) <- c('date','pca','index')
g <- ggplot(plotDF1, aes(x = date)) +
  geom_line(aes(y=pca,colour = 'PCA')) +
  geom_line(aes(y=index,colour = 'DJIA')) +
  scale_colour_manual(values=c("orange", "black")) +
  labs(y = 'Cumulative Return',x = 'Year')
g

# visualize data scatter and direction of first principal component's eigenvector
x = mean(score1)
y = mean(returns[,1])
plotDF2 <- data.frame(score1,returns[,djia_index])
colnames(plotDF2) <- c('score1','djia')
p <- ggplot(plotDF2, aes(x = score1))+
  geom_point(aes(y = djia))
  geom_line(aes(y = eigenvector1))
p

  



