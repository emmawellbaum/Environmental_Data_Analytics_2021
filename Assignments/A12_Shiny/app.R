#### Load packages ----
library(shiny)
library(tidyverse)

#### Load data ----
chemphys_data <- read_csv("Data/NTL-LTER_Lake_ChemistryPhysics_PeterPaul_Processed.csv", 
                          col_types=cols(lakeid='-', lakename='c', year4='-', 
                          daynum='-', month='D', 
                          sampledate ='D', depth='d', 
                          temperature_C='d', dissolvedOxygen='d', irradianceWater='d'))
#chemphys_data$sampledate <- as.Date(chemphys_data$sampledate, format = "%Y-%m-%d")
#chemphys_data <- chemphys_data %>%
   # select(lakename, sampledate:irradianceWater) 

#### Define UI ----
ui <- fluidPage(
    titlePanel("Chemical & Physical Limnology in Peter Lake and Paul Lake"),
    sidebarLayout(
        sidebarPanel(
            
            # Select nutrient to plot
            selectInput(inputId = "dropdown_input", 
                        label = "Data Element",
                        choices = c("Depth (ft)"="depth",
                                    "Temperature (c)"="temperature_C",
                                    "Dissolved Oxygen (mg/L)"="dissolvedOxygen",
                                    "Surface Irradiance (mol/m*2/s)"="irradianceWater"), 
                        selected = "Depth (ft)"),
            
        ),
        
        # Output
        mainPanel(
            plotOutput("scatterplotty")
        )))

#### Define server  ----
server <- function(input, output) {
    
    # Create a ggplot object for the type of plot you have defined in the UI  
    output$scatterplotty <- renderPlot({
        ggplot(chemphys_data, 
               aes_string(x = "sampledate", y = input$dropdown_input, 
                          fill = "depth", shape = "lakename")) +
            geom_point(alpha = 0.8, size = 2) +
            theme_classic(base_size = 14) +
            scale_shape_manual(values = c(21, 24)) +
            labs(x = "Date", shape = "Lake", fill = "Depth (ft)") +
            scale_fill_distiller(palette = "YlOrBr", guide = "colorbar", direction = 1)
        #scale_fill_viridis_c(option = "viridis", begin = 0, end = 0.8, direction = -1)
    })
    
    
}


#### Create the Shiny app object ----
shinyApp(ui = ui, server = server)


