options(stringsAsFactors = FALSE)

library(shiny)
library(xts)
library(quantmod)
Sys.setenv(TZ='UTC')
source('functions.R')
dat <- readRDS('data/EURUSD_M1_Ask.rds')
dat <- to.hourly(dat, indexAt='startof')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   output$Chart <- renderPlot({
     input$Start
     chart_Series(getRandomTimepoint(dat, 20), name='')
   })
  
})
