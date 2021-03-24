### 날짜별
### 하루 중 가격 변동이 큰 시간대와 작은 시간대 구하기
library(dplyr)

### 데이터 읽기
BTCweek <- read.csv(file="C:/Users/H/BTC_Analysis/processing_code/BTCweek.csv")[-1]
#BTCweek$date <- as.Date(BTCweek$date, "%Y-%m-%d")
str(BTCweek)

### 날짜별 최대 최소 가격 - df : price
BTCweek %>% 
  group_by(date) %>%
  summarise(high=max(high), low=min(low)) -> price

fluctuation <- NULL
len <- count(BTCweek)$n # 행 갯수
for(index in 1:len){
  numerator <- (BTCweek$high[index]-BTCweek$low[index])*100
  denominator <- price[price$date==BTCweek$date[index],]$high[1]-price[price$date==BTCweek$date[index],]$low[1]
  fluctuation <- c(fluctuation, numerator/denominator)
}
BTCweek <- cbind(BTCweek, fluctuation)
View(BTCweek)

### 샘플로 시간별 변동 추이 4개의 선그래프 그려보기
par(mfrow=c(2,2), mar=c(3,3,4,2))

plot(1:12, BTCweek$fluctuation[1:12], type='l', axes=F)
axis(1,at=1:12,lab=BTCweek$hours[1:12])
axis(2,ylim=c(0,100))
box()

plot(1:12, BTCweek$fluctuation[13:24], type='l', axes=F)
axis(1,at=1:12,lab=BTCweek$hours[1:12])
axis(2,ylim=c(0,80))
box()

plot(1:12, BTCweek$fluctuation[25:36], type='l', axes=F)
axis(1,at=1:12,lab=BTCweek$hours[1:12])
axis(2,ylim=c(0,100))
box()

plot(1:12, BTCweek$fluctuation[37:48], type='l', axes=F)
axis(1,at=1:12,lab=BTCweek$hours[1:12])
axis(2,ylim=c(0,100))
box()
par(mfrow=c(1,1), mar=c(5,4,4,2)+.1)


#### 이상치 확인 (박스그래프)
# 박스그래프 그리기 - df : box
box <- BTCweek
box$hours <- factor(box$hours, levels = box$hours[1:12])
boxplot(fluctuation~hours,         
        data=box,                     
        xlab="시간대", ylab="가격 변동률",
        main='가격 변동률 이상치 확인',        
        col=rainbow(12))
str(box)
dev.copy(png, "C:/Users/H/BTC_Analysis/output/BTCweek_fluctuation_boxplot.png", height=500, width=500)
dev.off()

# 이상치 확인 및 날짜 추출
strange_date <- NULL
strange_num <- NULL

num <- NULL # 시간대별 이상치 수
for(index in 1:12){
  strange <- boxplot.stats(box[box$hours==box$hours[index],]$fluctuation)$out
  list <- unique(subset(box, box$fluctuation %in% strange))
  strange_date <- c(strange_date, list$date)
  num <- c(num, count(list)$n)
}
strange_num <- data.frame(BTCweek$hours[1:12], num)
names(strange_num) <- c("hours", "num")
  
table(strange_date)

### 이상치 확인된 날짜 빼기
# 변동추이 그래프 생성하기 
# 이상치가 확인되지 않은 날짜 - df : no_strange_BTCweek
# 변동률 큰 시간대 : 이익 많이 내고싶은 투자자 추천
# 변동률 적은 시간대 : 안전하게 거래하고 싶은 투자자 추천
no_strange_BTCweek <- subset(BTCweek, !(date %in% strange_date))
write.csv(no_strange_BTCweek, file="C:/Users/H/BTC_Analysis/analysis_code/no_strange_BTCweek_price.csv")


### 중앙값? 평균값? 
par(mfrow=c(1,2), mar=c(3,3,4,2))
# 중앙값으로 선그래프 그렸을 때 - 중앙값 선택! 표본의 격차가 크기 때문에 
test <- no_strange_BTCweek
test$hours <- factor(test$hours, levels = test$hours[1:12])
new_box <- NULL
for(index in 1:12){
  stats <- boxplot.stats(box[box$hours==box$hours[index],]$fluctuation)$stats
  new_box <- c(new_box, stats[3])
}
plot(1:12, new_box, 
     main="시간대별 가격 변동 추이", 
     type='b',
     col='blue',
     xlab="시간대", ylab="가격 변동률",
     lwd=2, 
     ylim=c(10,30), 
     axes=F)
axis(1,at=1:12,lab=test$hours[1:12])
axis(2,ylim=c(10,40))
box()
dev.copy(png, "C:/Users/H/BTC_Analysis/output/BTCweek_fluctuation_lineplot.png", height=700, width=700)
dev.off()

# 평균값으로 선그래프 그렸을 때
test <- no_strange_BTCweek
new_box <- NULL
avg <- test %>% group_by(hours) %>% summarise(mean=mean(fluctuation))
plot(1:12, avg$mean, 
     main="시간대별 가격 변동 추이", 
     type='b', 
     xlab="시간대", ylab="변동률", 
     ylim=c(10,30), 
     axes=F)
axis(1,at=1:12,lab=test$hours[1:12])
axis(2,ylim=c(10,40))
box()

par(mfrow=c(1,1), mar=c(5,4,4,2)+.1)


### 이상치 확인된 날짜의 wordcloud (BTCweek_price_wordcloud.R)
write.csv(data.frame(strange_date), file="C:/Users/H/BTC_Analysis/analysis_code/price_strange_date.csv")

### 이상치 많이 확인된 시간대 = 변화무쌍하니 조심하쇼 # 막대그래프로 나타내기!!!
strange_num
