#' Delta rearing time
#'
#' Delta rearing time after adjusting for passage time and temperature
#'
#' @md
#' @param water_year_string    Water year (1997-2011) as a string
#' @param date_index           Index of date in a water year that cohort begins Delta rearing; in all years except WY1997, equivalent to day of water year
#' @param passage_time         Passge time
#' @param fork_length          Average fork length (mm) of cohort
#' @param sim_type             Simulation type: deterministic or stochastic
#'
#' @export
#'
#'

rearing_time_delta <- function(water_year_string, date_index, passage_time, fork_length, sim_type){

  params = rearing_time_parameters[["Delta"]]
  flow <- freeport_flow[[water_year_string]][date_index]
  rt_fd <- exp(params[["inter"]] + params[["flow"]] * flow + params[["fork_length"]] * fork_length)

  if (sim_type == "stochastic"){
    rt_fd <- sapply(rt_fd, function(rt) MASS::rnegbin(n = 1, mu = rt, theta = params[["theta"]]))
  }

  # subtracting passage time b/c relationship for rearing time includes passage and rearing
  rt_vals <- rt_fd - passage_time
  rt_vals <- ifelse(rt_vals < 0, 0, rt_vals)

  mapply(function(di, dur) temperature_adjustment(water_year_string, di, dur, "Delta"), date_index, rt_vals)
}

