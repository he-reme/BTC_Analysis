BTCyear <- read.csv("C:/Users/H/BTC_Analysis/data/BTCyear.csv")
View(BTCyear)

BTCyear$date <- as.Date(BTCyear$date, "%Y-%m-%d %H:%M:%S")
BTCyear$date <- format(BTCyear$date, "%Y-%m-%d")

BTCyear$low <- round(as.numeric(BTCyear$low))
BTCyear$high <- round(as.numeric(BTCyear$high))
BTCyear$volume <- round(as.numeric(BTCyear$volume))
View(BTCyear)

write.csv(BTCyear, file="C:/Users/H/BTC_Analysis/processing_code/BTCyear.csv")
