# 일자, 가격만 추출
gold <- read.csv("C:/Users/H/BTC_Analysis/data/Goldyear.csv")
gold <- gold[1:2]
names(gold) <- c("date", "price")

gold$price <- gsub(",", "", gold$price)

# 반올림
gold$price <- round(as.numeric(gold$price))
View(gold)
