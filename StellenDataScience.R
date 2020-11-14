if (!("rvest" %in% installed.packages())) {
  install.packages("rvest")
}

if (!("dplyr" %in% installed.packages())) {
  install.packages("dplyr")
}

install.packages("shiny")

library("shiny")
library("rvest")
library("dplyr")
library("tidyverse")

url = "https://de.indeed.com/jobs?q=Data+Scientist&l="

download.file(url, destfile = "stellenpage.html", quiet=TRUE)
stellen <- read_html("stellenpage.html")

stellen
str(stellen)

data <- stellen %>%
  rvest::html_nodes(xpath = "/html/body/table[2]/tbody/tr/td/table/tbody/tr/td[1]/div[5]/h2")%>%
  xml2::xml_children()

data_titles <- data %>% purrr::map(rvest::html_attrs)



  
