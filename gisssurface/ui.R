library(shiny)
library(ggplot2)
library(plotly)
library(shinythemes)

# Downloading and Cleaning Data

#Data 1 = Global
globalData<- read.csv("global.csv",header = FALSE,sep = ",",skip = 3,na.strings = "***")
cnames <-readLines("global.csv",2)
cnames<-strsplit(cnames,",",fixed = TRUE)
names(globalData) <- cnames[[2]]
dataGlobal <- na.omit(globalData)

#Data 2 = North
northData<- read.csv("noth.csv",header = FALSE,na.strings = "***",skip = 3)
nnames <- readLines("noth.csv",2)
nnames <- strsplit(nnames,",",fixed = TRUE)
names(northData)<- nnames[[2]]
dataNorth <- na.omit(northData)

#Data 3 = South
soutData <- read.csv("south.csv",header = FALSE,na.strings = "***",skip = 3)
snames <- readLines("south.csv",2)
snames <- strsplit(snames,",",fixed = TRUE)
names(soutData) <- snames[[2]]
dataSouth <- na.omit(soutData)

#Data 4 = Zonal
zonalData <- read.csv("zonal.csv",header = FALSE,na.strings = "***",skip = 3)
znames <- readLines("zonal.csv",1)
znames<- strsplit(znames,",",fixed = TRUE) 
names(zonalData) <- znames[[1]]
dataZonal <- na.omit(zonalData)

shinyUI(fluidPage(theme=shinytheme("superhero"),tags$style("label{font-family: Trebuchet MS;}"),
                  
                  # Application title
                  titlePanel(title=h2("Surface Temperature Analysis GISS",align="center")),
                  
                  # Sidebar with a slider input for number of bins
                  sidebarLayout(
                      sidebarPanel(
                          radioButtons("poleInput",
                                       label = h3("Choose DataSet"),
                                       choices = list("Global Dataset"='dataGlobal',"South Pole Dataset"='dataSouth',"North Pole Dataset"='dataNorth',"Zonal Dataset"='dataZonal'),
                                       selected = 'dataGlobal'),
                          br(),br(),
                          sliderInput("YearRange",h3("Select Year Range"),min = 1880,max = 2019,value = c(1908,2002),step = 1,width=600,animate = TRUE),
                          br(),br(),
                          
                          selectInput("var",h3("Select Months"),
                                      choices = c("Jan"=2, "Feb"=3, "Mar"=4, "Apr"=5, 
                                                  "May"=6, "Jun"=7, "Jul"=8, "Aug"=9, 
                                                  "Sep"=10, "Oct"=11, "Nov"=12, "Dec"=13),
                                      multiple = TRUE, selected = c(2,3)
                          ),
                          br(),br()
                      ),
                      
                      # Show a plot of the generated distribution
                      mainPanel(
                          tabsetPanel(type="tab",
                                      tabPanel(h4("Summary"),verbatimTextOutput("sumry")),
                                      tabPanel(h4("Structure"),verbatimTextOutput("struct")),
                                      tabPanel(h4("Selected Data"),verbatimTextOutput("displayData")),
                                      tabPanel(h4("Scatter Plot"),plotOutput("mygraph")),
                                      tabPanel(h4("3d Scatter Plot"),plotlyOutput("mygraph2")))
                          
                          
                      ),
                      position = "right",
                      fluid = TRUE
                      
                  )
))
