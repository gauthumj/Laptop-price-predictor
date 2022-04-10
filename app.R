library(shiny)
library(DT)
library(dygraphs)
library(xts)
library(leaflet)


data <- read.csv("Data/laptops.csv")
ui <- navbarPage("My Application",
                 tabPanel("Component 1"),
                 tabPanel("Component 2"),
                 tabPanel("Component 3")
)

ui <- fluidPage(
  titlePanel("Laptop Price Predictor"),
  
  fluidRow(
    column(3,
           selectInput("CPU", h3("CPU"), 
                       choices = unique(data$Cpu), selected = 1)),
    
    column(3, 
           selectInput("GPU", h3("GPU"), 
                       choices = unique(data$Gpu), selected = 1)),  
    column(3,
           selectInput("Type", h3("Type"), 
                       choices = unique(data$TypeName), selected = 1)),
    column(3,
           selectInput("Inches", h3("Size"), 
                       choices = unique(data$Inches), selected = 1)),
    column(3,
           selectInput("Screen", h3("Resolution"), 
                       choices = unique(data$ScreenResolution), selected = 1)),
    column(3,
           selectInput("RAM", h3("RAM"), 
                       choices = unique(data$Ram), selected = 1)),
    column(3,
           selectInput("Storage", h3("Storage"), 
                       choices = unique(data$Memory), selected = 1)),
    column(3,
           actionButton("predict", "Submit"))
    
  ),
  column(4,textOutput("selected_cpu")),
  column(4,textOutput("selected_gpu")),
  hr(),
  textOutput("modelOut"),
  
  mainPanel(
    fluidRow(
      DTOutput(outputId = "table")
    )
    
  )
  
)


server <- function(input, output, session) {
  
  observeEvent(input$predict, {
    
    inp <- c(input$Type, input$Inches, input$Screen, input$CPU, input$RAM, input$Storage, input$GPU)
    df = as.data.frame(data)
    df = df[,c(4,5,6,7,8,9,10,13)]
    df = df[complete.cases(df),]
    inpdf <- data.frame(matrix(ncol=7,nrow=0))
    colnames(inpdf) <- colnames(df[1:7])
    inpdf[nrow(inpdf) + 1,] = inp
    inpdf$Inches = as.numeric(inpdf$Inches)
    
    mdl <- lm(Price_euros ~ TypeName + Inches + ScreenResolution 
              + Cpu + Ram + Memory + Gpu, data = df)
    output$modelOut <- renderText({paste("Predicted Price: ", predict(mdl, inpdf))})
  })
  
  output$table <- renderDT(data)
  
}


shinyApp(ui = ui, server = server)
