file_name <- "C:/Users/H/BTC_Analysis/data/BTCweek/amCharts"
BTC <- read.csv(paste0(file_name, ".csv"))
for(index in 1:7){
  tmp <- read.csv(paste0(file_name, " (", index, ").csv"))
  BTC <- rbind(BTC, tmp)
}
BTC <- BTC[order(BTC$date),]
str(BTC)
View(BTC)
