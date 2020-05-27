#' Yolo Bypass rearing time
#'
#' Yolo Bypass rearing time after adjusting indirectly for passage time and directly for temperature
#'
#' @md
#' @param water_year_string    Water year (1997-2011) as a string
#' @param date_index           Index of date in a water year that cohort begins Yolo rearing; in all years except WY1997, equivalent to day of water year
#'
#' @export
#'
#'

rearing_time_yolo <- function(water_year_string, date_index){

  params = rearing_time_parameters[["Yolo"]]
  fd <- flood_duration[[water_year_string]][date_index]
  rt_fd <- exp(params[["inter"]] + params[["slope"]] * fd)

  if (simulation_parameters[["sim_type"]] == "stochastic"){
    rt_fd <- sapply(rt_fd, function(rt) MASS::rnegbin(n = 1, mu = rt, theta = params[["theta"]]))
  }

  # subtracting a user-defined number of passage days
  # to account for fact that Takata relationship included
  # passage time as well as (presumably) rearing time
  rt_vals <- rt_fd - params[["passage_days"]]
  rt_vals <- ifelse(rt_vals < 0, 0, rt_vals)

  mapply(function(di, dur) temperature_adjustment(water_year_string, di, dur, "Yolo"), date_index, rt_vals)
}

