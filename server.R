# Coursera Data Science Specialization
# Developing Data Product Final Project

# Caret package train(..., method = "rf") does not deploy to shiny server


library(shiny)
library(ggplot2)
library(plotly)
library(caret)
library(randomForest)

shinyServer(function(input, output) {

    # plot distribution of the feature
    output$distPlot_o <- renderPlotly( {

        name_feature <- input$feature_i

        if(name_feature %in% c("am", "vs", "gear", "carb", "cyl")) {

          dt_plot <- data.frame(col = factor(mtcars[[name_feature]]) )

          gg1 <- ggplot(dt_plot, aes(x = col)) +
                  geom_bar(col = 'black', fill = "blue", width = 0.5) +
                  theme_bw() +
                  theme(title = element_text(size = 13, face = "bold"),
                  axis.text=element_text(size = 10),
                  axis.title=element_text(size = 11,face = "bold")) +
                  labs(title = paste0("Distribution of ", name_feature), x = name_feature)

          ggplotly(gg1)

        } else {

          dt_plot <- data.frame(col = mtcars[[name_feature]] )

          gg1 <- ggplot(dt_plot, aes(x = col)) +
            geom_histogram(col = 'black', fill = "blue") +
            theme_bw() +
            theme(title = element_text(size = 13, face = "bold"),
                  axis.text=element_text(size = 10),
                  axis.title=element_text(size = 11,face = "bold")) +
            labs(title = paste0("Distribution of ", name_feature), x = name_feature)

          ggplotly(gg1)
        }
    })

    # plot fit results

    pred_lm <- reactive({

      mod_formula <- formula(paste0("mpg ~ ", input$feature_i))

      if(input$check_lm_i){
        pred_lm <- predict(lm(data = mtcars, mod_formula))
        dt_plot1 <- data.frame(y = mtcars$mpg, x = mtcars[[input$feature_i]],
                               y_ft = pred_lm, model = as.character(rep("Linear Regression", nrow(mtcars))))
      } else { dt_plot1 <- NULL }

    })

    pred_rf <- reactive({

      mod_formula <- formula(paste0("mpg ~ ", input$feature_i))

      if(input$check_rf_i){
        # pred_rf <- predict(train(data = mtcars, mod_formula, method = "rf"))
        pred_rf <- predict(randomForest(data = mtcars, mod_formula))
        dt_plot2 <- data.frame(y = mtcars$mpg, x = mtcars[[input$feature_i]],
                               y_ft = pred_rf, model = as.character(rep("Random Forest", nrow(mtcars))))
      } else { dt_plot2 <- NULL }

    })


    output$regPlot_o <- renderPlotly( {
       dt_plot <- rbind(pred_lm(), pred_rf())

       if(!is.null(dt_plot)) {
         
         gg2 <- ggplot(dt_plot, aes(x = x, y = y)) +
           facet_wrap( .~ model) +
           geom_point(col = "black") +
           geom_point(aes(x = x, y = y_ft, col = model)) +
           labs(y = "mpg", x = input$feature_i, title = "Actual (Black) v. Fitted (Colored) Values of MPG ") +
           theme_bw() +
           theme(title = element_text(size = 13, face = "bold"),
                 axis.text = element_text(size = 10),
                 axis.title = element_text(size = 11, face = "bold")) +
           theme(strip.text = element_text(colour = "blue", face = "bold", size = 13)) +
           theme(legend.position="none") 
          
         ggplotly(gg2)
           
       } else {
         plotly_empty()
       }

    })
    
    output$text_lm_o <- renderText(ifelse(input$check_lm_i, 
                                          paste0("SSE by Linear Regression: ",
                                                 round(sum((pred_lm()$y - pred_lm()$y_ft)^2), 2) ) , "" )
    )

    output$text_rf_o <- renderText(ifelse(input$check_rf_i, 
                                          paste0("SSE by Random Forest: ",
                                                 round(sum((pred_rf()$y - pred_rf()$y_ft)^2), 2) ), "" )
    )

})
