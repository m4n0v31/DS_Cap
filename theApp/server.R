library(shiny)
library(stringr)
library(data.table)

source("model.R")

# Define server logic required to summarize and view the 
# selected dataset
shinyServer(function(input, output) {
    
    # Generate a summary of the dataset
    output$sentence <- renderText({
      input$prev_words
    })
    
    # Show the first "n" observations
    output$prediction <- renderTable({
      res <- predictNextWord(input$prev_words) 
      head(res,n=3)
    })
})