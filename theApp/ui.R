library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
    
    # Application title.
    titlePanel("Predict Next Word"),
    
    # Sidebar with controls to input the sentence. The helpText function is
    # also used to include clarifying text. Most notably, the
    # inclusion of a submitButton defers the rendering of output
    # until the user explicitly clicks the button (rather than
    # doing it immediately when inputs change). This is useful if
    # the computations required to render output are inordinately
    # time-consuming.
    sidebarLayout(
        sidebarPanel(
            textInput("prev_words", "Sentence for which the next word has to be predicted:", ""),
            
            helpText("Note: it is assumed the user inputs clean data, only limited cleaning is performed on the user's inputs."),
            
            submitButton("Predict")
        ),
        
        # Show the sentece provided and the next most likely words.
        mainPanel(
            h4("Input sentence:"),
            verbatimTextOutput("sentence"),
            
            h4("Most likely next words (Profanities are displayed as $@#!):"),
            tableOutput("prediction")

        )
    )
))