function(input, output) {
    

    
    
    
# -------- TAB 1   
    
    reactive_kecamatan <- reactive({
        banten %>% 
            filter(Kecamatan == input$kecamatan)
    })
    
    
    reactive_cluster <- reactive({
        cluster_long %>% 
            filter(Cluster == input$clust_kec)
    })
    
    output$total_toko <- renderValueBox({
        
        value_total_toko <- reactive_kecamatan() %>%
            pull(`Rata rata`) %>%
            length()
        
        valueBox(
            value = value_total_toko,
            subtitle = "Total Grocery",
            icon = icon("chart-bar"),
            color = "teal", width = 4
        )
        
    })
    
    output$avg_transaksi <- renderValueBox({
        
        value_avg_toko <- reactive_kecamatan() %>%
            pull(`Rata rata`) %>%
            median() %>% 
            round(2)
        
        valueBox(
            value = value_avg_toko,
            subtitle = "Average Omset Transaction/Grocery",
            icon = icon("balance-scale"),
            color = "fuchsia", width = 4
        )
        
    })
    
    output$avg_max <- renderValueBox({
        
        value_avg_toko <- reactive_kecamatan() %>%
            pull(`Rata rata`) %>%
            max() 
        
        valueBox(
            value = value_avg_toko,
            subtitle = "The Highest Grocery Transaction Avg",
            icon = icon("money"),
            color = "purple", width = 4
        )
        
    })
    
    
    
    output$plot_kec <- renderPlotly({
        
        kec <- banten %>% 
            group_by(Kecamatan) %>% 
            summarise(total_avg_kec = sum(`Rata rata`)) %>% 
            arrange(desc(total_avg_kec)) %>% 
            mutate(text = paste0("total_avg_kec: ", total_avg_kec," M")) %>% 
            head(10)
        
        kec_plot <- kec %>% 
            ggplot(aes(x = total_avg_kec, y = reorder(Kecamatan, total_avg_kec),
                       text = text))+
            geom_col(aes(fill = total_avg_kec))+
            labs(title = "Top 10 Kecamatan",
                 x = "Avg Omzet Value",
                 y = NULL)+
            scale_x_continuous(breaks = seq(from = 5e7, to = 25e7,
                                            by = 5e7),
            labels = number_format(scale=1e-6,suffix = "M"))+
            scale_fill_gradient(low = "#D9ECC7", high = "#07A3B2")+
        theme(legend.position = "none")+
        theme(plot.title = element_text(
            face = "bold", size = 14, hjust = 0.04),
            axis.ticks.y = element_blank(),
            panel.background = element_rect(fill = "#ffffff"),
            panel.grid.major.x = element_line(colour = "grey"),
            axis.line.x = element_line(color = "grey"),
            axis.text = element_text(size = 10, colour = "black")
        )
        
         ggplotly(kec_plot, tooltip ="text" )
        
    })
   
    output$plot_kel <- renderPlotly({
        
        kel <- banten %>% 
            group_by(Kelurahan) %>% 
            summarise(total_avg_kel = as.numeric(sum(`Rata rata`))) %>% 
            arrange(desc(total_avg_kel)) %>% 
            mutate(text = paste0("total_avg_kel: ", total_avg_kel," M")) %>% 
            head(10)
        
        
        kel_plot <- kel %>% 
            ggplot(aes(x = total_avg_kel, y = reorder(Kelurahan, total_avg_kel),text = text))+
            geom_col(aes(fill = total_avg_kel))+
            labs(title = "Top 10 Kelurahan",
                 x = "Avg Omzet Value",
                 y = NULL)+
            scale_x_continuous(breaks = seq(from = 3e7, to = 25e7,
                                            by = 5e7),
                               labels = number_format(scale=1e-6,suffix = "M"))+
            scale_fill_gradient(low = "#F2ECB6", high = "#A96F44")+
            theme(legend.position = "none")+
            theme(plot.title = element_text(
                face = "bold", size = 14, hjust = 0.04),
                axis.ticks.y = element_blank(),
                panel.background = element_rect(fill = "#ffffff"),
                panel.grid.major.x = element_line(colour = "grey"),
                axis.line.x = element_line(color = "grey"),
                axis.text = element_text(size = 10, colour = "black")
            )
 
        ggplotly(kel_plot, tooltip = "text")

        
    })
    
    output$lineplot_kec <- renderPlotly({
    
    kec_plotly <- ggplot(long_kec, aes(x = value_month <- factor(value_month, levels = 
                                        c("Oktober","November","Desember"))
                                       , y = value, color = Kecamatan ))+
            geom_point()+
            geom_line(aes(group = Kecamatan))+
            scale_y_continuous(breaks = seq(1e5,5e5,5e4))+
            labs(title = "Kecamatan Frequency Transaction Of Quartal 4 2020",
                   subtitle = "Okt 2020 - Des 2020",
                   x = "Month",
                   y = "Average Value Per Month",
                   color = "") +
                   theme_bw()
        
        ggplotly(kec_plotly,tooltip = "y")
    
    })
    
# -------- TAB 2
    
    
    output$leaflet <- renderLeaflet({
        
        leaflet(data =banten ) %>% 
                    addProviderTiles(providers$Esri) %>%
                    addCircleMarkers(lng = ~Long,
                               lat = ~Lat,
                               clusterOptions = TRUE,
            popup = paste("<b>Nama Toko:</b>",banten$`Nama Toko`, "<br>",
                          "<b>Nomor Customer:</b>",banten$`No Cust`, "<br>",
                          "<b>Kecamatan:</b>",banten$Kecamatan, "<br>",
                          "<b>Kelurahan:</b>",banten$Kelurahan, "<br>",
                          "<b>Average Trx:</b>",banten$`Rata rata`, "<br>"
                          
                          ))
                  

        })
    
    output$plot_clust <- renderPlotly({
        
        clust_p <- reactive_cluster() %>% 
                ggplot(aes(x = Kecamatan, y =Value, color = Kecamatan))+
                geom_col(aes(fill=Cluster))+
                theme(axis.title.x = element_blank())+
                labs(title = "Clustering Values",
                     x = "Kecamatan",
                     y = "Jumlah Toko")+
                theme(axis.text.x = element_blank())+
                theme(legend.position = "none")
            
        ggplotly(clust_p, tooltip = "x")
        
        
    })
    
    
    
    output$month_dist <- renderPlotly({
        
        scatter <- ggplot(scatt,aes(x = skala.transaksi, total))+
            geom_point(aes(col = Kecamatan))+
            geom_smooth(method = "lm")+
            scale_y_continuous(breaks = seq(from = 0, to = 25e7,
                                            by = 5e7),
                               labels = number_format(scale=1e-6,suffix = "M"))+
            theme_minimal()+
            labs(title = "Relation between Transaction and Omset Value",
                 x = "Grocery Transaction Scale/Kecamatan",
                 y = "Omset value") +
            theme(legend.position = "none")
        
        ggplotly(scatter)
        
    })
        

# -------- TAB 3    
    
    output$table <- DT::renderDataTable({
        datatable(banten, rownames = F, option = list(scrollX = T, "pageLength"= 5, lengthChange = F)) %>% 
            formatStyle(input$selected,
                        background = "blue",
                        fontWeight = "bold")
        
    })
    
    
    
    
    
}