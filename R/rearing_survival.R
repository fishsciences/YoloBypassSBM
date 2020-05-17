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
#' @param sim_type             Simulation type: deterministic or stochastic
#'
#' @export
#'

rearing_survival <- function(water_year_string, date_index, abundance, duration, location = c("Delta", "Yolo"), sim_type){

  p <- rearing_survival_parameters[[location]]

  if (location == "Delta"){

    daily_survival <- p[["survival"]]

    if (sim_type == "stochastic") {
      daily_survival <- runif(length(duration), p[["min"]], p[["max"]])
    }

  } else {

    inundated_mean <- mapply(function(di, dur) mean(inundated_sqkm[[water_year_string]][di:(di + dur)]),
                             date_index, duration)

    daily_survival <- logistic(inundated_mean, p[["max"]], p[["steepness"]], p[["inflection"]], p[["min"]])

    # if duration is zero, then set survival to 1 to avoid potential log(0)
    daily_survival <- ifelse(duration == 0, 1, daily_survival)

    if (sim_type == "stochastic"){
      # dividing by abundance to get stochastic daily survival that is turned into overall survival below
      daily_abundance <- mapply(function(abun, ds) rbinom(n = 1, size = abun, prob = ds),
                                round(abundance), daily_survival)
      # trying to catch problem values so we end up with zero rather than NaN
      # setting survival to 1 following same logic as above
      daily_survival <- ifelse(abundance == 0, 1, daily_abundance/abundance)
    }

  }
  abundance * exp(log(daily_survival) * duration)
}
