setwd(paste("~/Documents/Koulu/Multivarite Statistical Analysis",
            "/Multivariate-Statistical-Analysis-of-Stock-Returns/",sep = ""))
rm(list = ls())
# install.packages('fImport')
# install.packages('Hmisc')
library(fImport)
library(Hmisc)
library(ggplot2)
library(reshape2)

getStockAdjacentPriceData <- function(stock_symbols, end, start=Sys.timeDate()){
  # get data from yahoo finance and delete unnecessary data
  df <- as.data.frame(yahooSeries(stock_symbols,from = start,to = end))
  colIndices <- seq(1,ncol(df),by = 1)
  removeIndices <- colIndices[-seq(6,ncol(df),by = 6)]
  df <- df[,-removeIndices]
  return(df)
}

calculateLogReturns <- function(x){
  return(log(x / Lag(x,shift = 1))[2:length(x)])
}

cleanData <- function(df){
  df <- df[,!colSums(is.na(df)) > 0]
  return(df)
}

# get tickers of DJIA companies
DJIA_symbols <- read.csv('generated data//DJIA_symbols',sep = '\n',header = FALSE)
DJIA_symbols <- c(paste0("",unlist(DJIA_symbols)))

# get data
start <- as.Date('2015-3-19')
end <- as.Date('2017-2-19')
DailyAdjPriceData <- getStockAdjacentPriceData(DJIA_symbols,end,start)
# use tickers as colnames
names(DailyAdjPriceData) <- DJIA_symbols
summary(DailyAdjPriceData)

#Visualize price data
row.names(DailyAdjPriceData) <- as.Date(rownames(DailyAdjPriceData),format = "%Y-%m-%d")
for (i in c(10,20,30)){
  PriceData.mat <- as.matrix(DailyAdjPriceData[,(i+1-10):i])
  PriceData.melt <- melt(PriceData.mat)
  colnames(PriceData.melt) <- c('Date','Company','Price')
  g <-ggplot(data = PriceData.melt, 
             aes(x = as.Date(Date),y =Price,colour = Company, group = Company)) +
    geom_line() +
    labs(y = 'Share Price ($)') +
    scale_x_date("Date",date_breaks = "1 month", date_labels = "%Y-%m") +
    theme(text = element_text(size=10),
          axis.text.x = element_text(angle=45, hjust=1))
  filename <- paste("price_time_series",i,".png",sep = "")
  png(filename = filename,units = "mm",width = 140 , height = 90,res = 500)
  print(g)
  dev.off()
}

write.csv(DailyAdjPriceData,'generated data/price_data')


# compute log-returns from adjacent prices
DailyReturnsData <- as.data.frame(apply(DailyAdjPriceData,2,calculateLogReturns))
names(DailyReturnsData) <- DJIA_symbols

# example visualization of log-returns data
row.names(DailyReturnsData) <- as.Date(rownames(DailyReturnsData),format = "%Y-%m-%d")
MMMlogReturns.mat <- as.matrix(DailyReturnsData[,1:2])
MMMlogReturns.melt <- melt(MMMlogReturns.mat)
MMMlogReturns.melt$Var1 <- MMMlogReturns.melt$Var1[MMMlogReturns.melt$Var2 == "MMM"]
MMMlogReturns.melt$Var2 <- MMMlogReturns.melt$Var2[MMMlogReturns.melt$Var2 == "MMM"]
MMMlogReturns.melt$value <- MMMlogReturns.melt$value[MMMlogReturns.melt$Var2 == "MMM"]
colnames(MMMlogReturns.melt) <- c('Date','Company','Return')
g <- ggplot(data = MMMlogReturns.melt, 
           aes(x = as.Date(Date),y = Return,colour = Company, group = Company)) +
  geom_line() +
  labs(y = 'Share Log-returns ($)') +
  scale_x_date("Date",date_breaks = "1 month", date_labels = "%Y-%m") +
  theme(text = element_text(size=10),
        axis.text.x = element_text(angle=45, hjust=1))
filename <- "MMM_log_return_time_series.png"
png(filename = filename,units = "mm",width = 140 , height = 90,res = 500)
print(g)
dev.off()

write.csv(DailyReturnsData,'generated data/returns_data')
