library(shiny)
library(shinydashboard)
shinyUI(dashboardPage(title="Forex Game", skin='yellow',
    dashboardHeader(disable=TRUE, title="Forex Game", titleWidth=400),
    
    dashboardSidebar(disable=TRUE),
   
    dashboardBody(
      fluidRow(
        # This columns UI is handled in server.R
        column(width=8,
               uiOutput('endScreen')
        ),
        column(width=4,
               valueBoxOutput(width=12, 'Pips'),
               valueBoxOutput(width=12, 'Position'),
               valueBoxOutput(width=12, 'Time'),
               plotOutput('DailyChart', height='200px')
        )
      )
    )
))

