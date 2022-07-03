#
# Application with allows to predict at what age it is more likely to suffer from 
# a heart condition.
# 
# The data source has been extracted from this URL:
# https://www.kaggle.com/code/tawejssh/heart-failure-prediction/notebook
#

library(shiny)
shinyServer(function(input, output) {
  
  dataset <- read.csv("heart_failure_clinical_records_dataset.csv", header = TRUE, sep = ",", dec = ".")
  
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
