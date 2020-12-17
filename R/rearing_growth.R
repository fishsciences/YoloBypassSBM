#' Rearing growth
#'
#' Returns final wet_weight given initial wet_weight, model day, and duration
#'
#' @md
#' @param water_year_string    Water year (1997-2011) as a string
#' @param date_index           Index of date in a water year at start of rearing period; in all years except WY1997, equivalent to day of water year
#' @param duration             Duration (days) of rearing period
#' @param location             Rearing location: Yolo or Delta
#' @param wet_weight           Wet weight (g) at start of rearing period
#'
#' @export
#'

rearing_growth <- function(water_year_string, date_index, duration, location, wet_weight){

  helper <- function(di, dur){
    mean(floodplain_temperature[[location]][[water_year_string]][di:(di + dur)])
  }

  temp <- mapply(helper, date_index, duration)

  x = growth(wet_weight, temp, duration)
  runif(x, x*0.9, x*1.1) # draw from uniform distribution of +/-10%
}
