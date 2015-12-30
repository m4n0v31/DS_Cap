library(shiny)
library(stringr)
library(data.table)

for(i in 1:4){
    load(paste("dfm_r", i, ".RData",sep=""))
}

# Define server logic required to summarize and view the 
# selected dataset
shinyServer(function(input, output) {
    
    # Return the requested dataset
    prev_words <- reactive({
        str_split_fixed(str_to_lower(input$prev_words), " ", n=-1)
    })
    
    len <- reactive({
        length(prev_words())
    })
    
    # Generate a summary of the dataset
    output$sentence <- renderText({
        paste(prev_words(), sep = " ")
    })
    
    # Show the first "n" observations
    output$prediction <- renderTable({
        dfm_r4[V1==prev_words()[len()-2] & V2==prev_words()[len()-1], .(count = sum(count)), by=(NextWord=V4)][order(-count)]
    })
})