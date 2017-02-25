setwd(paste("~/Documents/Koulu/Multivarite Statistical Analysis",
            "/Multivariate-Statistical-Analysis-of-Stock-Returns/Multi",sep = ""))
rm(list = ls())
# install.packages('fImport')
# install.packages('Hmisc')
library(fImport)
library(Hmisc)


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
DJIA_symbols <- read.csv('DJIA_symbols',sep = '\n',header = FALSE)
DJIA_symbols <- c(paste0("",unlist(DJIA_symbols)),'^DJI')

# get data
start <- as.Date('2015-3-19')
end <- as.Date('2017-2-19')
DailyAdjPriceData <- getStockAdjacentPriceData(DJIA_symbols,end,start)
# use tickers as colnames
names(DailyAdjPriceData) <- DJIA_symbols

# Delete col with NA values
# DailyAdjPriceData <- cleanData(DailyAdjPriceData)
# Delete dropped col ticker
# DJIA_symbols <- DJIA_symbols[is.element(DJIA_symbols,colnames(DailyAdjPriceData))]
write.csv(DailyAdjPriceData,'price_data')

# compute log-returns from adjacent prices
DailyReturnsData <- as.data.frame(apply(DailyAdjPriceData,2,calculateLogReturns))
names(DailyReturnsData) <- DJIA_symbols
# add log return of the whole index


write.csv(DailyReturnsData,'returns_data')