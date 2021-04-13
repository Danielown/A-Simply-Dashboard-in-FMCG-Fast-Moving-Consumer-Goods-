library(plotly)
library(scales)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)
library(zoo)
library(tidyr)
library(ggplot2)
library(DT)
library(leaflet)
library(cluster)
library(factoextra)

banten <- read_csv("banten area.csv")
banten <- banten %>% 
  filter(`No Cust` !="2124556", `No Cust` !="2124556",`No Cust` !="2179036")
banten <- banten %>% 
  filter(`Rata rata`!="0")
banten <- banten[!duplicated(banten$`No Cust`),]

banten$Kecamatan <- as.factor(banten$Kecamatan)
banten$Kelurahan <- as.factor(banten$Kelurahan)


#Agregasi Data Line Kecamatan

line_kec <- banten %>% 
  group_by(Kecamatan) %>% 
  summarise(Oktober = median(Oktober),
            November = median(November),
            Desember = median(Desember),
            total_avg = sum(`Rata rata`)) %>% 
  arrange(desc(total_avg)) %>%
  head(10) 

long_kec <- pivot_longer(data = line_kec, cols = c("Oktober","November","Desember"),
                         names_to ="value_month",values_to = "value")


#Data Scatter
scatt <- banten %>% 
  group_by(Kecamatan) %>% 
  summarise(total = sum(`Rata rata`),
            skala.transaksi = sum(`Skala Transaksi`))

cluster <- banten %>% 
  group_by(Kecamatan) %>% 
  summarise( A = sum(`<= 100rb`),
             B = sum(`>100rb - <=300rb`),
             C = sum(`>300rb - <=1jt`),
             D = sum(`>1jt - <=5jt`),
             E = sum(`>5jt`),
             total.skala = sum(`Skala Transaksi`)) 


cluster_long <- pivot_longer(data = cluster, cols = c("A","B","C","D","E"),
                             names_to ="Cluster",values_to = "Value")
