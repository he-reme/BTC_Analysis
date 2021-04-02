# 8주 비트코인 데이터터 전처리

library(dplyr)

### 1차 전처리 (8개의 파일 합치기)
file_name <- "C:/Users/H/BTC_Analysis/data/BTCweek/amCharts"
BTC <- read.csv(paste0(file_name, ".csv"))
for(index in 1:7){
  tmp <- read.csv(paste0(file_name, " (", index, ").csv"))
  BTC <- rbind(BTC, tmp)
}
BTC <- BTC[order(BTC$date),]
str(BTC)
View(BTC)

### 2차 전처리
# 변수 : date(날짜), hours(시간대), 
#        low(최소가격), high(최대가격), volume(거래량)
BTCweek <- NULL
hour <- 0 # 시간대 처리

len <- count(BTC)$n # 행 갯수
for(index in 1:len){
  hour <- hour+1
  if(hour==25)
    hour <- 1
  
  if(index%%2==1) next 
  
  date <- as.Date(BTC$date[index-1], "%Y-%m-%d %H:%M:%S")
  date <- format(date, "%Y-%m-%d")
  if(is.na(date)){
    date <- as.Date(BTC$date[index], "%Y-%m-%d %H:%M:%S")
    date <- format(date, "%Y-%m-%d")
  }
  BTCweek <- rbind(BTCweek, 
                   c(date, paste0(hour-1, "~", hour), 
                     (BTC$low[index-1]+BTC$low[index])/2,
                     (BTC$high[index-1]+BTC$high[index])/2,
                     (BTC$volume[index-1]+BTC$volume[index])/2))
}

BTCweek <- data.frame(BTCweek)
names(BTCweek) <- c("date", "hours", "low", "high", "volume")
BTCweek$low <- round(as.numeric(BTCweek$low))
BTCweek$high <- round(as.numeric(BTCweek$high))
BTCweek$volume <- round(as.numeric(BTCweek$volume))
View(BTCweek)

write.csv(BTCweek, file="C:/Users/H/BTC_Analysis/processing_code/BTCweek.csv")
