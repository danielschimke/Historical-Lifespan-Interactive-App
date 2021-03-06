

  
ui <- dashboardPage(
    dashboardHeader(title = "Country Data Analysis"),
    dashboardSidebar(
      sidebarMenu(id = "sidebar",
        menuItem("Main", tabName = "life", icon = icon("heartbeat")),
        menuItem("Add Entry", tabName = "newEntry", icon = icon("file")),
        conditionalPanel(
          condition = "input.sidebar == 'life'",
          style = "position:fixed;width:inherit;",
          selectInput("changeX", label = "X Axis:",
                      choices = axisSelect, 
                      width = 210),
          selectInput("changeY", label = "Y Axis:", 
                      choices = axisSelect, 
                      width = 210),
          actionButton("clearEntity", label = "Clear All")
        )
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "life",

          h2("Historical Statistical Analysis"),
          h3(""),
          h4("Filter by Country/Entity:"),
          fluidRow(
            box(
              width = 2,
              background = "red",
              selectInput("updateLifeChartA", label = "A", multiple = TRUE,
                               choices = unique(lifeData[grep("^A", lifeData$Entity),]$Entity),
                               selected = NULL)
            ),
            box(
              width = 2,
              background = "orange",
              selectInput("updateLifeChartB", label = "B", multiple = TRUE,
                                 choices = unique(lifeData[grep("^B", lifeData$Entity),]$Entity),
                                 selected = NULL)
            ),
            box(
              width = 2,
              background = "yellow",
              selectInput("updateLifeChartC", label = "C", multiple = TRUE,
                                 choices = unique(lifeData[grep("^C", lifeData$Entity),]$Entity),
                                 selected = NULL)
            ),
            box(
              width = 2,
              background = "green",
              selectInput("updateLifeChartDE", label = "D-E", multiple = TRUE,
                                 choices = unique(lifeData[grep("^D|^E", lifeData$Entity),]$Entity),
                                 selected = NULL)
            ),
            box(
              width = 2,
              background = "blue",
              selectInput("updateLifeChartFG", label = "F-G", multiple = TRUE,
                          choices = unique(lifeData[grep("^F|^G", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              background = "purple",
              selectInput("updateLifeChartHJ", label = "H-J", multiple = TRUE,
                          choices = unique(lifeData[grep("^H|^I|^J", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
          ),
          fluidRow(
            box(
              width = 2,
              background = "purple",
              selectInput("updateLifeChartKL", label = "K-L", multiple = TRUE,
                          choices = unique(lifeData[grep("^K|^L", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              background = "blue",
              selectInput("updateLifeChartM", label = "M", multiple = TRUE,
                          choices = unique(lifeData[grep("^M", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              background = "green",
              selectInput("updateLifeChartNO", label = "N-O", multiple = TRUE,
                          choices = unique(lifeData[grep("^N|^O", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              background = "yellow",
              selectInput("updateLifeChartPR", label = "P-R", multiple = TRUE,
                          choices = unique(lifeData[grep("^P|^Q|^R", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              background = "orange",
              selectInput("updateLifeChartS", label = "S", multiple = TRUE,
                          choices = unique(lifeData[grep("^S", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
            box(
              width = 2,
              background = "red",
              selectInput("updateLifeChartTZ", label = "T-Z", multiple = TRUE,
                          choices = unique(lifeData[grep("^T|^U|^V|^W|^X|^Y|^Z", lifeData$Entity),]$Entity),
                          selected = NULL)
            ),
          ),

          plotOutput("inputGraph"),
          h3(""),
          plotOutput("lifeChart"),
          h3(""),
          plotOutput("heatmap"),
          h3(""),
          plotOutput("pieChart")
          
        ),
        tabItem(tabName = "newEntry",
          h3("Add a New Entry to the Database"),
          box(
            width = 5,
            background = "blue",
            
          selectInput("newEntity", label = "Entity:", choices = unique(lifeData$Entity)),
          fluidRow(
            box(
              background = "blue",
              selectInput("newCode", label = "Code:", choices = NULL),
            ),
            box(
              background = "blue",
              textInput("newYear", label = "Year:", placeholder = "####"),
            )
          ),
          fluidRow(
            box(
              background = "blue",
              textInput("newExpectancy", label = "Life Expectancy:", placeholder = "in years...")
            ),
            box(
              background = "blue",
              textInput("newChildMortality", label = "Child Mortality Rate:", placeholder = "Ex. 56 for 56%")
            )
          ),
          actionButton("submitNewEntry", label = "Submit")
          ),
          span(textOutput("submitMessage"), style="color:red")
          
        )
      )
    )

)

shinyUI(ui)