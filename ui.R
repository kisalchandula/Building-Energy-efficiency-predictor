library(shiny)
library(shinythemes)

navbarPage(
  
  
  title = "Building Energy Efficiency Predictor",
  theme = shinytheme("flatly"),
  
  tabPanel("Prediction",
           sidebarPanel(
             tags$label(h3('Building Parameters')),
             numericInput("RC", 
                          label = "Reflective Compactness:", 
                          value = 0.9),
             sliderInput("SA",
                         label = "Surface Area:",
                         min = 514.5,
                         max = 808.5,
                         value = 520),
             numericInput("WA", 
                          label = "Wall Area:", 
                          value = 294),
             numericInput("RA", 
                          label = "Roof Area:", 
                          value = 122),
             selectInput("OH",
                         label = "Overall Height:",
                         choices = c(3.5,7)),
             selectInput("OR",
                         label = "Orientation:",
                         choices = c(2,3,4,5)),
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
             tags$h3('For Building design it will become a key factor for deciding most ideal building parameters for determing the Heating load and Cooling load. This simple apllication will be benfitted for engineers and architects to 
                      planning their building projects efficiently', align ='center')
           ))
  
)