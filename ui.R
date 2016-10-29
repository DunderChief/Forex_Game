library(shiny)
library(shinydashboard)
shinyUI(dashboardPage(title="Forex Game", skin='yellow',
    dashboardHeader(disable=TRUE, title="Forex Game", titleWidth=400),
    dashboardSidebar(disable=TRUE),
   
    dashboardBody(
      fluidRow(
        
          column(width=8,
            uiOutput('endScreen')
              #    box(title=textOutput('allDone'), 
              #        background='aqua', width=NULL,
              #        conditionalPanel("output.allDone == 'How much can you make in one week?'",
              #          actionButton('Start', label='Start New Game'),
              #          hr(),
              #          plotOutput('Chart'),
              #          hr(),
              #          div(align='center', 
              #            actionButton('Sell', label='Sell'),
              #            actionButton('Hold', label='Hold'),
              #            actionButton('Buy', label='Buy'),
              #            '|',
              #            actionButton('Close', label='Close All Trades')
              #          )
              #       )
              # )
            # conditionalPanel("output.allDone == 'GAME OVER'",
            # 
            #    box(title='GAME OVER',
            #        background='aqua', width=NULL,
            #        actionButton('Start', label='Start New Game'),
            #        hr(),
            #        plotOutput('Chart'),
            #        hr()
            #    )
            # 
            # )
          # ),
        
          ),
        column(width=4,
               valueBoxOutput(width=12, 'Pips'),
               valueBoxOutput(width=12, 'Position')
        )
      )
    )
))

