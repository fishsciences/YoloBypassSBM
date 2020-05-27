#' Fish entrainment at Fremont Weir
#'
#' Draw random number of fish entrained at Fremont Weir based on model day and abundance at Fremont Weir
#'
#' @md
#'
#' @param water_year_string    Water year (1997-2011) as a string
#' @param date_index           Index of date in a water year that cohort enters the model; in all years except WY1997, equivalent to day of water year
#' @param abundance            Abundance of cohort at Fremont Weir
#'
#'
#' @export
#'

entrainment <- function(water_year_string, date_index, abundance){

  proportion <- fremont_weir_proportion[[water_year_string]][date_index]

  if (simulation_parameters[["sim_type"]] == "stochastic") {
    entrained <- mapply(function(abun, prop) rbinom(n = 1, size = abun, prob = prop),
                        round(abundance), proportion)
  } else {
    entrained <- proportion * abundance
  }
  list("Yolo" = entrained, "Sac" = abundance - entrained)
}
