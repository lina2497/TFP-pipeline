if (!require("pacman")) install.packages("pacman")
pacman::p_load(httr,readxl,tidyr,dplyr)

######Functions############


read_excel_allsheets <- function(filename) {
  
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}

tidy_capital_stocks<- function(raw_data){
  metric<-colnames(raw_data)[ncol(raw_data)]
  df<-raw_data[(!is.na(raw_data[,1])),]
  colnames(df)[5:27]<-df[1,5:27]
  df<-drop_na(df[-1,])%>%
    gather(key = Year, value = Temp,-c(1:4))
  df$unit<-metric
  df$source<-colnames(df)[1]
  colnames(df)[1]<-"X__0"
  return(df)
}



######URLs of raw data#######

Capital.Stocks.url<-"https://www.ons.gov.uk/file?uri=/economy/nationalaccounts/uksectoraccounts/datasets/capitalstocksconsumptionoffixedcapital/current/capitalstockstables2018.xls"



######Download raw data######
download.file(Capital.Stocks.url,"Capital.Stocks.xls",mode="wb")



######Tidy raw data########
Capital.Stocks.all<-read_excel_allsheets("Capital.Stocks.xls")


Capital.Stocks.list<-lapply(list(Capital.Stocks.all$`1.2.1`,
                                 Capital.Stocks.all$`3.2.1`,
                                 Capital.Stocks.all$`3.2.2`),
                            tidy_capital_stocks)

Capital.Stocks.tidy<-do.call(rbind,Capital.Stocks.list)
