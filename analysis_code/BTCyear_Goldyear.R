# 날짜에 따른 금의 가격과 비트코인 가격의 상관관계.. 
# 비트코인은 날짜별 최고가격으로 전처리 시키기
BTCyear <- read.csv("C:/Users/H/BTC_Analysis/processing_code/BTCyear.csv")[-1]
View(BTCyear)
max_volume <- max(BTCyear$volume)
date <- BTCyear[BTCyear$volume==max_volume, c("date")]

Goldyear <- read.csv("C:/Users/H/BTC_Analysis/processing_code/Goldyear.csv")[-1]
View(Goldyear)

# 금 데이터셋 행이 비트코인의 데이터셋 행보다 더 적음 
# = innder조인으로 해결
count(BTCyear)$n
count(Goldyear)$n

df <- inner_join(BTCyear, Goldyear, by="date") # 1~len
View(df)
len <- count(df)$n

tmp <- df[1:(len/2),c("date", "high", "price")] # 1~len/2
View(tmp)
tmp_len <- count(tmp)$n

par(mfrow=c(1,2), mar=c(3,3,4,2))
plot(1:len, df$high, main='비트코인', type='l')
plot(1:len, df$price, main='금', type='l')
par(mfrow=c(1,1), mar=c(5,4,4,2)+.1)
dev.copy(png, "C:/Users/H/BTC_Analysis/output/BTC_GOLD_1year.png", height=700, width=700)
dev.off()

par(mfrow=c(1,2), mar=c(3,3,4,2))
plot(1:tmp_len, tmp$high, main='비트코인', type='l')
plot(1:tmp_len, tmp$price,  main='금', type='l')
par(mfrow=c(1,1), mar=c(5,4,4,2)+.1)
dev.copy(png, "C:/Users/H/BTC_Analysis/output/BTC_GOLD_05year.png", height=700, width=700)
dev.off()

### 예측 모델
# 상관계수 구해보자
cor(df$price, df$high) # -0.4766001
cor(tmp$price, tmp$high) # 0.8683382

cor.test(df$price, df$high)
cor.test(tmp$price, tmp$high)

# 1년 데이터 사용
# 비트코인 가격이 올라갈수록 금가격은 떨어지고
# 금가격이 높을수록 비트코인 가격은 높고
plot(df$price, df$high, xlab="금", ylab="비트코인")
abline(lm(high~price, data=df), col='red', lty=2)
dev.copy(png, "C:/Users/H/BTC_Analysis/output/BTC_GOLD_1year_plot.png", height=700, width=700)
dev.off()

# 반년 데이터 사용 
# 금과 비트코인 상관관계 굳
plot(tmp$price, tmp$high, xlab="금", ylab="비트코인")
abline(lm(high~price, data=tmp), col='red', lty=2)
dev.copy(png, "C:/Users/H/BTC_Analysis/output/BTC_GOLD_05year_plot.png", height=700, width=700)
dev.off()

df.lm <- lm(high~price, data=tmp)

summary(df.lm)

# 비슷 하다!
predict(df.lm, data.frame(price=df$price[tmp_len+1]))
df$high[tmp_len+1]
predict(df.lm, data.frame(price=df$price[tmp_len+4]))
df$high[tmp_len+4]

# predict_df 만들기
predict_df <- df
predict_high <- NULL
for(index in 1:len){
  high <- predict(df.lm, data.frame(price=df$price[index]))
  predict_high <- c(predict_high, high)
}
predict_df <- cbind(predict_df, predict_high)
View(predict_df)

day <- 15 # 이 값만 변경해주면 범위 변경 가능
df$date[tmp_len+day]

### 같은 그래프 안에 예측과 실제 그래프 그려보기
# 예측 그래프
plot(1:(tmp_len+day), predict_df$predict_high[1:(tmp_len+day)], 
     main="금 가격에 따른 비트코인 가격 예측", 
     type='l', 
     xlab="날짜", 
     ylab="가격",
     col="red",
     axes=F)
axis(1,at=1:(tmp_len+day),lab=df$date[1:(tmp_len+day)])
axis(2, ylim=c(0,20))
box()

# 실제 그래프
lines(1:(tmp_len+day), df$high[1:(tmp_len+day)],
      type='l',
      col="blue")
legend(x='bottomright', c("예측 그래프", "실제 그래프"), cex=0.8, col=c("red", "blue"), lty=c(1,1))
dev.copy(png, "C:/Users/H/BTC_Analysis/output/BTC_predict.png", height=700, width=700)
dev.off()

### 나중에 더 해보고 싶은 것
# 반대로 최근 반년으로 구해보면?
# 예측과 실제 값 비교 (반년 전까지만 해도 금과 상관관계 굳)
# 아마 요즘에는 그냥 비트코인에 관심이나 이슈가 많아서 잘 맞지 않는다고 생각됨.
# 진정되고 나면 금 시세와 관련돼서 봐도 나쁘지 않을 듯.
###
