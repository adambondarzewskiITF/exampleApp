options(shiny.trace=F)

dashboardPage(skin='green',
              dashboardHeader(title = 'exampleApp',
                              dropdownMenu(type = 'messages',
                                           messageItem(
                                             from = 'adambondarzewski@gmail.com',
                                             message = 'Test Message'
                                           )
                              )),
              dashboardSidebar(
                sidebarMenu(
                  dateRangeInput(inputId = 'date_interval',
                                 label = 'Date range',
                                 # start = start_date
                                 start = as.character(start_date),
                                 end = as.character(Sys.Date()),
                                 min = as.character(start_date),
                                 max = as.character( Sys.Date())
                  ),
                  tags$form(
                    HTML("&nbsp"), HTML("&nbsp"), actionButton('today', 'TODAY', width = width_buttons),
                    br(),
                    HTML("&nbsp"), HTML("&nbsp"), actionButton('yesterday', 'YESTERDAY', width = width_buttons),
                    br(),
                    HTML("&nbsp"), HTML("&nbsp"), actionButton('last_3_days', 'LAST_3_DAYS', width = width_buttons),
                    br(),
                    HTML("&nbsp"), HTML("&nbsp"), actionButton('last_7_days', 'LAST_7_DAYS', width = width_buttons),
                    br(),
                    HTML("&nbsp"), HTML("&nbsp"), actionButton('this_month', 'THIS_MONTH', width = width_buttons),
                    br(),
                    HTML("&nbsp"), HTML("&nbsp"), actionButton('previous_month', 'PREVIOUS MONTH', width = width_buttons)
                  ),
                    menuItem('Aggregation', tabName = 'aggregation', icon = icon('bars'))
                  , menuItem('Pivot Table', tabName = 'pivot_table', icon = icon('table'))
                  , br()
                  , br()
                  , textOutput('last_update')
                )),
              dashboardBody(
                tags$head(
                  tags$style( type = 'text/css', '#pivot_table{ overflow-x: scroll; }'),
                  tags$link(rel = 'icon', type = 'image/png', href = 'adwords.png'),
                  tags$title('AdwordsStats')),
                
                tags$style(HTML('
                                /* http://stackoverflow.com/questions/31711307/how-to-change-color-in-shiny-dashboard */
                                
                                .box.box-solid.box-primary>.box-header {
                                color:#fff;
                                background:#00A65A
                                }
                                
                                .box.box-solid.box-primary{
                                border-bottom-color:green;
                                border-left-color:green;
                                border-right-color:green;
                                border-top-color:green;
                                }
                                
                                /* zakladki w tabset */
                                .nav-tabs-custom .nav-tabs li.active {
                                border-top-color: #00A65A;
                                }
                                ')),
                
                tabItems(
                  tabItem(tabName = 'days',
                          fluidRow(
                             info_box_output_wrapper("conversions")
                          ),
                          fluidRow(
                             info_box_output_wrapper("conversions_tod")
                          ),
                          fluidRow(
                            column(width = 2,
                                   sidebarMenu(
                                     shinyjs::useShinyjs(), # part of RESET BUTTON feature
                                     id = 'side-panel',     # part of RESET BUTTON feature
                                     box( # EXAMPLE BOX
                                       title = 'Filters',
                                       status = 'primary', solidHeader = TRUE, collapsible = F,
                                       width = 'auto', height = 'auto',
                                       selectizeInput(
                                         'publishers_selected', 'Publishers'
                                         , choices = publishers_all
                                         , selected = publishers_start
                                         , multiple = TRUE
                                         , options = list(plugins = list('remove_button', 'drag_drop'))
                                       ),
                                       uiOutput('filter_pg')
                                       , uiOutput('filter_c')
                                     )
                                   )
                            )
                            ,
                            column(width = 9,
                                   box(
                                     title = 'Adwords Stats', status = 'primary', solidHeader = TRUE, collapsible = F, 
                                     width = 'auto', height = 'auto',
                                     DT::dataTableOutput('main_table')
                                   )
                            )
                          )
                  )
                  , tabItem(tabName = 'aggregation',
                            fluidRow(
                              column(width = 2,
                                     sidebarMenu(
                                       shinyjs::useShinyjs(),
                                       id = 'side-panel',
                                       box( # EXAMPLE BOX
                                         title = 'Filters_aggregates',
                                         status = 'primary', solidHeader = TRUE, collapsible = F,
                                         width = 'auto', height = 'auto',
                                         selectizeInput(
                                           'publishers_aggregate', 'Selected publishers'
                                           , choices = publishers_all
                                           , selected = publishers_all
                                           , multiple = TRUE
                                           , options = list(plugins = list('remove_button', 'drag_drop'))
                                         ),
                                         selectizeInput(
                                           'aids_selected_aggregate', 'Selected AIDs'
                                           , choices = aids_all
                                           , selected = aids_all
                                           , multiple = TRUE
                                           , options = list(maxOptions = 150, plugins = list('remove_button', 'drag_drop'))
                                         ),
                                         actionButton('clear_aids_aggregate', 'Clear'),
                                         actionButton('choose_all_aids_aggregate', 'Choose all'),
                                         
                                         selectizeInput(
                                           'product_groups_selected_aggregate', 'Selected product groups'
                                           , choices = product_groups_all
                                           , selected = product_groups_all
                                           , multiple = TRUE
                                           , options = list(plugins = list('remove_button', 'drag_drop'))
                                         ),
                                         actionButton('clear_product_groups_aggregate', 'Clear'),
                                         actionButton('choose_all_product_groups_aggregate', 'Choose all')
                                         , br(), br(), br(),
                                         
                                         selectizeInput(
                                           'countries_selected_aggregate', 'Selected countries'
                                           , choices = countries_all
                                           , selected = countries_all
                                           , multiple = TRUE
                                           , options = list(plugins = list('remove_button', 'drag_drop'))
                                         ),
                                         actionButton('clear_countries_aggregate', 'Clear'),
                                         actionButton('choose_all_countries_aggregate', 'Choose all')
                                         
                                         , checkboxGroupInput('aggregation_checkbox', label = 'Columns for aggregation', 
                                                              choices = list(  ProductGroup = 'ProductGroup'
                                                                               , Country = 'Country'
                                                                               , Account = 'AccountDescriptiveName'
                                                                               , Campaign = 'CampaignName'
                                                                               , Month = 'Month'
                                                                               , WeekStart = 'WeekStart'
                                                                               , Day = 'Day'
                                                                               , AID = 'AID'
                                                                               , MckName = 'MckName'
                                                                               , Publisher = 'Publisher'),
                                                              selected = list(ProductGroup = 'ProductGroup', Country = 'Country', 'AccountDescriptiveName'
                                                                              , CampaignName = 'CampaignName', Month = 'Month') )
                                       )
                                     )
                                     
                              )
                              ,
                              column(width = 9,
                                     box(
                                       title = 'Adwords Stats', status = 'primary', solidHeader = TRUE, collapsible = F,
                                       width = 'auto', height = 'auto',
                                       DT::dataTableOutput('aggregate')
                                       # textOutput('aggregate')
                                     )
                              )
                            )
                  )
                  , tabItem('pivot_table',
                            fluidRow(
                              rpivotTableOutput('pivot_table', width = 'auto', height = 'auto')
                            )
                  )
                )
                )
                )
