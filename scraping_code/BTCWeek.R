# 비트코인 시세 차트 

library(RSelenium)

remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()

remDr$navigate("https://kr.cointelegraph.com/bitcoin-price-index")
Sys.sleep(3)

# 차트 부분으로 스크롤
webElem <- remDr$findElement("css selector", "body")
remDr$executeScript("scrollTo(0, 1000)", args = list(webElem))

# 일주일 단위 차트 보기
weekButton <- remDr$findElement(using='css selector', '#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div.tabsPeriodsContainer > a:nth-child(2)')
weekButton$clickElement() 

# 월마다의 날짜 수
day <- c(31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

month <- 3
from <- 12
to <- 18

# 8주 데이터 수집
for(i in 1:8){
  # 달력은 8까지 의미 없음 index + 8 = 원하는 날짜
  # from
  fromInput <- remDr$findElement(using='css selector','#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div:nth-child(2) > div.chart-filter.active > div:nth-child(1) > div > div:nth-child(1) > input[type=text]')
  fromInput$clickElement()
  fromInput <- remDr$findElement(using='css selector', paste0('#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div:nth-child(2) > div.chart-filter.active > div:nth-child(1) > div > div:nth-child(2) > div > span:nth-child(', from+8, ')'))
  fromInput$clickElement()  
  Sys.sleep(2)
  
  toInput <- remDr$findElement(using='css selector', '#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div:nth-child(2) > div.chart-filter.active > div:nth-child(2) > div > div:nth-child(1) > input[type=text]')
  toInput$clickElement() 
  toInput <- remDr$findElement(using='css selector', paste0('#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div:nth-child(2) > div.chart-filter.active > div:nth-child(2) > div > div:nth-child(2) > div > span:nth-child(', to+8, ')'))
  toInput$clickElement()  
  Sys.sleep(2)
  
  # 저장버튼 누르기
  downButton <- remDr$findElement(using='css selector','#cccChartDivBTC > div > div.amcharts-export-menu.amcharts-export-menu-top-right.amExportButton > ul > li > a')
  downButton$clickElement()
  
  saveasButton <- remDr$findElement(using='css selector','#cccChartDivBTC > div > div.amcharts-export-menu.amcharts-export-menu-top-right.amExportButton > ul > li > ul > li:nth-child(2) > a')
  saveasButton$clickElement()
  
  csvButton <- remDr$findElement(using='css selector','#cccChartDivBTC > div > div.amcharts-export-menu.amcharts-export-menu-top-right.amExportButton > ul > li > ul > li:nth-child(2) > ul > li:nth-child(1) > a')
  csvButton$clickElement()
  
  from <- from-7
  to <- to-7
  if(from<=0){
    fromInput <- remDr$findElement(using='css selector','#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div:nth-child(2) > div.chart-filter.active > div:nth-child(1) > div > div:nth-child(1) > input[type=text]')
    fromInput$clickElement()
    prev <- remDr$findElement(using='css selector', '#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div:nth-child(2) > div.chart-filter.active > div:nth-child(1) > div > div:nth-child(2) > header > span.prev')
    prev$clickElement()
    
    month <- month-1
    if(month==0){
      month <- 12
    }
    from <- day[month]+from-1
  }
  if(to<=0){
    toInput <- remDr$findElement(using='css selector', '#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div:nth-child(2) > div.chart-filter.active > div:nth-child(2) > div > div:nth-child(1) > input[type=text]')
    toInput$clickElement() 
    prev <- remDr$findElement(using='css selector', '#price-index-page > div > div.col-xs-12.col-md-8.bb-price-index__price-col > div.bb-price-index__coinchart.coinchart > div > div.ccc-widget__wrapper > div > div:nth-child(2) > div.chart-filter.active > div:nth-child(2) > div > div:nth-child(2) > header > span.prev')
    prev$clickElement()
    to <- day[month]+to-1
  }
}
