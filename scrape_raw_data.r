if (!require("pacman")) install.packages("pacman")
pacman::p_load(httr,readxl)

Capital.Stocks.url<-"https://www.ons.gov.uk/file?uri=/economy/nationalaccounts/uksectoraccounts/datasets/capitalstocksconsumptionoffixedcapital/current/capitalstockstables2018.xls"


download.file(CS.url,"Capital.Stocks.xls",mode="wb")


read_excel_allsheets <- function(filename) {
  
  sheets <- readxl::excel_sheets(filename)
  x <- lapply(sheets, function(X) readxl::read_excel(filename, sheet = X))
  x <- lapply(x, as.data.frame)
  names(x) <- sheets
  x
}

Capital.Stocks<-read_excel_allsheets("CS.xls")


