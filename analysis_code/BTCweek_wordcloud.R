library(rvest)
library(XML)
library(KoNLP)
library(wordcloud2)
useSejongDic()

price_strange <- read.csv("C:/Users/H/BTC_Analysis/analysis_code/price_strange_date.csv")[-1]
volume_strange <- read.csv("C:/Users/H/BTC_Analysis/analysis_code/volume_strange_date.csv")[-1]
BTCyear <- read.csv("C:/Users/H/BTC_Analysis/processing_code/BTCyear.csv")[-1]

# 가격 변동 이상치로 검측 3번된 날짜
# 2021-01-31 (2021-01-30~2021-02-01)
table(price_strange)
site <- "https://search.daum.net/search?w=news&DA=PGD&enc=utf8&cluster=y&cluster_page=1&q=%EB%B9%84%ED%8A%B8%EC%BD%94%EC%9D%B8&sd=20210130000000&ed=20210201235959&period=u&p="
text <- NULL
for(page in 1:10){
  url <- paste0(site, page)
  html <- read_html(url)
  title <- html_nodes(html, xpath='//*[@id="clusterResultUL"]/li/div[2]/div/div[1]/a/text()')
  text <- c(text, html_text(title, trim=TRUE))
}
text <- gsub("[[:punct:]]", " ", text) # 특수문자 ""로 대체
add_words <- c("블룸버그", "일런 머스크", "머스크", "일론 머스크", "증권사", "폭등", "폭락", "암호화폐", "추진", "수요", "현주소", "급등", "롤러코스터", "저가", "상승세",
               "테슬라", "공포", "기술", "가상화폐", "통용화폐", "채굴자", "급등", "중국", "스테이블", "애널리스트", "현주소", "마감",
               "비트코인", "업비트")
buildDictionary(user_dic=data.frame(add_words, rep("ncn", length(add_words))), replace_usr_dic=T)

words <- extractNoun(text)
words

# 단어의 길이가 2자 이상이고 6자 이하인 단어만 필터링
undata <- unlist(words)
undata <- Filter(function(x) {nchar(x)>=2 & nchar(x)<=5}, undata)

# 단어의 개수를 셈
word_table <- table(undata)
word_table

# 많은 순으로 정렬
final <- sort(word_table, decreasing = T)
# 데이터 프레임으로 만듬
df <- data.frame(final)
names(df) <- c("keyword", "freq")

windowsFonts(lett=windowsFont("휴먼옛체"))
result <- wordcloud2(data=df, fontFamily = "휴먼옛체")


# 거래량 이상치로 검측 4번된 날짜
# 2021-03-03
# 2021-03-02 ~ 2021-03-04
table(volume_strange)
site <- "https://search.daum.net/search?w=news&DA=STC&enc=utf8&cluster=y&cluster_page=1&q=%EB%B9%84%ED%8A%B8%EC%BD%94%EC%9D%B8&sd=20210302000000&ed=20210304235959&period=u&p=1"
text <- NULL
for(page in 1:10){
  url <- paste0(site, page)
  html <- read_html(url)
  title <- html_nodes(html, xpath='//*[@id="clusterResultUL"]/li/div[2]/div/div[1]/a/text()')
  text <- c(text, html_text(title, trim=TRUE))
}
text <- gsub("[[:punct:]]", " ", text) # 특수문자 ""로 대체

words <- extractNoun(text)
words

# 단어의 길이가 2자 이상이고 6자 이하인 단어만 필터링
undata <- unlist(words)
undata <- Filter(function(x) {nchar(x)>=2 & nchar(x)<=5}, undata)

# 단어의 개수를 셈
word_table <- table(undata)
word_table

# 많은 순으로 정렬
final <- sort(word_table, decreasing = T)

# 데이터 프레임으로 만듬
df <- data.frame(final)
names(df) <- c("keyword", "freq")

windowsFonts(lett=windowsFont("휴먼옛체"))
result <- wordcloud2(data=df, fontFamily = "휴먼옛체")





#########

# 네이버의 뉴스에서 "비트코인"라는 단어가 들어간 뉴스글들을 검색하여 100개까지 추출한 다음
# 뉴스 제목을 추출하여 navernews.txt 파일로 저장하시오. 단, JSON 형식의 요청을 처리
searchUrl<- "https://openapi.naver.com/v1/search/news.xml"
Client_ID <- #아이디
Client_Secret <- #키
query <- URLencode(iconv("비트코인","euc-kr","UTF-8"))
url <- paste0(searchUrl, "?query=", query, "&display=100")
doc <- GET(url, add_headers("Content_Type" = "application/xml",
                            "X-Naver-client-Id" = Client_ID, "X-naver-Client-Secret" = Client_Secret))

# 네이버 뉴스 내용에 대한 리스트 만들기		
doc2 <- htmlParse(doc, encoding="UTF-8")
text<- xpathSApply(doc2, "//item/description", xmlValue); 
text
text <- gsub("</?b>", "", text)
text <- gsub("&.+t;", "", text)
text

words <- extractNoun(text)
words

# 단어의 길이가 2자 이상이고 6자 이하인 단어만 필터링
undata <- unlist(words)
undata <- Filter(function(x) {nchar(x)>=2 & nchar(x)<=5}, undata)

# 단어의 개수를 셈
word_table <- table(undata)
word_table

# 많은 순으로 정렬
final <- sort(word_table, decreasing = T)

# 데이터 프레임으로 만듬
df <- data.frame(final)
names(df) <- c("keyword", "freq")

windowsFonts(lett=windowsFont("휴먼옛체"))
result <- wordcloud2(data=df, fontFamily = "휴먼옛체")



