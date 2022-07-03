---
title: "App Shiny"
author: "Freddy Espinoza"
date: '2022-07-03'
output: 
  slidy_presentation:
    font_adjustment: -1
#ioslides_presentation
#runtime: shiny
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```

## Slide with R Output

```{r echo = TRUE}
dataset <- read.csv("heart_failure_clinical_records_dataset.csv", header = TRUE, sep = ",", dec = ".")
summary(dataset)
```

## Slide with Plotly

```{r message = FALSE}

  x    <- dataset$age
  bins <- seq(min(x), max(x), length.out = 55 + 1)
  hist(x, breaks = bins, col = "#75AADB", border = "white",
       xlab = "Age of the patients in the sample",
       ylab = "Follow-up days",
       main = "Histogram of Heart Failure Clinical")

```

## Code ui.R

```{r echo=TRUE, eval=FALSE}
library(shiny)
shinyUI(fluidPage(
titlePanel("My predictive model"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("age_range",
                        "Age range:",
                        min = 40,
                        max = 95,
                        value = 55),
            checkboxInput("ifhf", "Heart Failure", value = FALSE),
            checkboxInput("all", "Summary & Table Dynamic?", value = FALSE)
        ),
        mainPanel(
          
          tabsetPanel(type = "tabs",
                      tabPanel("Plot", 
                               br(),
                               plotOutput("distPlot"),
                               h3("Predicted Value from  Model 1: "),
                               textOutput("pred1"),
                               h3("Predicted Value from  Model 2: "),
                               textOutput("pred2"),
                               br(),
                               ),
                      tabPanel("Summary", 
                               br(),
                               h4("Statistical data of cases of heart conditions obtained from 
                                  https://www.kaggle.com/code/tawejssh/heart-failure-prediction/notebook."),
                               br(),
                               verbatimTextOutput("summary")),
                      tabPanel("Table", 
                               br(),
                               tableOutput("table"))
          )
      )
    )
))
```

## Code server.R

```{r echo=TRUE, eval=FALSE}
library(shiny)
shinyServer(function(input, output) {
  dataset <- read.csv("heart_failure_clinical_records_dataset.csv", 
                      header = TRUE, sep = ",", dec = ".")
  
  model1 <- lm(time ~ age, data = dataset)
  model2 <- lm(time ~ age + DEATH_EVENT, data = dataset)
  
  model1pred <- reactive({
    showData()
    mpginput <- input$age_range
    predict(model1, newdata = data.frame(age = mpginput))
  })
  
  model2pred <- reactive({
    showData()
    mpginput <- input$age_range
    deathinput <- ifelse(input$ifhf, 1, 0)
    predict(model2, newdata = data.frame(age = mpginput, DEATH_EVENT = deathinput))
  })
  
  filteredDF <- reactive({
    dataset[dataset$age %in% input$age_range,]
  })
  
  showData <- reactive({
    if (input$all == TRUE)
    {
      output$summary <- renderPrint({
        summary(filteredDF())
      })
      
      output$table <- renderTable({
        filteredDF()
      })
    }else
    {
      output$summary <- renderPrint({
        summary(dataset)
      })
      
      output$table <- renderTable({
        dataset
      })
    }
  })
  
  output$distPlot <- renderPlot({
    showData()
    x    <- dataset$age
    bins <- seq(min(x), max(x), length.out = input$age_range + 1)
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Age of the patients in the sample",
         ylab = "Follow-up days",
         main = "Histogram of Heart Failure Clinical")
  })
  
  output$pred1 <- renderText({
    model1pred()
  })

  output$pred2 <- renderText({
    model2pred()
  })
})
```
