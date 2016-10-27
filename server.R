options(stringsAsFactors = FALSE)

library(shiny)
library(xts)
library(quantmod)
Sys.setenv(TZ='UTC')
source('functions.R')
dat <- readRDS('data/EURUSD_M1_Ask.rds')
dat <- to.hourly(dat, indexAt='startof')

n_candles <- 20
max_tries <- 10
init_equity <- 10000
risk <- .01
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Reactive Values
  values <- reactiveValues(iter=0,
                           pips=0,
                           current_position='None',
                           equity=init_equity,
                           index=getRandomIndex(dat, n_candles),
                           points=list(x=NULL, y=NULL, pch=NULL, col=NULL)
                           )  
  
  # Candlestick chart
  #______________________________________________________________________
  observeEvent(input$Start, {
    values$iter <- 0
    values$pips <- 0
    values$current_position <- 'None'
    values$equity <- init_equity
    values$index <- getRandomIndex(dat, n_candles)
  })
  
  output$Chart <- renderPlot({
    plot(chart_Series(dat[values$index], name=''))
    points(x=values$points$x, y=values$points$y, pch=values$points$pch, 
           col='black', bg=values$points$col, cex=3)
    
  })
  # On Trade decisions
  #____________________________________________
  observeEvent(input$Buy, {
    
    values$iter <- values$iter + 1
    values$current_position <- 'Buy'
    values$index <- values$index + 1
    last <- Cl(last(dat[values$index], n=2))
    values$pips <- values$pips + (as.numeric(last[2]) - as.numeric(last[1]))*1e4
    values$points$x <- values$points$x - 1
    values$points$x <- c(values$points$x, n_candles + 1.25)
    values$points$y <- c(values$points$y, as.numeric(last[2]-.0005))
    values$points$pch <- c(values$points$pch, 24)
    values$points$col <- c(values$points$col, 'green')
  })
  
  observeEvent(input$Sell, {
    values$iter <- values$iter + 1
    values$current_position <- 'Sell'
    values$index <- values$index + 1
    last <- Cl(last(dat[values$index], n=2))
    values$pips <- values$pips - (as.numeric(last[2]) - as.numeric(last[1]))*1e4
    
  })
  
  observeEvent(input$Close, {
    values$current_position <- 'None'
  })
  
  observeEvent(input$Hold, {
    values$iter <- values$iter + 1
    values$index <- values$index + 1
    if(values$current_position == 'None'){
      
    } else if(values$current_position == 'Buy'){
      last <- Cl(last(dat[values$index], n=2))
      values$pips <- values$pips + (as.numeric(last[2]) - as.numeric(last[1]))*1e4
    } else if(values$current_position == 'Sell') {
      last <- Cl(last(dat[values$index], n=2))
      values$pips <- values$pips - (as.numeric(last[2]) - as.numeric(last[1]))*1e4
    }
  })
  
  
  
  # Print out some values
  #______________________________________
  
  # Equity
  output$Equity <- renderValueBox({
    if(values$equity == init_equity){
      color <- 'navy'
    } else if(values$equity > init_equity){
      color <- 'green'
    } else if(values$equity < init_equity){
      color <- 'red'
    }
    
    valueBox(
      paste0('$', format(values$equity, big.mark=",", scientific=FALSE, nsmall=2)), 
      subtitle="Your Account", icon = NULL,
      color = color
    )
  })
  
  # Pips
  output$Equity <- renderValueBox({
    if(values$pips == 0){
      color <- 'navy'
    } else if(values$pips > 0){
      color <- 'green'
    } else if(values$pips < 0){
      color <- 'red'
    }
    
    valueBox(
      format(values$pips, big.mark=",", scientific=FALSE, nsmall=1), 
      subtitle="Pips P/L", icon = NULL,
      color = color
    )
  })
})


# getRandomIndex(dat, n_candles + 0)
# dat2 <- dat[getRandomIndex(dat, n_candles + 0)]
# chart_Series(dat2)
# points(x=-1, y =1.463, col='red', bg='black', pch=24, cex=7)
