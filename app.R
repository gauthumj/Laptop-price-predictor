library(shiny)
library(DT)
library(dygraphs)
library(xts)
library(leaflet)

data <- read.csv("Data/laptops.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Laptop Price Predictor"),
  
  fluidRow(
    column(3,
           selectInput("CPU", h3("CPU Options"), 
                       choices = list("Choice 1" = 1, "Choice 2" = 2,
                                      "Choice 3" = 3), selected = 1)),
    
    column(3, 
           selectInput("GPU", h3("GPU Options"), 
                       choices = list("Choice 1" = 1, "Choice 2" = 2,
                                      "Choice 3" = 3), selected = 1)),  
    column(3, 
           selectInput("ScreenSize", h3("ScreenSize"), 
                       choices = list("Choice 1" = 1, "Choice 2" = 2,
                                      "Choice 3" = 3), selected = 1)), 
    column(3, 
           selectInput("Resolution", h3("Screen Resolution"), 
                       choices = list("Choice 1" = 1, "Choice 2" = 2,
                                      "Choice 3" = 3), selected = 1)),
    column(3, 
           selectInput("RAM", h3("RAM"), 
                       choices = list("Choice 1" = 1, "Choice 2" = 2,
                                      "Choice 3" = 3), selected = 1)),
    column(3, 
           selectInput("Memory", h3("Memory"), 
                       choices = list("Choice 1" = 1, "Choice 2" = 2,
                                      "Choice 3" = 3), selected = 1)),
  ),
  mainPanel(
    fluidRow(
      column(4,textOutput("selected_cpu")),
      column(4,textOutput("selected_gpu")),
      DTOutput(outputId = "table")
    )
    
  )
  
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$selected_cpu <- renderText({ 
    paste("You have selected", input$CPU)
  })
  
  output$selected_gpu <- renderText({ 
    paste("You have selected", input$GPU)
  })
  
  output$table <- renderDT(data)
  
}

# Run the app ----
shinyApp(ui = ui, server = server)
