# 우리은행 골드뱅킹가격조회 표 가져오기

library(RSelenium)
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()
url <- "https://spot.wooribank.com/pot/Dream?withyou=POGLD0006"
remDr$navigate(url)

fromButton <- remDr$findElement(using = "css", "#START_DATE2Y")
fromButton$clickElement()
fromButton <- remDr$findElement(using = "css", "#START_DATE2Y > option:nth-child(121)")
fromButton$clickElement()
fromButton <- remDr$findElement(using = "css", "#START_DATE2D")
fromButton$clickElement()
fromButton <- remDr$findElement(using = "css", "#START_DATE2D > option:nth-child(18)")
fromButton$clickElement()

toButton <- remDr$findElement(using = "css", "#END_DATE2D")
toButton$clickElement()
toButton <- remDr$findElement(using = "css", "#END_DATE2D > option:nth-child(18)")
toButton$clickElement()

searchButton <- remDr$findElement(using = "css", "#frm > div > span > input[type=submit]")
searchButton$clickElement()

Sys.sleep(3)


library(XML)
elem <- remDr$findElement(using="css", value="#resultArea > table")
elemtxt <- elem$getElementAttribute("outerHTML")
elem_html <- htmlTreeParse(elemtxt, asText = TRUE, useInternalNodes = T, encoding="UTF-8")
Sys.setlocale("LC_ALL", "English") # 영어로 먼저 읽고
gold_table <- readHTMLTable(elem_html, header = T, stringsAsFactors = FALSE)[[1]]
Sys.setlocale() # 다시 언어를 원상 복구
Encoding(names(gold_table)) <- "UTF-8"
View(gold_table)
Sys.getlocale()
write.csv(gold_table, file="C:/Users/H/BTC_Analysis/data/Gold1year.csv")
