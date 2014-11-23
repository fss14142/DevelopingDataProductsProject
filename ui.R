require(shiny)
require(rCharts)
require(httr)

source("global.R")


shinyUI(
  #bootstrapPage(
  fluidPage(
    
    title = "Bird distribution data from eBird.",  

    titlePanel("Migrating birds observations across the US, using data from Ebird."),
    
    sidebarLayout(
      
      sidebarPanel(
        
        #h5('See the App Documentation tab in the main panel.'),
        includeHTML("abouDocumentation.html"),
      
        h4('State selection:'),
        
        selectInput(inputId = 'stateSel', label = '',  
                    choices = sort(states$name), selected = 'Arkansas'),
        
        h4('Bird species selection:'),
        
        selectInput(inputId = 'speciesSel', label = '',  
                    choices = birdSpecies$comName, selected = birdSpecies$comName[1]),        
        
        h4('Bird species selection:'),
        
        p('Only the observations from the past 30 days are available from Ebird. Use the 
          slider to choose how many days you want.'),
        
        sliderInput(inputId = 'daysSel', label = 'Select a number of days',
                    min = 1, max =  30, value = 7, step = 1),
        h4(''),
        imageOutput('birdPic', height=200)
        
      
      ),
      
      mainPanel(
        tabsetPanel(
          tabPanel("State summary and Map", 
                   textOutput('stateSummary'), 
                   mapOutput('map_container')
                   ),
          tabPanel("App Documentation", includeMarkdown("documentation.Rmd"))
          #tabPanel("Table", tableOutput("table"))
        )
      )
      
      
      
      
      
#       mainPanel(
#        textOutput('stateSummary'),
#         mapOutput('map_container')
#       )
#      )
  )
)
)