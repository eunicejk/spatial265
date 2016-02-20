library(shiny)
library(leaflet)
library(sp)
library(lubridate)


## Read in and prepare data
a <- read.csv("data/nyc_subset.csv")
data <- a[complete.cases(a),]

tt <- strptime(as.character(data$Created.Date), "%m/%d/%y %H:%M", tz = "EST")

Info <- paste(data[['Complaint.Type']], ",  ", 
              data[['Descriptor']], "<br>",
              tt, "<br>",   
              data[['Agency.Name']])
data$info <- Info
#data$complain <- factor(data$complain, 
#                           labels = c("Residential", "Public", "Streets", "Info", "Etc." ))

## Define colors for five types of complaint
pal <- colorFactor(c("deepskyblue1","darkslategray2", "indianred4", "darkgreen", "purple"),
                   domain = c(1:5))
#domain = c("Resident", "Public", "Streets", "Info", "Etc."))





## Convert data frame to SP data frame.
df <- SpatialPointsDataFrame(
  coords = data[, c("Longitude", "Latitude")],
  data.frame(type = data[,"complain"], info = data[,"info"]))


## Define colors for five types of complaint
pal <- colorFactor(c("deepskyblue1","darkslategray2", "indianred4", "darkgreen", "purple"),
                   domain = c(1:5))
#domain = c("Resident", "Public", "Streets", "Info", "Etc."))





# Define server logic required to draw a histogram
library(shiny)
library(leaflet)
library(sp)
library(lubridate)


## Read in and prepare data
a <- read.csv("data/nyc_subset.csv")
data <- a[complete.cases(a),]

tt <- strptime(as.character(data$Created.Date), "%m/%d/%y %H:%M", tz = "EST")

Info <- paste(data[['Complaint.Type']], ",  ", 
              data[['Descriptor']], "<br>",
              tt, "<br>",   
              data[['Agency.Name']])
data$info <- Info
#data$complain <- factor(data$complain, 
#                           labels = c("Residential", "Public", "Streets", "Info", "Etc." ))



## Convert data frame to SP data frame.
df <- SpatialPointsDataFrame(
  coords = data[, c("Longitude", "Latitude")],
  data.frame(type = data[,"complain"], info = data[,"info"]))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Expression that generates a histogram. The expression is
  # wrapped in a call to render* to indicate that:
  #
  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot
  
  
  output$comptab<- renderPlot({
    par(mar = c(0,4,4,5))
    pie(table(a$complain), label = c("Residential", "Commercial", "Street", "Info Requests", "Ect."),
        main = "Complaint Breakdowns", cex = 1.4, cex.main = 1.2, init.angle =  333)
  })
  
  output$map <- renderLeaflet({
    leaflet() %>% 
      setView(lng= - 73.94, lat= 40.7, zoom = 10) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addProviderTiles("Stamen.TonerLabels")
  })
  
  
  
  observe({
    
    
    
    if(input$LeafGraph==7){
      leafletProxy("map", data = df[df$type==input$checkGroup,]) %>%
        clearShapes() %>%
        addProviderTiles("CartoDB.Positron") %>%
        addCircleMarkers(color = ~pal(type), fillOpacity = 0.6,
                         popup = ~info, stroke = FALSE, radius = 3,
                         options = popupOptions(closeButton = TRUE))
                         
      #addLegend("bottomleft", pal=pal, title="Complaint Type",
      #     layerId="colorLegend")
      
    }
    else{
      
      leafletProxy("map", data = df[df$type==input$checkGroup,]) %>%
        clearShapes() %>%
        addProviderTiles("CartoDB.Positron") %>%
        addMarkers(popup = ~info,
                   options = popupOptions(closeButton = TRUE),
                   clusterOptions = markerClusterOptions())
      
    } 
    observeEvent(input$remove, {
         leafletProxy("map") %>% clearMarkerClusters("map")
    })
    
  })
  
})