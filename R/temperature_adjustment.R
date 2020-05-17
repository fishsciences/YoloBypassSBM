#' Adjust rearing time based on temperature
#'
#' Rearing time after potentially truncating based on temperature threshold
#'
#' @md
#' @param water_year_string    Water year (1997-2011) as a string
#' @param date_index           Index of date in a water year at start of rearing period; in all years except WY1997, equivalent to day of water year
#' @param duration             Maximum numbr of rearing days
#' @param location             Rearing location: Yolo or Delta
#'
#' @export
#'
#'

temperature_adjustment <- function(water_year_string, date_index, duration, location){
  # this function is not vectorized

  # Temperature adjustment
  thresh <- rearing_time_parameters[[location]][["thresh"]]
  temps_all <- floodplain_temperature[[location]][[water_year_string]]

  if (duration == 0) return(0)
  date_index_end <- date_index + duration

  # truncate rearing time to end of time period where input data available
  if (date_index_end > length(temps_all)) date_index_end <- length(temps_all)
  temps_sub <- temps_all[date_index:date_index_end]

  # temps above threshold on every day
  if (all(temps_sub > thresh)) return(0)

  # mininum of exceed_indices is first day that temp was over threshold in the max potential rearing period
  exceed_indices <- which(temps_sub > thresh)
  return(ifelse(length(exceed_indices) > 0, min(exceed_indices), length(temps_all[date_index:date_index_end])))
}

