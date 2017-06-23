source('load_packages.R')
source('functions.R')
source('prepare_logger.R')
source('settings.R')
source('load_data.R')

countries_all <<- unique(DT_formatted[, Country])
product_groups_all <<- unique(DT_formatted[, ProductGroup])
aids_all <<- unique(DT_formatted[, AID])

publishers_all <<- unique(DT_formatted[, Publisher])

countries_start <<- 'IT'
product_groups_start <<- 'hair'
publishers_start <<- c('Publisher1', 'Publisher2')

#' Fun returns names to hide. Table to display should be named DT_display and it should be in global env
#'
#' @param publ_col 
#'
#' @return
#' @export
#'
#' @examples
get_names_to_hide <- function(DT_fun = DT_display, publ_col = 'Publisher') {
  
  setdiff(
      names(DT_formatted)
    , c(  'Day', 'Publisher', 'ProductGroup', 'Country'
          , 'ClicksPublisher', 'ConversionsPublisher')
  )

}
