library(plotly)
library(shiny)
library(ggplot2)
library(gapminder)
library(DT)



shinyUI(fluidPage(
  titlePanel("Gapminder Data Shiny app"),
  
  sidebarLayout(
    sidebarPanel("Choose an indicator (a Continent) and a year range to compare indicators graphically.
                 By default it will display plot for all the countries of the continent listed in the dataset. 
                 You can select countries to compare from the legend in the Plot. The selected data set can be downloaded in a csv format.",
                 hr(),
                 radioButtons("variable_from_gapminder",
                              label = h5("Variable:"),
                              choices = c("Population" = "pop",
                                          "Life Expectancy" = "lifeExp",
                                          "GDP Per Capita" = "gdpPercap"),
                              selected = "pop"),
                 hr(),
                 uiOutput("choose_continent"),
#                 conditionalPanel(condition ="input.menu1" == "country",
#                                checkboxGroupInput("sample", "Check for Country Selection:",
#                                                   choices = country),
#                                checkboxInput("bulk", "Select All", value=TRUE))),

                 sliderInput("year_range",
                             label = h5("Range of years:"),
                             min = 1952,
                             max = 2007,
                             value = c(1952, 2007), 
                             format = "####", 
                             sep="",
                             step = 5),

                downloadButton("download_data")),

mainPanel(h3(textOutput("output_continent_years")),
  
  # Output: Tabset w/ plot, summary, and table ----
  tabsetPanel(type = "tabs",
              tabPanel("Plot", plotlyOutput("ggplot_gdppc_vs_continent")),
              tabPanel("Table", DTOutput("gapminder_table"))
  ))
  )
))