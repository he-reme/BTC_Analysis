# 날짜별
# 하루 중 가격 변동이 큰 시간대와 작은 시간대 구하기
library(dplyr)

BTCweek <- read.csv(file="C:/Users/H/BTC_Analysis/processing_code/BTCweek.csv")[-1]
#BTCweek$date <- as.Date(BTCweek$date, "%Y-%m-%d")
str(BTCweek)
View(BTCweek)
# 날짜별 최대 최소 가격
BTCweek %>% 
  group_by(date) %>%
  summarise(high=max(high), low=min(low)) -> price
View(price)
fluctuation <- NULL
len <- count(BTCweek)$n # 행 갯수
for(index in 1:len){
  numerator <- (BTCweek$high[index]-BTCweek$low[index])*100
  denominator <- price[price$date==BTCweek$date[index],]$high[1]-price[price$date==BTCweek$date[index],]$low[1]
  fluctuation <- c(fluctuation, numerator/denominator)
}
BTCweek <- cbind(BTCweek, fluctuation)
View(BTCweek)


# 다 같은 범위에서 보는 그래프프
par(mfrow=c(2,2), mar=c(3,3,4,2))

plot(1:12, BTCweek$fluctuation[1:12], ylim=c(0,80), type='l', axes=F)
axis(1,at=1:12,lab=BTCweek$hours[1:12])
axis(2,ylim=c(0,80))
box()

plot(1:12, BTCweek$fluctuation[13:24], ylim=c(0,80), type='l', axes=F)
axis(1,at=1:12,lab=BTCweek$hours[1:12])
axis(2,ylim=c(0,80))
box()

plot(1:12, BTCweek$fluctuation[25:36], ylim=c(0,80), type='l', axes=F)
axis(1,at=1:12,lab=BTCweek$hours[1:12])
axis(2,ylim=c(0,80))
box()

plot(1:12, BTCweek$fluctuation[37:48], ylim=c(0,80), type='l', axes=F)
axis(1,at=1:12,lab=BTCweek$hours[1:12])
axis(2,ylim=c(0,80))
box()

