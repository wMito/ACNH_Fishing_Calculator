library(shiny)
library(tidyverse)
library(shinythemes)
library(lubridate)
library(shinyTime)

df <- read.csv('fish.csv', encoding = 'UTF-8')

function(input, output, session){
  observeEvent(input$show_about, {
    showModal(modalDialog(
      "The data comes from dataset 'Animal Crossing New Horizons Catalog' available on kaggle.",
      title = 'About'
    ))
  })

  observeEvent(input$calculate, {
    new_df <- {abb_month <- substr(input$month, 1, 3)
      hemisp <- ifelse(input$hemisphere == 'Northern', 'NH', 'SH')
      df2 <- df %>%
        select(Name, Where.How, (ends_with(abb_month) & starts_with(hemisp)),
               Shadow, Size, Sell) %>%
        filter(!is.na(.[[3]])) %>%
        mutate(new_hours = ifelse(.[,3] == "All day", "12 AM – 11:59 PM", .[,3])) %>%
        separate(new_hours, c("Start", "End"), sep = "–") 
      
      df2$Start <- parse_date_time(df2$Start, orders = "Ip")
      df2$End <- parse_date_time(df2$End, orders = c("IMp", "Ip"))
      time <- ymd_hm(format(input$time, "0000-01-01 %H:%M"))
      df2 %>%
        filter(Start <= time, End > time) %>%
        select(-(Start), -(End)) %>%
        rename(Where = Where.How) %>%
        rename(When = ends_with(abb_month))
      }
    
    output$table <- renderDataTable(new_df)
    })
}