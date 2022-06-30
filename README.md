---
title: "App Shiny"
author: "Freddy Espinoza"
date: '2022-06-30'
output: 
  slidy_presentation:
    font_adjustment: -1
#ioslides_presentation
runtime: shiny
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```

## Slide with R Output

```{r echo = TRUE}
dataset <- read.csv("/Users/freddyespinoza/Downloads/_r/csvfolder/heart_failure_clinical_records_dataset.csv", 
                    header = TRUE, sep = ",", dec = ".")
summary(dataset)
```

## Slide with Plotly

```{r message = FALSE}

library(plotly)

fig <- plot_ly(dataset, x= dataset$age, y=dataset$time, name ='heart_failure', 
        type = 'scatter', 
        mode = 'markers')

fig <- fig %>% layout(
  title ='Heart Failure Clinical', 
  xaxis = list(title = 'Age'), 
  yaxis = list(title = 'Follow-up days'))

fig

```

## Code ui.R

```{r echo=TRUE, eval=FALSE}
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
```

## Code server.R

```{r echo=TRUE, eval=FALSE}
#
# Application with allows to predict at what age it is more likely to suffer from 
# a heart condition.
# 
# The data source has been extracted from this URL:
# https://www.kaggle.com/code/tawejssh/heart-failure-prediction/notebook
#


library(shiny)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Reading the data from the external source
  dataset <- read.csv("/Users/freddyespinoza/Downloads/_r/csvfolder/heart_failure_clinical_records_dataset.csv", 
                      header = TRUE, sep = ",", dec = ".")
  
  # data regression
  model1 <- lm(time ~ age, data = dataset)
  model2 <- lm(time ~ age + DEATH_EVENT, data = dataset)
  
  # Reactive function to predict heart attacks based on age.
  model1pred <- reactive({
    mpginput <- input$age_range
    predict(model1, newdata = data.frame(age = mpginput))
  })
  
  # Reactive function to predict heart attacks based on age and if 
  # you have previously had a heart attack.
  model2pred <- reactive({
    mpginput <- input$age_range
    deathinput <- ifelse(input$ifhf, 1, 0)
    predict(model2, newdata = data.frame(age = mpginput, DEATH_EVENT = deathinput))
  })

  # Generation of the graph associated with the data.
  output$distPlot <- renderPlotly({
    
      mpginput <- input$age_range
      
      fig <- plot_ly(df, x= df$age, y=df$time, name ='heart_failure', 
              type = 'scatter', 
              mode = 'markers')
      
      fig <- fig %>% layout(
        title ='Heart Failure Clinical', 
        xaxis = list(title = 'Age'), 
        yaxis = list(title = 'Follow-up days'))
      
      fig
  
  })
  
  # Invocation of the reactive function to show the value of the 
  # prediction only as a function of age.
  output$pred1 <- renderText({
    model1pred()
  })
  
  # Invocation of the reactive function to show the value of the
  #prediction only based on age and if you have previously suffered a heart attack.
  output$pred2 <- renderText({
    model2pred()
  })
})
```
