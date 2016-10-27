library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(title="Forex Game", skin='yellow',
    dashboardHeader(disable=TRUE, title="Forex Game", titleWidth=400),
    dashboardSidebar(disable=TRUE),
   
    dashboardBody(
      fixedRow(
        column(width=8,
               box(title='How much money can you make?', background='aqua', width=NULL,
                   actionButton('Start', label='Start New Game'),
                   hr(),
                   div(style='color:black',
                    plotOutput("Chart")
                   ),
                   hr(),
                   div(align='center', 
                     
                     actionButton('Sell', label='Sell'),
                     actionButton('Hold', label='Hold'),
                     actionButton('Buy', label='Buy'),
                     '|',
                     actionButton('Close', label='Close All Trades')
                   )
                )
        ),
        column(width=4,
               valueBoxOutput(width=12, 'Equity')
        )
      )
    )
))





# # Define UI for application that draws a histogram
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("Can you beat the high score?"),
#   
#   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
#     sidebarPanel(
#       actionButton('Start', label='Begin Game'),
#       plotOutput("Chart"),
#       hr(),
#       actionButton('Buy', label='Buy'),
#       actionButton('Hold', label='Hold'),
#       actionButton('Sell', label='Sell')
#     ),
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#        plotOutput("distPlot")
#     )
#   )
# ))
