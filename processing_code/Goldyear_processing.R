# 일자, 가격만 추출
Goldyear <- read.csv("C:/Users/H/BTC_Analysis/data/Goldyear.csv")
Goldyear <- gold[1:2]
names(Goldyear) <- c("date", "price")

Goldyear$price <- gsub(",", "", Goldyear$price)
names(Goldyear) <- c("date", "price")
View(Goldyear)
# 날짜 전처리
Goldyear$date <-  as.Date(Goldyear$date, "%Y.%m.%d")
Goldyear$date <- format(Goldyear$date, "%Y-%m-%d")
Goldyear <- Goldyear[order(Goldyear$date),]

# 가격 반올림
Goldyear$price <- round(as.numeric(Goldyear$price))
View(Goldyear)

write.csv(Goldyear, file="C:/Users/H/BTC_Analysis/processing_code/Goldyear.csv")
