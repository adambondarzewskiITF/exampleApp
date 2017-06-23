library(shiny)

shinyServer(function(input, output, session) {
  
  ### LAST UPDATE TIME
  autoInvalidateLast_Update_Time <- reactiveTimer( update_time * 60 * 1000, session ) # 1 * 60 * 1000 = co 1 minut
  
  observe({
    # Invalidate and re-execute this reactive expression every time the
    # timer fires.
    autoInvalidateLast_Update_Time()
    
    source('load_data.R')
    
    # zwracam do ui
    last_update <- Sys.time()
    
    # zwracam do clienta(ui.R)
    output$last_update <- renderText({ 
      sprintf("Last update: %s", last_update )
    })
  })
  
  
  # last month

  
  output$conversions <- renderInfoBox({
    
    infoBox(
      sprintf("Conversions Publisher %s", month_actual), format(get_stats()$stats$ConversionsPublisher, big.mark = ' '), icon = icon("list", lib = "glyphicon"),
      color = "blue", fill = TRUE
    )
  })
  
  

  
  # today

  
  output$conversions_tod <- renderInfoBox({
    
    infoBox(
      sprintf("Conversions Publisher %s", 'today'), format(get_stats()$stats_today$ConversionsPublisher, big.mark = ' '), icon = icon("list", lib = "glyphicon"),
      color = "blue", fill = FALSE
    )
  })
  
  get_available_c <- reactive({
    
    date_range <- as.Date(input$date_interval)
    start_date <- date_range[1]
    end_date <- date_range[2]
    
    # DT_aux for aggregated Cost and speed
    output <- sort(
      unique(DT_formatted[  Publisher %in% input$publishers_selected  
                            & ProductGroup %in% input$product_groups_selected & Day >= start_date & Day <= end_date, Country])
    )
    
    return(output)
  })
  
  get_available_pg <- reactive({
    
    date_range <- as.Date(input$date_interval)
    start_date <- date_range[1]
    end_date <- date_range[2]
    
    # DT_aux for aggregated Cost and speed
    output <- sort(
      unique(DT_formatted[  Publisher %in% input$publishers_selected  
                            & Day >= start_date & Day <= end_date, ProductGroup])
    )
    
    return(output)
  })
  
  output$filter_c <- renderUI(
    radioButtons('countries_selected', 'Selected countries'
                 , choices = get_available_c()
                 , selected = get_available_c()[1]
    )
  )
  
  output$filter_pg <- renderUI(
    selectizeInput(
      'product_groups_selected', 'Selected product groups'
      , choices = get_available_pg()
      , selected = get_available_pg()[1]
      , multiple = FALSE
      , options = list(plugins = list('remove_button', 'drag_drop'))
    )
  )
  
  # dates - I want the same dates in three input fields
  
  # LAST_n_days
  
  observeEvent(input$today, {
    updateDateRangeInput(
      session
      , inputId = 'date_interval'
      , start = as.character(Sys.Date())
      , end = as.character(Sys.Date()))
  })
  
  observeEvent(input$yesterday, {
    updateDateRangeInput(
      session
      , inputId = 'date_interval'
      , start = as.character(Sys.Date() - 1)
      , end = as.character(Sys.Date() - 1))
  })
  
  observeEvent(input$last_3_days, {
    updateDateRangeInput(
      session
      , inputId = 'date_interval'
      , start = as.character(Sys.Date() - 2)
      , end = as.character(Sys.Date() - 0))
  })
  
  observeEvent(input$last_7_days, {
    updateDateRangeInput(
      session
      , inputId = 'date_interval'
      , start = as.character(Sys.Date() - 6)
      , end = as.character(Sys.Date() - 0))
  })
  
  observeEvent(input$this_month, {
    
    start_date_new <- floor_date(Sys.Date(), 'month')
    end_date_new <- Sys.Date()
    
    start_date_new <- as.character(start_date_new)
    end_date_new <- as.character(end_date_new)
    
    updateDateRangeInput(
      session
      , inputId = 'date_interval'
      , start = start_date_new
      , end = end_date_new
    )
  })
  
  observeEvent(input$previous_month, {
    
    start_date_new <- floor_date(Sys.Date() - months(1), 'month')
    end_date_new <- start_date_new + days_in_month(start_date_new) - 1
    
    start_date_new <- as.character(start_date_new)
    end_date_new <- unname(as.character(end_date_new)) # important: does not work for vectors with names    
    
    updateDateRangeInput(
      session
      , inputId = 'date_interval'
      , start = start_date_new
      , end = end_date_new
    )
  })
  
  # info boxes
  # for infoboxes
  get_stats <- reactive({
    
    publishers_selected <<- input$publishers_selected
    
    stats <- get_subset(Day >= floor_date(Sys.Date(), 'month') & (Publisher %in% publishers_selected), DT_formatted)
    stats_today <- get_subset(Day == Sys.Date() & (Publisher %in% publishers_selected), DT_formatted)    
    
    return(list(stats = stats, stats_today = stats_today))
  }) # to ma wartości z poprzedniego wywołania, jakby z opóźnieniem 1 :D
  
  observeEvent(input$clear_countries_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'countries_selected_aggregate'
      , choices = countries_all
      , selected = NULL)
  })
  
  observeEvent(input$clear_product_groups_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'product_groups_selected_aggregate'
      , choices = product_groups_all
      , selected = NULL)
  })
  
  observeEvent(input$choose_all_countries_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'countries_selected_aggregate'
      , choices = countries_all
      , selected = countries_all)
  })
  
  observeEvent(input$choose_all_product_groups_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'product_groups_selected_aggregate'
      , choices = as.list(product_groups_all)
      , selected = product_groups_all)
  })
  
  observeEvent(input$clear_countries_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'countries_selected_aggregate'
      , choices = countries_all
      , selected = NULL)
  })
  
  observeEvent(input$clear_product_groups_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'product_groups_selected_aggregate'
      , choices = product_groups_all
      , selected = NULL)
  })
  
  observeEvent(input$clear_aids_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'aids_selected_aggregate'
      , choices = aids_all
      , selected = NULL)
  })
  
  observeEvent(input$choose_all_countries_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'countries_selected_aggregate'
      , choices = countries_all
      , selected = countries_all)
  })
  
  observeEvent(input$choose_all_product_groups_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'product_groups_selected_aggregate'
      , choices = as.list(product_groups_all)
      , selected = product_groups_all)
  })
  
  observeEvent(input$choose_all_aids_aggregate, {
    updateSelectizeInput(
      session
      , inputId = 'aids_selected_aggregate'
      , choices = aids_all
      , selected = aids_all)
  })

  output$main_table <- DT::renderDataTable({
    
    # updating table after defined time period
    autoInvalidateLast_Update_Time()
    
    current_date <- as.character(Sys.Date())
    
    row_call_back <- JS(sprintf('function(row, data) {
                                if (String(data[1]) == "%s")
                                $("td", row).css("color", "grey");
  }', current_date))
        
    
    # doesn't work without container
    footer_call_back <- JS(
      
      "function( tfoot, data, start, end, display ) {",
      "var api = this.api();",
      "var cols_sum = [19, 9];",
      "cols_count = cols_sum.length;",
      "for (var i = 0; i < cols_count; i++){",
      "$( api.column( cols_sum[i] ).footer() ).html(",
      "api.column( cols_sum[i] ).data().reduce( function ( a, b ) {",
      "return (a + b);",
      "} )",
      ");",
      "}",
      "}")
    
    footer_call_back <- NULL
    
    # updating filters
    date_range <- as.Date(input$date_interval)
    start_date <- date_range[1]
    end_date <- date_range[2]
    
    countries_selected <<- input$countries_selected
    product_groups_selected <<- input$product_groups_selected
    publishers_selected <<- input$publishers_selected
    
    DT_display <- DT_formatted[Day >= start_date & Day <= end_date
                               & Country %in% countries_selected 
                               & ProductGroup %in% product_groups_selected
                               & Publisher %in% publishers_selected]
    
    DT_display <- prepare_aggregate(c('Day', 'Country', 'ProductGroup')
                                    , DT_display)
    
    cols_hidden <- get_names_to_hide(DT_fun = DT_display)
    
    produce_datatable(DT_display, cols_colour = c(), cols_hidden = return_indexes_columns(DT_display, c(cols_hidden, 'CombinedEpl', 'e_zysk'))
                      , page_length = 60, cols_bold = 1:2
                      , row_call_back = row_call_back
                      , footer_call_back = footer_call_back) %>%
      formatCurrency('ConversionsPublisher', interval = 3, currency = '', before = FALSE, digits = 0) %>%
      formatCurrency('ClicksPublisher', interval = 3, currency = '', before = FALSE, digits = 0)
}, server = server_side
    )
  
  output$aggregate <- DT::renderDataTable({
    
    # updating table after defined time period
    autoInvalidateLast_Update_Time()
    
    # updating filters
    date_range <- as.Date(input$date_interval)
    start_date <- date_range[1]
    end_date <- date_range[2]
    
    countries_selected_aggregate <<- input$countries_selected_aggregate
    product_groups_selected_aggregate <<- input$product_groups_selected_aggregate
    publishers_selected_aggregate <<- input$publishers_aggregate
    aids_selected_aggregate <<- input$aids_selected_aggregate
    
    DT_display <- DT_formatted[    Day >= start_date & Day <= end_date
                                   & Publisher %in% publishers_selected_aggregate
                                   & Country %in% countries_selected_aggregate
                                   & ProductGroup %in% product_groups_selected_aggregate
                                   & AID %in% aids_selected_aggregate]
    
    cols_for_aggregation <- get_cols_from_checkbox(input$aggregation_checkbox)
    DT_display <- prepare_aggregate(cols_for_aggregation, DT_display)
    
    produce_datatable(  DT_display, cols_colour = c()
                        , cols_hidden = return_indexes_columns(  DT_display
                                                                 , setdiff(  get_names_to_hide(DT_fun = DT_display)
                                                                             , get_cols_from_checkbox(input$aggregation_checkbox)))
                        , page_length = 60, cols_bold = c()) %>%
      formatCurrency('ConversionsPublisher', interval = 3, currency = '', before = FALSE, digits = 0) %>%
      formatCurrency('ClicksPublisher', interval = 3, currency = '', before = FALSE, digits = 0)
  }, server = server_side
  )

  output$pivot_table <- renderRpivotTable({
    
    # updating table after defined time period
    autoInvalidateLast_Update_Time()
    
    date_range <- as.Date(input$date_interval)
    start_date <- date_range[1]
    end_date <- date_range[2]
    
    rpivotTable(  data =  DT_display,  rows = c( "Country"), cols = c("ProductGroup")
                  , vals = "ConversionsPublisher", aggregatorName = "Sum", rendererName = "Heatmap", color = 'blue')
  })
}
)
