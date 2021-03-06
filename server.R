
server <- function(input, output, session) {
  
  
  updateNewCode <- reactive({
    codeData <- lifeData
    codeData <- codeData[codeData$Entity %in% input$newEntity,]
    updateSelectInput(session, "newCode", choices = codeData$Code, selected = codeData$Code)
  })
  observe({
     updateNewCode()
  })
  
  
  #Update the dataset based on the input
  newLifeData <- reactive({
  #  req(input$updateLifeChart)
    lifeData <- dbReadTable(con, "mergedTable")
    lifeData %>% filter(Entity %in% input$updateLifeChartA | Entity %in% input$updateLifeChartB |
                        Entity %in% input$updateLifeChartC | Entity %in% input$updateLifeChartDE|
                        Entity %in% input$updateLifeChartFG| Entity %in% input$updateLifeChartHJ|
                        Entity %in% input$updateLifeChartKL| Entity %in% input$updateLifeChartM |
                        Entity %in% input$updateLifeChartNO| Entity %in% input$updateLifeChartPR|
                        Entity %in% input$updateLifeChartS | Entity %in% input$updateLifeChartTZ)
  })
  
  observeEvent(input$clearEntity, {
    updateSelectInput(session, "updateLifeChartA", 
                      choices = unique(lifeData[grep("^A", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartB", 
                      choices = unique(lifeData[grep("^B", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartC", 
                      choices = unique(lifeData[grep("^C", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartDE", 
                      choices = unique(lifeData[grep("^D|^E", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartFG", 
                      choices = unique(lifeData[grep("^F|^G", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartHJ", 
                      choices = unique(lifeData[grep("^H|^I|^J", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartKL", 
                      choices = unique(lifeData[grep("^K|^L", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartM", 
                      choices = unique(lifeData[grep("^M", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartNO", 
                      choices = unique(lifeData[grep("^N|^O", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartPR", 
                      choices = unique(lifeData[grep("^P|^Q|^R", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartS", 
                      choices = unique(lifeData[grep("^S", lifeData$Entity),]$Entity), selected = NULL)
    updateSelectInput(session, "updateLifeChartTZ", 
                      choices = unique(lifeData[grep("^T|^U|^V|^W|^X|^Y|^Z", lifeData$Entity),]$Entity), selected = NULL)
  })
  

  
  output$lifeChart <- renderPlot({
    ggplot(newLifeData()) +
      geom_line(aes(x=Year, y=lifeExpectancy, color=Entity), size = 1.5) +
      theme_classic(base_size = 15) + ggtitle("Year vs Life Expectancy") +
      theme(plot.title = element_text(hjust = 0.5), text = element_text(size = 20)) +
      ylab(names(axisSelect)[match("lifeExpectancy", axisSelect)])
  })

  output$inputGraph <- renderPlot({
    ggplot(newLifeData()) +
      geom_line(aes(x=newLifeData()[[input$changeX]], y=newLifeData()[[input$changeY]], color=Entity), size = 1.5) +
      xlab(names(axisSelect)[match(input$changeX, axisSelect)]) +
      ylab(names(axisSelect)[match(input$changeY, axisSelect)]) +
      theme_classic(base_size = 15) + ggtitle(paste(names(axisSelect)[match(input$changeX, axisSelect)], 
                                      names(axisSelect)[match(input$changeY, axisSelect)], sep = " vs ")) +
      theme(plot.title = element_text(hjust = 0.5), text = element_text(size = 20))
  })
  
  #Creates a heatmap with the data
  output$heatmap <- renderPlot({
    ggplot(newLifeData() %>% filter(Year > 1950), aes(Entity, Year)) + 
      geom_tile(aes(fill = lifeExpectancy), color = "black") + 
      labs(fill = "Life Expectancy") +
      scale_fill_gradient(low = "red", high = "blue") +
      theme_classic(base_size = 15) + ggtitle("Life Expectancy per Year by Entity") +
      theme(plot.title = element_text(hjust = 0.5), text = element_text(size = 20),)
            #axis.text.x = element_text(angle = 5, hjust = 0.5))
  })
  
  output$pieChart <- renderPlot({
    ggplot(newLifeData() %>% filter(Year == 2010)) +
      geom_bar(aes(x=Year, y=bananaYields, fill = Entity), stat = "identity") +
      coord_polar("y", start = 0) +
      theme_void() + ggtitle("Distribution of Banana Yields in 2010") +
      theme(plot.title = element_text(hjust = 0.5), text = element_text(size = 20))
  })

  #Checks for valid input to the database
  observeEvent(input$submitNewEntry, {
    if(!is.na(as.numeric(input$newExpectancy)) && !is.na(as.numeric(input$newChildMortality))){
      if(as.numeric(input$newExpectancy) >= 0 && as.numeric(input$newExpectancy) <= 124){
        if(as.numeric(input$newChildMortality) >= 0 && as.numeric(input$newChildMortality) <= 100){
          if(!is.na(as.numeric(input$newYear))){
            
            #Updates the database with the new entry
            output$submitMessage <- renderText({"Submission added"})
            lifeData <- add_row(lifeData, Entity = input$newEntity, Year = as.numeric(input$newYear), Code = input$newCode,
                              lifeExpectancy = as.numeric(input$newExpectancy), childMortality = as.numeric(input$newChildMortality))
          
            dataUpdate <- "data.db"
            con <- dbConnect(drv = RSQLite::SQLite(), dbname = dataUpdate)
            dbWriteTable(con, "mergedTable", lifeData, overwrite = TRUE)
          }else{
            output$submitMessage <- renderText({"Error: Year must be a number"})
          }
        }else{
          output$submitMessage <- renderText({"Error: Enter a valid child mortality (0-100)"})
        }
      }else{
        output$submitMessage <- renderText({"Error: Enter a valid life expectancy (0-124)"})
      }
    }else{
      output$submitMessage <- renderText({"Error: Life expectancy and child mortality must be numbers"})
    }
    
  })
}