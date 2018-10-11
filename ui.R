# Coursera Data Science Specialization
# Developing Data Product Final Project


library(shiny)
library(plotly)
library(caret)


# Define UI for application
shinyUI(fluidPage(

  # Application title
  titlePanel("Predicting MPG with One Feature Using Linear Regression or Random Forest"),

  sidebarLayout(

    sidebarPanel(
        h3("Introduction"),
        h5("This app uses one feature to predict miles per gallon (mpg).\n
           Please select one feature out of 10 features from mtcars data set, \n
           then select either linear regression or random forest or both for prediction."),
        h3("STEP ONE: Select Feature"),
        h5("Select one feature from the drop-down menu. The feature you selected will be the input/predictor of the ML algorithm."),
        selectInput("feature_i", "Feature:", choices = names(mtcars)[-1], selected = "hp"),
        submitButton("Update Plot", icon("refresh1")),
        h3("STEP TWO: Select Algorithm(s)"),
        h5("Check the algorithm(s) you want to apply to predict mpg."),
        checkboxInput("check_lm_i", "Linear Regression", value = TRUE),
        checkboxInput("check_rf_i", "Random Forest", value = FALSE),
        # selectInput("model_i", "Algorithm(s):", choices = c("Linear Regression", "Random Forest"),
        #             multiple = TRUE, selected = "Linear Regression"),
        submitButton("Update Algorithm", icon("refresh2"))
        ),


    mainPanel(
        h3("Distribution of the feature"),
        plotlyOutput("distPlot_o"),
        h3("Algorithm Fit"),
        textOutput("text_lm_o"),
        textOutput("text_rf_o"),
        plotlyOutput("regPlot_o")

    )
  )
))
