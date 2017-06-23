end_date <- Sys.Date()
start_date <- floor_date(Sys.Date() - 2, unit = 'month')

# visualisations
infobox_with <- 3
width_buttons <- '140px'

# app settings
server_side <- TRUE

update_time <- 10

month_actual <- as.character(lubridate::month(Sys.Date(), label = TRUE, abbr = FALSE))