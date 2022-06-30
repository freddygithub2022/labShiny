#
# Application with allows to predict at what age it is more likely to suffer from 
# a heart condition.
# 
# The data source has been extracted from this URL:
# https://www.kaggle.com/code/tawejssh/heart-failure-prediction/notebook
#
# User interface that allows moving age to dynamically predict the probability of having 
# a heart attack.
# 
# The check indicates whether the person or patient has already suffered from heart failure.

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("My predictive model"),

    # Sidebar with a slider input for age range
    sidebarLayout(
        sidebarPanel(
            sliderInput("age_range",
                        "Age range:",
                        min = 40,
                        max = 95,
                        value = 55),
            checkboxInput("ifhf", "Heart Failure", value = FALSE)       
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotlyOutput("distPlot"),
            h3("Predicted Value from  Model 1: "),
            textOutput("pred1"),
            h3("Predicted Value from  Model 2: "),
            textOutput("pred2")
        )
    )
))
