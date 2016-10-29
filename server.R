options(stringsAsFactors = FALSE)

library(shiny)
library(xts)
library(quantmod)
Sys.setenv(TZ='UTC')
source('functions.R')
dat <- readRDS('data/EURUSD_H1_Ask.rds')


n_candles <- 20
max_tries <- 10
risk <- .01
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # Reactive Values
  #______________________________________________________________________
  values <- reactiveValues(iter=0,
                           pips=0,
                           current_position='None',
                           index=1:n_candles,
                           points=data.frame(x=numeric(0), 
                                             y=numeric(0), 
                                             pch=integer(0), 
                                             col=character(0)),
                           this.week=getRandomWeek(dat),
                           allDone='How much can you make in one week?',
                           quantile=NULL
                           )  
  
  # Candlestick chart
  #______________________________________________________________________
  output$Chart <- renderPlot({
    if(values$allDone != 'GAME OVER'){
      plot(chart_Series(values$this.week[values$index], name='EUR/USD Hourly'))
      points(x=values$points$x, y=values$points$y, pch=values$points$pch, 
             col='black', bg=values$points$col, cex=1)
    } else {
      rand <- randomTrading(values$this.week, n_candles)
      values$quantile <- length(rand[rand <= values$pips])/length(rand)*100
      hist(rand, breaks=50,
           main='How you compared to random decisions (1000 permutations):')
      abline(v=values$pips)
    }
  })
  
  # On New Game Start
  #______________________________________________________________________
  observeEvent(input$Start, {
    # Reset all values
    values$iter <- 0
    values$pips <- 0
    values$current_position <- 'None'
    values$index <- 1:n_candles
    values$this.week <- getRandomWeek(dat)
    values$points <- data.frame(x=numeric(0), 
                                y=numeric(0), 
                                pch=integer(0), 
                                col=character(0))
    values$allDone <- 'How much can you make in one week?'
  })
  
  
  # On Trade decisions
  #_______________________________________________________________________
  observeEvent(input$Buy, {
    
    # Iterate and change position
    values$current_position <- 'Buy'
    values$index <- values$index + 1
    
    if(values$index[n_candles] >= nrow(values$this.week)){
      values$allDone <- 'GAME OVER'
    } else {
      # Calulate Pips
      last <- Cl(last(values$this.week[values$index], n=2))
      values$pips <- values$pips + (as.numeric(last[2]) - as.numeric(last[1]))*1e4
      
      # Move the current points back one, then add a new point
      values$points$x <- values$points$x - 1
      values$points <- rbind(values$points, 
                             data.frame(x=n_candles + .2, 
                                        y=as.numeric(last[1]), 
                                        pch=24, col='green'))
    }
  })
  
  observeEvent(input$Sell, {
    #Iterate and change position
    values$current_position <- 'Sell'
    values$index <- values$index + 1
    
    if(values$index[n_candles] >= nrow(values$this.week)){
      values$allDone <- 'GAME OVER'
    } else {
      values$points$x <- values$points$x - 1
      
      # Calculate pips
      last <- Cl(last(values$this.week[values$index], n=2))
      values$pips <- values$pips - (as.numeric(last[2]) - as.numeric(last[1]))*1e4
      
      # Add a sell marker that moves with plot
      values$points <- rbind(values$points, 
                             data.frame(x=n_candles + .2, 
                                        y=as.numeric(last[1]), 
                                        pch=25, col='red'))
    }
  })
  
  observeEvent(input$Close, {
    values$current_position <- 'None'
  })
  
  observeEvent(input$Hold, {
    # Iterate
    values$index <- values$index + 1
    
    if(values$index[n_candles] >= nrow(values$this.week)){
      values$allDone <- 'GAME OVER'
    } else {
      values$points$x <- values$points$x - 1
      if(values$current_position == 'None'){
        
      } else if(values$current_position == 'Buy'){
        last <- Cl(last(values$this.week[values$index], n=2))
        values$pips <- values$pips + (as.numeric(last[2]) - as.numeric(last[1]))*1e4
      } else if(values$current_position == 'Sell') {
        last <- Cl(last(values$this.week[values$index], n=2))
        values$pips <- values$pips - (as.numeric(last[2]) - as.numeric(last[1]))*1e4
      }
    }
  })
  
  
  
  # Value Boxes
  #______________________________________
  
  # Current position
  output$Position <- renderValueBox({
    if(values$current_position=='Buy'){
      icon <- icon("circle-arrow-up", lib = "glyphicon")
    } else if(values$current_position=='Sell'){
      icon <- icon('circle-arrow-down', lib='glyphicon')
    } else {
      icon <- icon('option-horizontal', lib='glyphicon')
    }
    valueBox(values$current_position, subtitle='Current Position', icon=icon,
             color = 'aqua')
  })

  
  # Pips
  output$Pips <- renderValueBox({
    if(values$pips == 0){
      color <- 'navy'
      icon <- icon("meditation", lib = "glyphicon")
    } else if(values$pips > 0){
      color <- 'green'
      icon <- icon("thumbs-up", lib = "glyphicon")
    } else if(values$pips < 0){
      color <- 'red'
      icon <- icon("thumbs-down", lib = "glyphicon")
    }
    
    valueBox(
      format(values$pips, big.mark=",", scientific=FALSE, nsmall=1), 
      subtitle="Pips P/L", icon = icon,
      color = color
    )
  })
  
  # UI
  #___________________________________________________________________
  output$endScreen <- renderUI({
    if(values$allDone != 'GAME OVER') {
      box(title=values$allDone,
          background='aqua', width=NULL,
          
          actionButton('Start', label='Start New Game'),
          hr(),
          plotOutput('Chart'),
          hr(),
          
          div(align='center', 
              actionButton('Sell', label='Sell'),
              actionButton('Hold', label='Hold'),
              actionButton('Buy', label='Buy'),
              '|',
              actionButton('Close', label='Close All Trades')
          )
      )
    } else {
      box(title=values$allDone, 
          background='aqua', width=NULL,
          h1(paste('Score:', values$quantile)),
          h5('(percentile compared to random trading choices)'),
          actionButton('Start', label='Start New Game'),
          hr(),
          plotOutput('Chart'),
          hr()
      )
    }
  })
  
  
})



