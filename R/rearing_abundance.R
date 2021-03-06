#' Rearing abundance
#'
#' Number of individuals in cohort entrained onto Yolo Bypass that actually rears on the Yolo Bypass based on hypothetical logistic function with fork length
#'
#'
#' @md
#' @param abundance     Abundance of cohort at Fremot Weir
#' @param fork_length   Fork length (mm) at Fremont Weir
#'
#' @export
#'

rearing_abundance <- function(abundance, fork_length){

  p <- rearing_proportion_parameters
  proportion <- logistic(fork_length, p[["max"]], p[["steepness"]], p[["inflection"]], p[["min"]])

  if (simulation_parameters[["sim_type"]] == "stochastic"){
    rear_abun <- mapply(function(abun, prop) rbinom(n = 1, size = abun, prob = prop),
                        round(abundance), proportion)
  } else {
    rear_abun <- abundance * proportion
  }
  rear_abun
}


