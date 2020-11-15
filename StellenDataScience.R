if (!("rvest" %in% installed.packages())) {
  install.packages("rvest")
}

if (!("dplyr" %in% installed.packages())) {
  install.packages("dplyr")
}

library("rvest")
library("dplyr")
library("tidyverse")


data <- map_df(paste0("https://de.indeed.com/jobs?q=data+science&start=", 0:19*10), seiteauslesen) 

seiteauslesen <- function(url){

cat(url) 
page <- xml2::read_html(url)

#get the job title
title <- page %>%
  rvest::html_nodes('[data-tn-element="jobTitle"]') %>%
  rvest::html_attr("title")

#get the job location
location <- page %>%
  rvest::html_nodes(".location") %>%
  rvest::html_text("location")
#rvest::html_attr("location")

# get company name
company <- page %>%
  rvest::html_nodes("span")  %>%
  rvest::html_nodes(xpath = '//*[@class="company"]')  %>%
  rvest::html_text() %>%
  stringi::stri_trim_both()

# get date
date <- page %>%
  rvest::html_nodes("span")  %>%
  rvest::html_nodes(xpath = '//*[@class="date "]')  %>%
  rvest::html_text() %>%
  stringi::stri_trim_both()
  
df <- data.frame(title, location, company, date) 
return(df)}

View(data)
#AbfrageOne <- read_csv("Abfrage1.csv")

#datadate2 <- AbfrageOne %>% mutate(day = Sys.Date() -  as.integer(gsub("[^0-9]", "", date))) %>% 
#  mutate(ort = gsub(" .*", "", location))
#View(datadate2)

datadate <- data %>% mutate(day = Sys.Date() -  as.integer(gsub("[^0-9]", "", date))) %>% 
  mutate(ort = gsub(" .*", "", location))
View(datadate)

PLZ_Stadt <- read_csv("PLZ Stadt.csv")
dx <- group_by(PLZ_Stadt, ort)
View(dx)

ortsingle <-dx[!duplicated(dx$ort),]
View(ortsingle)

datafull <- left_join(datadate,ortsingle, by = "ort") %>% select(title, company, day, ort, plz, bundesland)
View(datafull)

