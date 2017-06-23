info_box_output_wrapper <- function (outputId, width = infobox_with) {
  infoBoxOutput(outputId, width = width)
}

prepare_aggregate <- function(cols_for_aggregation
                              , DT) {
  
  
  DT_out <- DT[, .(
    Impressions = sum2(Impressions)
    , ClicksPublisher = sum2(ClicksPublisher)
    , ConversionsPublisher = sum2(ConversionsPublisher)
  )
  , by = cols_for_aggregation]
  
  return(DT_out)
}

return_indexes_columns <- function(DT,names) {
  which(names(DT) %in% names)
}

get_subset <- function(condition, DT) {
  
  condition_call <- substitute(condition)
  r <- eval(condition_call, DT)
  DT[r, .(
      ConversionsPublisher = sum2(ConversionsPublisher)
  )]
}

get_cols_from_checkbox <- function(aggregation_checkbox_input) {
  
  aggregate_cols <- as.vector(unlist(aggregation_checkbox_input ) )
  
  return(aggregate_cols)
}
