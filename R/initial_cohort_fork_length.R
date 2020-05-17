#' Initial cohort fork length
#'
#' Initial cohort fork length based on model day and Chinook run
#'
#' @md
#' @param chinook_run          Run timing classification: Fall, LateFall, Winter, Spring
#' @param water_year_string    Water year (1997-2011) as a string
#' @param date_index           Index of date in a water year that cohort enters the model; in all years except WY1997, equivalent to day of water year
#' @param sim_type             Simulation type: deterministic or stochastic
#'
#' @export
#'

initial_cohort_fork_length <- function(chinook_run, water_year_string, date_index, sim_type){

  params = knights_landing_fl_params[[chinook_run]][[water_year_string]]

  if (sim_type == "stochastic") {
    fork_length <- mapply(function(fl, sd) rlnorm(1, fl, sd),
                          params[["MeanLog"]][date_index],
                          params[["SDLog"]][date_index])
  } else {
    fork_length <- exp(params[["MeanLog"]][date_index])
  }
  fork_length
}
