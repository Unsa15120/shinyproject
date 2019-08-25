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

server <- function(input, output) {
    
    cols <- reactive({
        as.numeric(c(input$var))
        
    })
    mylabel <- reactive({
        if(input$poleInput=='dataGlobal'){
            lable <- "Plot for Global Data"
        }
        if(input$poleInput=='dataSouth'){
            lable <- "Plot for South Pole Data"
        }
        if(input$poleInput=='dataNorth'){
            lable <- "Plot for North Pole Data"
        }
        
        if(input$poleInput=='dataZonal'){
            lable <- "Plot for Zonal Data"
        }
        lable
    })
    
    
    myFinalData <- reactive({
        #------------------------------------------------------------------
        # Select data according to selection of ratdio button
        if(input$poleInput=='dataGlobal'){
            mydata <- dataGlobal
            
        }
        
        if(input$poleInput=='dataSouth'){
            mydata <- dataSouth
        }
        
        if(input$poleInput=='dataNorth'){
            mydata <- dataNorth
        }
        
        if(input$poleInput=='dataZonal'){
            mydata <- dataZonal
        }
        
        #------------------------------------------------------------------
        # Get data rows for selected year
        mydata1 <- mydata[mydata$Year >= input$YearRange[1], ] # From Year
        mydata1 <- mydata1[mydata1$Year <= input$YearRange[2], ] # To Year
        #------------------------------------------------------------------
        # Get Data for selected months as variable
        mydata2<- mydata1[, c(1, sort(cols()))]
        #------------------------------------------------------------------
        # Get data rows for selected year
        data.frame(mydata2)
        #------------------------------------------------------------------
        
    })
    
    # Prepare "Data tab"
    output$displayData <- renderPrint({
        myFinalData()
    })
    
    # Prepare Structure Tab
    renderstr <- reactive({ str(myFinalData())})
    
    output$struct <- renderPrint({
        renderstr()
    })
    
    # Prepare Summary Tab
    rendersumry <- reactive({ summary(myFinalData())})
    
    output$sumry <- renderPrint({
        rendersumry()
    })
    
    output$mygraph <- renderPlot({
        plotdata <- myFinalData()
        plot(plotdata,col=c(1,2,3,4,5,6,7,8,9,10,11,12),main = mylabel(),pch=16,cex=2)
    })
    
    
    output$mygraph2 <- renderPlotly({
        
        plotdata2 <- myFinalData()
        plot_ly(plotdata2,x=input$poleInput,y=input$var,size = 20,sizes = 20, z=input$var,type = "scatter3d",mode="markers",color = input$var,colors = c('#E74292','#01CBC6','#BB2CD9','#1287A5','#F5BCBA','#00CCCD','#487EB0','#218F76','#0A3D62','#E1DA00','#FAC42F','#4C4B4B'),
                marker=list(symbol='circle',sizemode='diameter',sizes=20,size=20))
        
        
    })
    
    
}
