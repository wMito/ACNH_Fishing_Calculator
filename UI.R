library(shiny)
library(tidyverse)
library(shinythemes)
library(lubridate)
library(shinyTime)

df <- read.csv('fish.csv', encoding = 'UTF-8')

fluidPage(
  theme = shinythemes::shinytheme("darkly"),
  fixedPanel(right = '2%', top = '1%',
            actionButton('show_about', "About")),
  titlePanel("The Fishing Calculator - ACNH version"),
  
  sidebarLayout(
    sidebarPanel(
    selectInput("month", "Choose month: ",
                    choices = c('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')
                    ),
    radioButtons('hemisphere', 'Choose hemisphere: ',
                 choices = c('Northern', 'Southern'), inline = TRUE),
    timeInput('time', 'Time: ', value = Sys.time(), seconds = FALSE, minute.steps = 5),
    actionButton('calculate', 'Calculate!')),
  mainPanel( 
    dataTableOutput('table'),
    )
  )
  
)
