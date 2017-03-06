setwd(paste("~/Documents/Koulu/Multivarite Statistical Analysis",
            "/Multivariate-Statistical-Analysis-of-Stock-Returns",sep = ""))
rm(list = ls())
source('multiplot.R')
library(ggplot2)
library(factoextra)



returns <- read.csv('generated data/returns_data',header = TRUE, row.names = 1)



# PCA
djia_index <- length(returns)
pca.returns <- prcomp(returns[,-djia_index],center = T, scale. = T)
score1 <- scale(pca.returns$x)[,1]
fviz_screeplot(pca.returns,ncp = 29,choice = 'variance')
summary(pca.returns)
pca.returns$rotation

# Visualize cumulative return when only first principle component is interpreted
djiaCumulativeReturn <- 100 * exp(cumsum(returns[,djia_index]))
pcaCumulativeReturn <- 100 * exp(cumsum(-score1 *
                                          sd(returns[,djia_index])))

dates <- as.Date(row.names(returns),format = "%Y-%m-%d")

plotDF1 <- data.frame(dates,pcaCumulativeReturn,djiaCumulativeReturn)
colnames(plotDF1) <- c('date','pca','index')
g <- ggplot(plotDF1, aes(x = date)) +
  geom_line(aes(y=pca,colour = 'PCA')) +
  geom_line(aes(y=index,colour = 'DJIA')) +
  scale_colour_manual(values=c("orange", "black")) +
  labs(y = 'Cumulative Return',x = 'Year')


# visualize loadings
dev.off()
plotDF3 <- data.frame(row.names(pca.returns$rotation),
                      pca.returns$rotation,row.names = NULL)
colnames(plotDF3) <- c('ticker',colnames(pca.returns$rotation))
plotlist = list()
pcs <- colnames(plotDF3)[2:31]
j = 1
for (i in seq_along(pcs)){
  h <- ggplot(plotDF3, aes_string(x = "ticker",y = pcs[i])) +
    geom_bar(stat = "identity",color = "black",fill = "steelblue") +
    labs(x = 'Company') +
    theme(text = element_text(size=10),
          axis.text.x = element_text(angle=90, hjust=1))
  plotlist[[j]] = h
  if (pcs[i] == "PC6" || pcs[i] == "PC12" || pcs[i] == "PC18" ||
      pcs[i] == "PC24" || pcs[i] == "PC30"){
    filename <- paste("princomp_till",pcs[i],".png",sep = "")
    png(filename = filename,units = "mm",width = 260 , height = 180,res = 500)
    multiplot(plotlist = plotlist,cols = 3)
    plotlist = list()
    j = 0
    dev.off()
  }
  j = j + 1
}



  



