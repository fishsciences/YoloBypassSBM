#' Initial cohort abundance
#'
#' Initial cohort abundances based on water year and Chinook run
#'
#' @md
#' @param chinook_run          Run timing classification: Fall, LateFall, Winter, Spring
#' @param water_year_string    Water year 1997-2011 as a string
#'
#' @export
#'

initial_cohort_abundance <- function(chinook_run, water_year_string){

  abun <- annual_abundance[[chinook_run]][[water_year_string]]
  prop <- knights_landing_timing[[chinook_run]][[water_year_string]]

  if (simulation_parameters[["sim_type"]] == "stochastic") {
    daily_abun <- rmultinom(n = 1, size = abun, prob = prop)[, 1]
  } else {
    daily_abun <- prop * abun
  }
  daily_abun
}
