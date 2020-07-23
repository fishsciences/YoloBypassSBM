#' Rearing survival
#'
#' Rearing survival based on rearing time and daily survival
#'
#' @md
#' @param water_year_string    Water year (1997-2011) as a string
#' @param date_index           Index of date in a water year at start of rearing period; in all years except WY1997, equivalent to day of water year
#' @param abundance            Abundance at start of rearing period
#' @param duration             Number of days spent rearing
#' @param location             Rearing location: Delta or Yolo
#'
#' @export
#'

rearing_survival <- function(water_year_string, date_index, abundance, duration, location = c("Delta", "Yolo")){

  p <- rearing_survival_parameters[[location]]

  if (location == "Delta"){
    daily_survival <- p[["survival"]]
    if (simulation_parameters[["sim_type"]] == "stochastic") {
      daily_survival <- runif(length(duration), p[["min"]], p[["max"]])
    }
  } else {
    inundated_mean <- mapply(function(di, dur) mean(inundated_sqkm[[water_year_string]][di:(di + dur)]),
                             date_index, duration)
    daily_survival <- logistic(inundated_mean, p[["max"]], p[["steepness"]], p[["inflection"]], p[["min"]])
    # if duration is zero, then set survival to 1 to avoid potential problems with zeros
    daily_survival <- ifelse(duration == 0, 1, daily_survival)
  }
  overall_survival <- exp(log(daily_survival) * duration)
  final_abundance <- abundance * overall_survival
  # in the Delta, rearing survival is doubly stochastic (uniform and binomial)
  # in the Yolo Bypass, rearing survival is singly stochastic (binomial)
  if (simulation_parameters[["sim_type"]] == "stochastic"){
    final_abundance <- mapply(function(abun, ds) rbinom(n = 1, size = abun, prob = ds),
                              round(abundance), overall_survival)
  }
  return(final_abundance)
}
