
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(caret)
library(randomForest)

assign("carClasses", c("Acceptable","Good","Unacceptable","Very Good"), envir = .GlobalEnv)

getEvaluationModal <- function() {
  download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/car/car.data",destfile = "carClass.csv")
  carsData <- read.csv("carClass.csv")
  names(carsData) <- c("buyPrice","maintenancePrice","doors","passenger","luggage","safety","class")
  trainIdx<-createDataPartition(y=carsData$class, p=0.95,list=F)
  training<-carsData[trainIdx,] 
  testing<-carsData[-trainIdx,] 
  
  trainCtrl <- trainControl(method = "cv", number = 3, allowParallel = TRUE, verboseIter = TRUE)
  carsModel <- train(class ~ ., data = training, method = "rf", trControl=trainCtrl)
  carsModel
}

carsModel <- getEvaluationModal()

findCarClass <- function(bPrice,mPrice,doors,passenger,luggage,safety) {
  df1 <- data.frame(buyPrice = bPrice, maintenancePrice = mPrice, 
                    doors = doors, passenger = passenger,
                    luggage = luggage, safety = safety)
  
  res <- predict(carsModel, newdata = df1)
  #cat(res)
  carClasses[res]
}

shinyServer(function(input, output) {
 
  output$buyPrice <- renderText({input$bprice})
  output$maintenancePrice <- renderText({input$mprice})
  output$doors <- renderText({input$ndoors})
  output$passenger <- renderText({input$passenger})
  output$luggage <- renderText({input$luggage})
  output$safety <- renderText({input$safety})
  
  test <- reactive({
    t1 <- data.frame(input$bprice,input$mprice,input$ndoors,input$passenger,input$luggage,input$safety)
    names(t1) <- c("Buying Price","Maintenance Price","No of Doors","Passenger Capacity","Luggage Boot Space","Safety")
    return(t1)
  })
  output$inData <- renderTable({ test() },include.rownames=FALSE)
  output$result <- renderText({ findCarClass(input$bprice,input$mprice,input$ndoors,input$passenger,input$luggage,input$safety) })
  })
