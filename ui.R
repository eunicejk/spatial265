library(shiny)
library(leaflet)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("311 Calls in New York City"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    
    
    # List the categories of complaints
    sidebarPanel(checkboxGroupInput("checkGroup",
                  label = h4("Categories of Complaint", style = "font-family:'Lucida'"),
                  choices = list("A. Residential Space" = 1,
                                 "B. Public Space" = 2,
                                 "C. On the Street" = 3,
                                 "D. Information Requests" = 4,
                                 "E. All others" = 5),
                  selected = 1),
                 selectInput("LeafGraph", 
                             label = h4("Rendering Choice", style = "font-family:'Lucida'"), 
                             choices = list("Cluster" = 6, "Individual" = 7),
                             selected = 6),
                #dateRangeInput("dates", 
                #                start = "2013-01-01", end = "2013-12-31",
                #                label = h4("Date range", style = "font-family:'Lucida'")),
                plotOutput("comptab")
                 ),
  
    
    mainPanel(
      leafletOutput("map"))#,
      #actionButton('remove', 'Remove'))
  )
  #navbarPage
))