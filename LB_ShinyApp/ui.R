
library(shiny)
#varList <- names(mtcars)
mtcarsPCA <- prcomp(mtcars)
mtcarsPCA <- as.data.frame(mtcarsPCA$x)
#varList <- colnames(mtcarsPCA)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Clustering of R datasets"),
    a("click here for documentation", href="https://lbrodier87.github.io/DataProductsWeek4LB/Documentation_LB_ShinyApp.html"),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            uiOutput("datasetSelector"),
            uiOutput("xVarSelector"),
            uiOutput("yVarSelector"),
            radioButtons('mode', "Clustering method", choices = c("k-means", "hclust")),
            sliderInput("clust", "nb clusters", min = 1, max=10, value = 3)
        ),
        
        mainPanel(
            plotOutput("myPlot"),
            textOutput("varList")
        )
    )
))
