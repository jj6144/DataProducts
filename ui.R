
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/car/car.data",destfile = "carClass.csv")
carsData <- read.csv("carClass.csv")
names(carsData) <- c("buyPrice","maintenancePrice","doors","passenger","luggage","safety","class")

shinyUI(fluidPage(

  # Application title
  #titlePanel("Car Evaluation"),
  h1("Car Evaluation", align = "center"),
  hr(),
  br(),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput('bprice', 'Buy Price', levels(carsData$buyPrice)),
      selectInput('mprice', 'Maintenance Price', levels(carsData$maintenancePrice)),
      selectInput('ndoors', 'Number of Doors', levels(carsData$doors)),
      selectInput('passenger', 'Passernger Capacity', levels(carsData$passenger)),
      selectInput('luggage', 'Luggage Boot Space', levels(carsData$luggage)),
      selectInput('safety', 'Safety', levels(carsData$safety))
      #actionButton("goButton","Submit")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      #h2("Evaluation Result", align = "center"),
      h4("Your Input Data", align = "left"),
      tableOutput('inData'),
      h4("Your Car Class", align = "left"),
      textOutput('result'),
      br(),
      h4("Instructions"),
      p("This application creates a model that evaluates cars according to six attributes 
        and classifies into four categories such as \"Unacceptable\", \"Acceptable\", \"Good\" and \"Very Good\". The attributes used are"),
      tags$ol(
        tags$li("Buying Price"), 
        tags$li("Maintenance Price"), 
        tags$li("Number of Doors"),
        tags$li("Passenger Capacity"),
        tags$li("Luggage Boot Size"),
        tags$li("Safety of Car")
      )
      
    )
  )
))
