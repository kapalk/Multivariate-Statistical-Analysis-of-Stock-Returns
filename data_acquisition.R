rm(list = ls())
install.packages('fImport')
library(fImport)



getStockAdjacentPriceData <- function(stock_symbols, end, start=Sys.timeDate()){
df <- as.data.frame(yahooSeries(stock_symbols,from = start,to = end))
  colIndices <- seq(1,ncol(df),by = 1)
  removeIndices <- colIndices[-seq(6,ncol(df),by = 6)]
  df <- df[,-removeIndices]
  return(df)
}

SP500_symbols <- read.csv('sp500_symbols',sep = '\n',header = FALSE)
SP500_symbols <- c(paste0("",unlist(SP500_symbols)),'^GSPC')
start <- as.Date('2015-1-1')
end <- as.Date('2016-1-1')
data <- getStockAdjacentPriceData(SP500_symbols,end,start)
write.csv(data,'adjacent_price_data')



