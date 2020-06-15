#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#if (!dir.exists("data")) {
#    dir.create('data')
#}
#download.file("https://www.kaggle.com/aman1py/gapminder?select=gapminder_tidy.csv",
 #             destfile = "data/gapminder_data.csv")


library(plotly)
library(shiny)
library(ggplot2)
library(gapminder)
library(DT)


#Load Gapminder Data
data <- gapminder

#Readable Population
data$pop <- data$pop/1000000
data$lifExp <- round(data$lifeExp, 2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # Drop-down selection box generated from Gapminder dataset
    output$choose_continent <- renderUI({
        selectInput("continent_from_gapminder", 
                    h5("Continent"),
                    as.list(levels(data$continent), 
                    selected="Asia"))
    })
    one_continent_data  <- reactive({
        if(is.null(input$continent_from_gapminder)) {
            return(NULL)
        }
        
            subset(data, continent == input$continent_from_gapminder & 
                       year >= input$year_range[1] & year <= input$year_range[2] )
    })
    output$gapminder_table <- renderDT({ 
        one_continent_data()
        
    })
    
    output$download_data <- downloadHandler(
        filename = "gapminderdata.csv",
        content = function(file) {
            write.csv(one_continent_data(), file, row.names = FALSE)
        }
    )
    
    output$output_continent_years <- renderText({
        paste(input$continent_from_gapminder,":" ,
              min(input$year_range), "-", max(input$year_range))
    })
    output$output_continent <- renderText({
        if (is.null(input$continent_from_gapminder)){
            return(NULL)
        }
        paste("Continent selected", input$continent_from_gapminder)
    })
    
    # Render ggplot plot based on variable input from radioButtons
    output$ggplot_gdppc_vs_continent <- renderPlotly({
        
        if(is.null(one_continent_data()$year)){
            return(NULL)
        }
        
        if(input$variable_from_gapminder == "pop") y_axis_label <- "Population (millions)"
        if(input$variable_from_gapminder == "lifeExp") y_axis_label <- "Life Expectancy (years)"
        if(input$variable_from_gapminder == "gdpPercap") y_axis_label <- "GDP Per Capita, PPP (fixed 2005 international $)"
        
       
        g <- ggplot(one_continent_data(), aes_string(x = "year",y = input$variable_from_gapminder)) +
            geom_point(aes(color=country)) +
            geom_smooth(aes(fill= country), method="lm", formula= y~x) +
            xlab("Year") +
            ylab(y_axis_label)
        ggplotly(g)
    
    })
    
    
})