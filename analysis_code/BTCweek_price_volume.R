### [거래량 - 가격] 하나의 도화지에 추이 선 그래프로 나타내기
price <- read.csv("C:/Users/H/BTC_Analysis/analysis_code/no_strange_BTCweek_price.csv")
volume <- read.csv("C:/Users/H/BTC_Analysis/analysis_code/no_strange_BTCweek_volume.csv")

# 가격 변동률 그래프
price$hours <- factor(price$hours, levels = price$hours[1:12])
price_box <- NULL
for(index in 1:12){
  stats <- boxplot.stats(price[price$hours==price$hours[index],]$fluctuation)$stats
  price_box <- c(price_box, stats[3])
}

plot(1:12, price_box, 
     main="시간대별 가격변동률 및 거래량 추이", 
     type='l', 
     xlab="시간대", 
     ylab="",
     ylim=c(10,30),
     col="blue",
     axes=F)
axis(1,at=1:12,lab=test$hours[1:12])
box()

# 거래량 그래프
volume$hours <- factor(volume$hours, levels = volume$hours[1:12])
volume$volume <- volume$volume/1000000000
volume_box <- NULL
for(index in 1:12){
  stats <- boxplot.stats(volume[volume$hours==volume$hours[index],]$volume)$stats
  volume_box <- c(volume_box, stats[3])
}
lines(1:12, volume_box, 
     type='l',
     col="red")

legend(x='bottomright', c("price", "volume"), cex=0.8, col=c("blue", "red"), lty=c(1,1))
dev.copy(png, "C:/Users/H/BTC_Analysis/output/BTCweek_fluctuation_volume.png", height=700, width=700)
dev.off()


# 시간 남으면 다른 가설...