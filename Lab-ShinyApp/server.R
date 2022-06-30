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
