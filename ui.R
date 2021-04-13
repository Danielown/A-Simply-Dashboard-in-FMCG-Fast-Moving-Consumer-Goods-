
header <- dashboardHeader(
    title = "Banten Grocery Value"
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem(
            text = "Overview",
            tabName = "overview",
            icon = icon("box")
        ),
        menuItem(
            text = "Banten Map & Cluster",
            tabName = "bantenvalue",
            icon = icon("map")
        ),
        menuItem(
            text = "Data",
            tabName = "data",
            icon = icon("book")
        ),
        menuItem("About Me", icon = icon("linkedin"), 
                 href = "https://www.linkedin.com/in/daniel-lumban-gaol-b91099190/"
        ),
        menuItem("Github", icon = icon("github"), 
                 href = "https://github.com/Danielown"
        )
    )
)

#TAB 1

body <- dashboardBody(
    tabItems(
        tabItem(
            tabName = "overview",
            fluidPage(
                h2(tags$b("Banten Market Share Grocery (FMCG)")),
                br(),
                div(style = "FMCG",
                    p("(FMCG)Fast-moving consumer goods are products that sell quickly
                      at relatively low cost. These goods are also called consumer packaged goods.",
                      "FMCGs have a short shelf life because of high consumer demand
                      (e.g., soft drinks and confections) or because they 
                      are perishable (e.g., meat, dairy products, and baked goods)"),
                    br()
                )
            ),
            
            fluidPage(
                box(
                    title = tags$b("Information :"),
                    width = 12, 
                    
                    selectInput(
                        inputId = "kecamatan",
                        label = "Kecamatan:",
                        choices = banten$Kecamatan,
                        selected = TRUE
                    ),       
                    
                    valueBoxOutput(
                        outputId = "total_toko", width = 4 
                    ),
                    
                    valueBoxOutput(
                        outputId = "avg_transaksi", width = 4 
                    ),
                    
                    valueBoxOutput(
                        outputId = "avg_max", width = 4 
                    )
                )
            ),

            fluidPage(
                tabBox( width = 12,
                        title = tags$b(" Top 10 Omset Area Per Kecamatan & Kelurahan"),
                        id = "tabset1",
                        side = "right",
                        tabPanel(tags$b("Kelurahan"),
                                 plotlyOutput("plot_kel")
                        ),
                        tabPanel(tags$b("Kecamatan"),
                                 plotlyOutput("plot_kec")
                        )

                    )

                ),
            
            fluidPage(
                tabBox( width = 12,
                        title = tags$b(" Top 10 Omset Average/Grocery Of Kecamatan"),
                        id = "tabset1",
                        side = "right",
                        tabPanel(tags$b(""),
                                 plotlyOutput("lineplot_kec"))
                    
    
                )
            )
        ),
    
        
        #TAB 2
        
        tabItem(
            tabName = "bantenvalue",
            fluidPage(
                box(width = 12,
                    solidHeader = T,
                    h3(tags$b("Banten Value of Each Kecamatan")),
                    leafletOutput("leaflet", height = 530))
               
            ),
            
            fluidPage(
                box(
                    title = "Distribution Correlation",
                    width = 12,
                    plotlyOutput(
                        outputId = "month_dist"
                    )
                )
            ),
            
            fluidPage(
                box(
                    title = "Cluster Omset/Kecamatan",
                    width = 9,
                    radioButtons(
                        inputId = "clust_kec",
                        label = "Select The Cluster",
                        choices = c("A","B","C","D","E"), inline = T),
                    
                    plotlyOutput(outputId = "plot_clust"
                        
                    
                )
            ),
                
                box(width = 3,
                    height = 525,
                    h3("Clustering"),
                    div(style = "text-align:justify",
                        p("On the chart the clustering values
                    of each Kecamatan are shown the class of the average 
                    range of transactions"),
                  br(),
                  h3("The Type of Cluster is"),
                  p(tags$b(" A = <= 100K, B = >100K - <= 300K, C = >300K - <= 1 M, D = >1M - <= 5M, E = >5M")),
                  br(),
                  h3("Push The Omset Of Grocery"),
                  p("After we know the clustering of the Omset each Kecamatan, now we can determine the 
                    dropsize Omset value target in each Kecamatan of Banten")
                   
                    )
                    
                )
        )
    ),
        
        
        
        
        
        #TAB 3
        
        tabItem(tabName = "data",
                 fluidRow(box(DT::dataTableOutput("table"),
                   title = "DATASET",
                   width = 12)
                   ))
    
        
    )
)


dashboardPage(
    header = header,
    body = body,
    sidebar = sidebar,
    skin = "yellow"
)
