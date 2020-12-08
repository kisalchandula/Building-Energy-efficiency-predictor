library(randomForest)
library(ggplot2)

# Read in the RF models
model1 <- readRDS("model1.rds")
model2 <- readRDS("model2.rds")

function(input, output, session) {
  
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