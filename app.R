  # Import libraries
library(shiny)
library(randomForest)
library(ggplot2)
library(shinythemes)
  # Read in the RF models
model1 <- readRDS("model1.rds")
model2 <- readRDS("model2.rds")

####################################
# User Interface                   #
####################################
ui <- navbarPage(

  
  title = "Building Energy Efficiency Predictor",
  theme = shinytheme("flatly"),

  tabPanel("Prediction",
           sidebarPanel(
             tags$label(h3('Building Parameters')),
             numericInput("RC", 
                          label = "Reflective Compactness:", 
                          value = 0.9),
             numericInput("SA", 
                          label = "Surface Area:", 
                          value = 3.6),
             numericInput("WA", 
                          label = "Wall Area:", 
                          value = 294),
             numericInput("RA", 
                          label = "Roof Area:", 
                          value = 122),
             numericInput("OH", 
                          label = "Overall Height:", 
                          value = 7),
             selectInput("OR",
                         label = "Orientation:",
                         choices = c(2,3,4,5,6)),
             selectInput("GA",
                         label = "Glazing Area:",
                         choices = c(0,0.4)),
             numericInput("GAD", 
                          label = "Glazing Area Distribution:", 
                          value = 0.2),
             actionButton('submitbutton', 'Predict', icon = icon('table'))
             
           ),
           
           mainPanel(
             tags$label(h2('Heating & Cooling Load Estimation')), # Heading
             verbatimTextOutput('contents'),    # Status
             tableOutput('tabledata')           # Table
           )
           
  ),
  tabPanel("About",
           mainPanel(
             tags$h1('About application', align ='center'),
             tags$p('For Building design it will become a key factor for deciding most ideal building parameters for determing the Heating load and Cooling load. This simple apllication will be benfitted for engineers and architects to 
                      planning their building projects efficiently', align ='center')
           ))
  
)
####################################
# Server logic                     #
####################################

server<- function(input, output, session) {
  
  datasetInput <- reactive({
  
  df <- data.frame(
    Name = c("relative_compactness", "surface_area", "wall_area", 
             "roof_area", "overall_height", "orientation", "glazing_area",
             "glazing_area_distribution"),
    Value = as.numeric(c(input$RC,
                           input$SA,
                           input$WA,
                           input$RA,
                           input$OH,
                           input$OR,
                           input$GA,
                           input$GAD)),
    stringsAsFactors = FALSE)
    
  df <- as.data.frame(t(df))
  df <- df[-c(1),]
  colnames(df) <- c("relative_compactness", "surface_area", "wall_area", 
                    "roof_area", "overall_height", "orientation", "glazing_area",
                    "glazing_area_distribution")
  write.table(df,"input.csv", sep=",", quote = FALSE, row.names = F, col.names = T)
  
  test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
  output <- data.frame(Heating = predict(model1,test),
                       Cooling = predict(model2,test),
                       RMSE_HL = sqrt(model1$mse[length(model1$mse)]),
                       RMSE_CL = sqrt(model2$mse[length(model2$mse)]),
                       Details = "Random forest model")
  
  
  print(output)
})
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Prediction done.") 
    } else {
      return("Server is ready for prediction.")
    }
  })
  
  # Prediction Table 
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput())
    }
  })

  
}

####################################
# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server)
