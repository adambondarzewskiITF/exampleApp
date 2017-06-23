data_length <- length(state.abb)

prepare_column <- function(len, values) {
  sample(values, size = len, replace = T) 
}  

prepare_column_numeric <- function(len) {
  round(rnorm(len, mean = 20, sd = 5), 0)
}  

DT_formatted <- data.table(     Publisher = prepare_column(  values = c('Publisher1', 'Publisher2')
                                                           , len = data_length)
                              , Day = prepare_column(  values = seq(  from = as.Date('2017-05-01')
                                                                    , to = Sys.Date()
                                                                    , by = '1 day')
                                                       , len = data_length)
                              , Channel = 'SEM'
                              , AID = prepare_column(  values = c(1532, 1294)
                                                       , len = data_length)
                              , ProductGroup = prepare_column(  values = c('product_1', 'product_2', 'product_3')
                                                              , len = data_length)
                              , Country = prepare_column(  values = c('country_1', 'country_2', 'country_3')
                                                           , len = data_length)
                              , AccountId = prepare_column(  values = c('acc _id_1', 'acc_id_2')
                                                           , len = data_length)
                              , AccountDescriptiveName =  prepare_column(  values = c('acc _name_1', 'acc_name_2')
                                                                           , len = data_length)
                              , CampaignName =  prepare_column(  values = c('campaign _name_1', 'campaign_name_2')
                                                                            , len = data_length)
                              , Impressions = prepare_column_numeric(data_length)
                              , ClicksPublisher = prepare_column_numeric(data_length)
                              , ConversionsPublisher = prepare_column_numeric(data_length)
)

# path
DT_formatted[.N, Day := Sys.Date()]

DT_formatted[, number_of_week := week(Day)]
DT_formatted[, WeekStart := min(Day), by = number_of_week]
DT_formatted[, Month := paste(year(Day), month(Day), sep = '_')]