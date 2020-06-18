library(shiny)
library(ggplot2)
library(plotly)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    datasets <- list(iris=iris, airquality=airquality, mtcars=mtcars, trees=trees, rock=rock)
    
    
    data <- reactive({
        datasets[[input$data]]
    })
    
    output$datasetSelector <- renderUI({
        selectInput("data", "Dataset", names(datasets))
    })
    output$xVarSelector <- renderUI({
        selectInput("xval", "X Variable", names(data())[sapply(data(), FUN = is.numeric)]) 
    })
    output$colorVarSelector <- renderUI({
        selectInput("colorVal", "Color Variable", names(data())[sapply(data(), FUN = is.factor())]) 
    })
    output$yVarSelector <- renderUI({
        selectInput("yval", "Y Variable",names(data())[sapply(data(), FUN = is.numeric)], selected=names(data())[2]) 
    })
    
    
    
    output$myPlot <- renderPlot({
        df <- data()
        if(input$mode == "k-means"){
            df <- df[,c(input$xval, input$yval)]
            df <- na.omit(df)
            k <-  kmeans(df, input$clust)
            cluster <- as.factor(k$cluster)
            centers <- as.data.frame(k$centers)
            centers$color= as.factor(1:nrow(centers))
            ggplot(data=df, aes(x=df[,1], y=df[,2])) + 
                geom_point(aes(color=cluster), alpha=0.5, size=2) + 
                geom_point(data=centers, inherit.aes = F, aes(x=centers[,1], y=centers[,2], color=color), 
                           shape=3, size=5) + 
                theme_bw() + labs(x=input$xval, y=input$yval, title = "k-mean clustering") 
        }else{
            df <- na.omit(df)
            d <- dist(df, method = "euclidean") # distance matrix
            fit <- hclust(d, method="ward.D2")
            plot(fit, xlab ="observation") # display dendogram
            groups <- as.factor(cutree(fit, k=input$clust)) # cut tree into 5 clusters
            rect.hclust(fit, k=input$clust, border="red")
        }
    })

})
