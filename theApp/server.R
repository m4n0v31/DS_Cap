library(shiny)
library(stringr)
library(data.table)
require(stats)

source("model.R")

# Define server logic required to summarize and view the
# selected dataset
shinyServer(function(input, output) {
  nextword <- reactiveValues(word = "")
  
  # Generate a summary of the dataset
  output$sentence <- renderText({
    paste(input$prev_words, nextword$word)
  })
  
  # Show the first "n" observations
  output$prediction <- renderTable({
    res <- predictNextWord(input$prev_words)
    nextword$word <<- res[1]$word
    head(res,n = 3)
    
  })
  
})